(* Yoann Padioleau
 *
 * Copyright (C) 2010 Facebook
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)
open Common

module J = Json_type
module Json_out = Json_io
module Json_in = Json_io

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)
(*
 * The goal of this module is to provide data structures that can be
 * used to mimic the Microsoft Echelon[1] project which given a patch
 * try to run the most relevant tests that could be affected by the
 * patch. It is probably easier in interpreted languages such as PHP which
 * contain simple tracers/profilers.
 * 
 * We can even run the tests and says whether the new code has
 * been covered (like in MySql test infrastructure).
 * 
 * For now we just provide types for a mapping from
 * a source code file to a list of relevant test files. 
 * 
 * References:
 *  [1] http://research.microsoft.com/apps/pubs/default.aspx?id=69911
 *)

(*****************************************************************************)
(* Types *)
(*****************************************************************************)

(* relevant test files exercising source, with term-frequency of 
 * file in the test *)
type tests_coverage = (Common.filename, tests_score) Common.assoc
 and tests_score = (Common.filename * float) list
 (* with tarzan *)

(* Note that xdebug by default does not trace assignements but only 
 * function and method calls, which mean the list of lines returned
 * is an under-approximation. We compensate such an approximation by
 * also computing the static set of function/method calls so that
 * a coverage percentage can be computed.
 * 
 * update: with hphpi tracer, we actually also cover assignement and
 * this type is actually independent of such design decision.
 * It's line-based though, so don't expect complex path coverage
 * or MCDC stuff. Just simple line coverage ...
 *)
type lines_coverage = (Common.filename, file_lines_coverage) Common.assoc
 and file_lines_coverage = {
   covered_sites: int list;
   all_sites: int list;
 }
 (* with tarzan *)

(*****************************************************************************)
(* String of, json, etc *)
(*****************************************************************************)

(* This helps generates a coverage file that 'arc unit' can read *)
let (json_of_tests_coverage: tests_coverage -> J.json_type) = fun cov ->
  J.Object (cov |> List.map (fun (cover_file, tests_score) ->
    cover_file, 
    J.Array (tests_score |> List.map (fun (test_file, score) -> 
      J.Array [J.String test_file; J.String (spf "%.3f" score)]
    ))
  ))

(* todo: should be autogenerated by ocamltarzan *)
let (tests_coverage_of_json: J.json_type -> tests_coverage) = fun j ->
  match j with
  | J.Object (xs) ->
      xs |> List.map (fun (cover_file, tests_score) ->
        cover_file, 
        match tests_score with
        | J.Array zs -> 
            zs |> List.map (fun test_file_score_pair ->
              (match test_file_score_pair with
              | J.Array [J.String test_file; J.String str_score] ->
                  test_file, float_of_string str_score
                    
              | _ -> failwith "Bad json, tests_coverage_of_json"
              )
            )
        | _ ->  failwith "Bad json, tests_coverage_of_json"
      )
  | _ -> failwith "Bad json, tests_coverage_of_json"

(* todo: should be autogenerated by ocamltarzan *)
let (json_of_lines_coverage: lines_coverage -> J.json_type) = fun cov ->
  J.Object (cov |> List.map (fun (file, cover) -> 
    file, 
    J.Object ([
      (* I use short fieldnames to avoid generating a huge JSON file.
      *)
      "cov", J.Array (cover.covered_sites |> List.map (fun l -> J.Int l));
      "all", J.Array (cover.all_sites |> List.map (fun l -> J.Int l));
    ])
  ))

let (lines_coverage_of_json: J.json_type -> lines_coverage) = fun j ->
  match j with
  | J.Object (xs) ->
      xs |> List.map (fun (file, cover) ->
        file, 
        match cover with
        | J.Object ([
            "cov", J.Array covered_lines;
            "all", J.Array call_sites;
          ]) ->
            {
              covered_sites = 
                covered_lines |> List.map (function
                | J.Int l -> l
                | _ -> failwith "Bad json, files_coverage_of_json"
                );
              all_sites = 
                call_sites |> List.map (function
                | J.Int l -> l
                | _ -> failwith "Bad json, files_coverage_of_json"
                );
            }
        | _ ->  failwith "Bad json, files_coverage_of_json"
      )
  | _ -> failwith "Bad json, files_coverage_of_json"


let (save_tests_coverage: tests_coverage -> Common.filename -> unit) = 
 fun cov file -> 
   cov |> json_of_tests_coverage |> Json_out.string_of_json
   |> Common.write_file ~file

let (load_tests_coverage: Common.filename -> tests_coverage) = 
 fun file ->
   file |> Json_in.load_json |> tests_coverage_of_json


let (save_lines_coverage: lines_coverage -> Common.filename -> unit) = 
 fun cov file -> 
   cov |> json_of_lines_coverage |> Json_out.string_of_json
   |> Common.write_file ~file
   
let (load_lines_coverage: Common.filename -> lines_coverage) = 
 fun file ->
   file |> Json_in.load_json |> lines_coverage_of_json
