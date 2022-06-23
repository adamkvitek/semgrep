module In = Input_to_core_j

let logger = Logging.get_logger [ __MODULE__ ]

(* copy and paste from JSON_report:81
 * TODO: refactor to some shared module: Metavariable.ml? *)
let metavar_string_of_any any =
  (* TODO: metavar_string_of_any is used in get_propagated_value
      to get the string for propagated values. Not all propagated
      values will have origintoks. For example, in
          x = 1; y = x + 1; ...
     we have y = 2 but there is no source location for 2.
     Handle such cases *)
  any |> Visitor_AST.ii_of_any
  |> List.filter Parse_info.is_origintok
  |> List.sort Parse_info.compare_pos
  |> Common.map Parse_info.str_of_info
  |> Matching_report.join_with_space_if_needed

(* from Run_semgrep *)
let mk_rule_table rules =
  let rule_pairs = Common.map (fun r -> (fst r.Rule.id, r)) rules in
  Common.hash_of_list rule_pairs

let extract_nested_lang ~match_hook ~timeout ~timeout_threshold
    (erules : Rule.extract_rule list) xtarget rule_ids =
  let erule_table = mk_rule_table erules in
  (* TODO: something like in iter_targets_and_get_matches_and_exn_to_errors?
   * Should respect memory limits, etc..
   *)
  let res =
    Match_rules.check
      ~match_hook:(fun s e m _ -> match_hook s e m)
      ~timeout ~timeout_threshold
      (Config_semgrep.default_config, [] (* no equiv *))
      (erules :> Rule.rules)
      xtarget
  in
  (* mode for combination *)
  (* match combine with
     | "separate" -> *)
  res.Report.matches
  (* want Common.filter_map? *)
  |> List.filter_map (fun m ->
         match
           Common.find_some_opt
             (fun (x, mvar) ->
               match
                 Hashtbl.find_opt erule_table m.Pattern_match.rule_id.id
               with
               | None -> None
               | Some r ->
                   let (`Extract { Rule.extract; _ }) = r.mode in
                   if x = extract then Some (r, Some mvar) else Some (r, None))
             m.Pattern_match.env
         with
         | Some (erule, Some extract_mvalue) ->
             (* Note: char/line offset should be relative to the extracted
              * portion, _not_ the whole pattern!
              *)
             let char_offset, line_offset, col_offset =
               Metavariable.mvalue_to_any extract_mvalue
               |> Visitor_AST.range_of_any_opt
               |> Option.map (fun (start_loc, _) ->
                      ( start_loc.Parse_info.charpos,
                        (* subtract 1 because lines are 1-indexed, so the offset is
                         * one less than the current line *)
                        start_loc.Parse_info.line - 1,
                        start_loc.Parse_info.column ))
               |> Option.get (* FIXME: handle *)
             in
             let contents =
               Metavariable.mvalue_to_any extract_mvalue
               |> metavar_string_of_any
             in
             logger#trace
               "Extract rule %s extracted the following from %s at line %d, \
                char %d\n\
                %s"
               m.rule_id.id m.file line_offset char_offset contents;
             let f : Common.dirname = Common.new_temp_file "extracted" m.file in
             Common2.write_file ~file:f contents;
             let target =
               {
                 In.path = f;
                 language =
                   (let (`Extract { Rule.dst_lang; _ }) = erule.mode in
                    dst_lang)
                   |> Lang.show;
                 rule_ids;
               }
             in
             (* Make result mapping function *)
             let map_loc (loc : Parse_info.token_location) =
               (* this _shouldn't_ be a fake location *)
               {
                 loc with
                 charpos = loc.charpos + char_offset;
                 line = loc.line + line_offset;
                 column =
                   (if loc.line = 1 then loc.column + col_offset
                   else loc.column);
                 file = xtarget.file;
               }
             in
             let map_res (mr : Report.partial_profiling Report.match_result) =
               {
                 Report.matches =
                   Common.map
                     (fun (m : Pattern_match.t) ->
                       {
                         m with
                         file = xtarget.file;
                         range_loc = Common2.pair map_loc m.range_loc;
                       })
                     mr.matches;
                 errors =
                   Common.map
                     (fun (e : Semgrep_error_code.error) ->
                       { e with loc = map_loc e.loc })
                     mr.errors;
                 skipped_targets =
                   Common.map
                     (fun (st : Output_from_core_t.skipped_target) ->
                       {
                         st with
                         path = (if st.path = f then xtarget.file else st.path);
                       })
                     mr.skipped_targets;
                 profiling = { mr.profiling with Report.file = xtarget.file };
               }
             in
             Some (target, map_res)
         | Some ({ mode = `Extract { extract; _ }; id = id, _; _ }, None) ->
             logger#warning
               "The extract metavariable for rule %s (%s) wasn't bound in a \
                match; skipping extraction for this match"
               id extract;
             None
         | None ->
             (* Cannot fail to lookup rule in hashtable just created from rules used for query *)
             raise Common.Impossible)
