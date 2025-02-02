let parse_target file =
  Pfff_or_tree_sitter.run file [ TreeSitter Parse_csharp_tree_sitter.parse ]
    (fun x -> x)

let parse_pattern print_errors str =
  let res = Parse_csharp_tree_sitter.parse_pattern str in
  Pfff_or_tree_sitter.extract_pattern_from_tree_sitter_result res print_errors

let _ =
  Common.jsoo := true;
  Tree_sitter_run.Util_file.jsoo := true;
  Semgrep_js_shared.make_js_module Lang.Csharp parse_target parse_pattern
