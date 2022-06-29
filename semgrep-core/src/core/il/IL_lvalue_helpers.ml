(* Yoann Padioleau
 * Iago Abal
 *
 * Copyright (C) 2019-2022 r2c
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
open IL

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)
(* Lvalue/Rvalue helpers working on the IL
 *)

(*****************************************************************************)
(* Helpers *)
(*****************************************************************************)

let ( let* ) = Option.bind

let lval_of_instr_opt x =
  match x.i with
  | Assign (lval, _)
  | AssignAnon (lval, _)
  | Call (Some lval, _, _)
  | CallSpecial (Some lval, _, _) ->
      Some lval
  | Call _
  | CallSpecial _ ->
      None
  | FixmeInstr _ -> None

let rexps_of_instr x =
  match x.i with
  | Assign (_, exp) -> [ exp ]
  | AssignAnon _ -> []
  | Call (_, e1, args) -> e1 :: args
  | CallSpecial (_, _, args) -> args
  | FixmeInstr _ -> []

(* opti: could use a set *)
let rec lvals_of_exp e =
  match e.e with
  | Fetch lval -> lval :: lvals_in_lval lval
  | Literal _ -> []
  | Cast (_, e) -> lvals_of_exp e
  | Composite (_, (_, xs, _))
  | Operator (_, xs) ->
      lvals_of_exps xs
  | Record ys ->
      lvals_of_exps
        (ys
        |> Common.map @@ function
           | Field (_, e)
           | Spread e ->
               e)
  | FixmeExp (_, _, Some e) -> lvals_of_exp e
  | FixmeExp (_, _, None) -> []

and lvals_in_lval lval =
  let base_lvals =
    match lval.base with
    | Mem e -> lvals_of_exp e
    | _else_ -> []
  in
  let offset_lvals =
    List.concat_map
      (function
        | Index e -> lvals_of_exp e
        | _ -> [])
      lval.offset
  in
  base_lvals @ offset_lvals

and lvals_of_exps xs = xs |> Common.map lvals_of_exp |> List.flatten

(** The lvals in the RHS of the instruction. *)
let rlvals_of_instr x =
  let exps = rexps_of_instr x in
  lvals_of_exps exps

(*****************************************************************************)
(* API *)
(*****************************************************************************)

let dotted_lvars_of_lval = function
  | { base = Var name; offset } -> (
      let id, tok = name.ident in
      let str_of_name name = Common.spf "%s:%d" (fst name.ident) name.sid in
      let dot_str =
        List.fold_right
          (fun o s ->
            match (s, o) with
            | Some (s, ss), Dot name ->
                let x = s ^ "." ^ str_of_name name in
                Some (x, x :: ss)
            | _ -> None)
          offset
          (Some ("", []))
      in
      match dot_str with
      | None
      | Some ("", []) ->
          None
      | Some (dots, dotss) ->
          let add_dots dots = { name with ident = (id ^ dots, tok) } in
          Some (add_dots dots, Common.map add_dots dotss))
  | _ -> None

let lvar_of_instr_opt x =
  let str_of_name name = Common.spf "%s:%d" (fst name.ident) name.sid in
  let* lval = lval_of_instr_opt x in
  match lval with
  | { base = Var name; offset } -> (
      let id, tok = name.ident in
      let dot_str =
        offset
        |> List.fold_left
             (fun s o ->
               match (s, o) with
               | Some s, Dot name -> Some ("." ^ str_of_name name ^ s)
               | _ -> None)
             (Some "")
      in
      match dot_str with
      | Some dots -> Some { name with ident = (id ^ dots, tok) }
      | None -> Some name)
  | _ -> None

let rlvals_of_node = function
  | Enter
  | Exit
  | TrueNode
  | FalseNode
  | NGoto _
  | Join ->
      []
  | NInstr x -> rlvals_of_instr x
  | NCond (_, e)
  | NReturn (_, e)
  | NThrow (_, e) ->
      lvals_of_exp e
  | NOther _
  | NTodo _ ->
      []
