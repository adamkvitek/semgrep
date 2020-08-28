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

(*open OCaml*)
open Cst_cpp

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)

(*****************************************************************************)
(* Types *)
(*****************************************************************************)

(* hooks *)
type visitor_in = {
  kexpr: expr vin;
  kstmt: stmt vin;
  kinit: initialiser vin;
  ktypeC: typeC vin;

  kclass_member: class_member vin;
  kfieldkind: fieldkind vin;

  kparameter: parameter vin;
  kcompound: compound vin;

  kclass_def: class_definition vin;
  kfunc_def: func_definition vin;
  kcpp: cpp_directive vin;
  kblock_decl: block_declaration vin;

  kdeclaration: declaration vin;
  ktoplevel: toplevel vin;
  
  kinfo: tok vin;
}
and visitor_out = any -> unit
and 'a vin = ('a  -> unit) * visitor_out -> 'a  -> unit

let default_visitor = 
  { kexpr    = (fun (k,_) x -> k x);
    kfieldkind = (fun (k,_) x -> k x);
    kparameter = (fun (k,_) x -> k x);
    ktypeC = (fun (k,_) x -> k x);
    kblock_decl  = (fun (k,_) x -> k x);
    kcompound = (fun (k,_) x -> k x);
    kstmt = (fun (k,_) x -> k x);
    kinfo = (fun (k,_) x -> k x);
    kclass_def = (fun (k,_) x -> k x);
    kfunc_def = (fun (k,_) x -> k x);
    kclass_member = (fun (k,_) x -> k x);
    kcpp = (fun (k,_) x -> k x);
    kdeclaration = (fun (k,_) x -> k x);
    ktoplevel = (fun (k,_) x -> k x);
    kinit = (fun (k,_) x -> k x);
  }

let (mk_visitor: visitor_in -> visitor_out) = fun _vin ->
  raise Common.Todo

(*
let (mk_visitor: visitor_in -> visitor_out) = fun vin ->

(* start of auto generation *)
(* generated by ocamltarzan with: camlp4o -o /tmp/yyy.ml -I pa/ pa_type_conv.cmo pa_visitor.cmo  pr_o.cmo /tmp/xxx.ml  *)

let rec v_info x =
  let k _ = () in
  vin.kinfo (k, all_functions) x

and v_tok v = v_info v

and v_wrapx:'a. ('a -> unit) -> 'a wrapx -> unit = 
 fun _of_a (v1, v2) -> 
   let v1 = _of_a v1 and v2 = v_list v_info v2 in ()
and v_wrap:'a. ('a -> unit) -> 'a wrap -> unit = 
 fun _of_a (v1, v2) -> 
   let v1 = _of_a v1 and v2 = v_info v2 in ()
and v_paren:'a. ('a -> unit) -> 'a paren -> unit =
 fun _of_a (v1, v2, v3) ->
  let v1 = v_tok v1 and v2 = _of_a v2 and v3 = v_tok v3 in ()
and v_brace: 'a. ('a -> unit) -> 'a brace -> unit =
 fun _of_a (v1, v2, v3) ->
  let v1 = v_tok v1 and v2 = _of_a v2 and v3 = v_tok v3 in ()
and v_bracket: 'a. ('a -> unit) -> 'a bracket -> unit = 
 fun _of_a (v1, v2, v3) ->
  let v1 = v_tok v1 and v2 = _of_a v2 and v3 = v_tok v3 in ()
and v_angle: 'a. ('a -> unit) -> 'a angle -> unit = 
 fun _of_a (v1, v2, v3) ->
  let v1 = v_tok v1 and v2 = _of_a v2 and v3 = v_tok v3 in ()
and v_comma_list: 'a. ('a -> unit) -> 'a comma_list -> unit = fun
  _of_a -> v_list (v_wrapx _of_a)
and v_comma_list2: 'a. ('a -> unit) -> 'a comma_list2 -> unit = 
 fun _of_a ->
   v_list (OCaml.v_either _of_a v_tok)

and v_name (v1, v2, v3) =
  let v1 = v_option v_tok v1
  and v2 =
    v_list (fun (v1, v2) -> let v1 = v_qualifier v1 and v2 = v_tok v2 in ())
      v2
  and v3 = v_ident v3
  in ()
  
and v_ident =
  function
  | IdIdent v1 -> let v1 = v_wrap v_string v1 in ()
  | IdOperator ((v1, v2)) ->
      let v1 = v_tok v1
      and v2 =
        (match v2 with
         | (v1, v2) -> let v1 = v_operator v1 and v2 = v_list v_tok v2 in ())
      in ()
  | IdConverter ((v1, v2)) -> let v1 = v_tok v1 and v2 = v_fullType v2 in ()
  | IdDestructor ((v1, v2)) ->
      let v1 = v_tok v1 and v2 = v_wrap v_string v2 in ()
  | IdTemplateId ((v1, v2)) ->
      let v1 = v_wrap v_string v1 and v2 = v_template_arguments v2 in ()
and v_template_arguments v = v_angle (v_comma_list v_template_argument) v
and v_template_argument v = OCaml.v_either v_fullType v_expression v
and v_either_ft_or_expr v = OCaml.v_either v_fullType v_expression v
and v_qualifier =
  function
  | QClassname v1 -> let v1 = v_wrap v_string v1 in ()
  | QTemplateId ((v1, v2)) ->
      let v1 = v_wrap v_string v1 and v2 = v_template_arguments v2 in ()
and v_class_name v = v_name v
and v_namespace_name v = v_name v
and v_typedef_name v = v_name v
and v_enum_name v = v_name v
and v_ident_name v = v_name v
and v_fullType (v1, v2) =
  let v1 = v_typeQualifier v1 and v2 = v_typeC v2 in ()
and v_typeC v = 
  let k v = v_wrapx v_typeCbis v in
  vin.ktypeC (k, all_functions) v

and v_typeCbis =
  function
  | BaseType v1 -> let v1 = v_baseType v1 in ()
  | Pointer v1 -> let v1 = v_fullType v1 in ()
  | Reference v1 -> let v1 = v_fullType v1 in ()
  | Array ((v1, v2)) ->
      let v1 = v_bracket (v_option v_constExpression) v1
      and v2 = v_fullType v2
      in ()
  | FunctionType v1 -> let v1 = v_functionType v1 in ()
  | EnumDef ((v1, v2, v3)) ->
      let v1 = v_tok v1
      and v2 = v_option (v_wrap v_string) v2
      and v3 = v_brace (v_comma_list v_enum_elem) v3
      in ()
  | StructDef v1 -> let v1 = v_class_definition v1 in ()
  | EnumName ((v1, v2)) ->
      let v1 = v_tok v1 and v2 = v_wrap v_string v2 in ()
  | StructUnionName ((v1, v2)) ->
      let v1 = v_wrap v_structUnion v1 and v2 = v_wrap v_string v2 in ()
  | TypeName ((v1)) ->
      let v1 = v_name v1 in ()
  | TypenameKwd ((v1, v2)) -> let v1 = v_tok v1 and v2 = v_name v2 in ()
  | TypeOf ((v1, v2)) ->
      let v1 = v_tok v1 and v2 = v_paren v_either_ft_or_expr v2 in ()
  | ParenType v1 -> let v1 = v_paren v_fullType v1 in ()
and v_baseType =
  function
  | Void -> ()
  | IntType v1 -> let v1 = v_intType v1 in ()
  | FloatType v1 -> let v1 = v_floatType v1 in ()
and v_intType =
  function
  | CChar -> ()
  | Si v1 -> let v1 = v_signed v1 in ()
  | CBool -> ()
  | WChar_t -> ()
and v_signed (v1, v2) = let v1 = v_sign v1 and v2 = v_base v2 in ()
and v_base =
  function
  | CChar2 -> ()
  | CShort -> ()
  | CInt -> ()
  | CLong -> ()
  | CLongLong -> ()
and v_sign = function | Signed -> () | UnSigned -> ()
and v_floatType = function | CFloat -> () | CDouble -> () | CLongDouble -> ()
and v_enum_elem { e_name = v_e_name; e_val = v_e_val } =
  let arg = v_wrap v_string v_e_name in
  let arg =
    v_option
      (fun (v1, v2) -> let v1 = v_tok v1 and v2 = v_constExpression v2 in ())
      v_e_val
  in ()
and v_typeQualifier { const = v_const; volatile = v_volatile } =
  let arg = v_option v_tok v_const in
  let arg = v_option v_tok v_volatile in ()
and v_expression v = 
  let k x = v_wrapx v_expressionbis x in
  vin.kexpr (k, all_functions) v

and v_expressionbis =
  function
  | Id ((v1, v2)) -> let v1 = v_name v1 and v2 = v_ident_info v2 in ()
  | C v1 -> let v1 = v_constant v1 in ()
  | Ellipses v1 -> let v1 = v_tok v1 in ()
  | Call ((v1, v2)) ->
      let v1 = v_expression v1
      and v2 = v_paren (v_comma_list v_argument) v2
      in ()
  | CondExpr ((v1, v2, v3)) ->
      let v1 = v_expression v1
      and v2 = v_option v_expression v2
      and v3 = v_expression v3
      in ()
  | Sequence ((v1, v2)) ->
      let v1 = v_expression v1 and v2 = v_expression v2 in ()
  | Assignment ((v1, v2, v3)) ->
      let v1 = v_expression v1
      and v2 = v_assignOp v2
      and v3 = v_expression v3
      in ()
  | Postfix ((v1, v2)) -> let v1 = v_expression v1 and v2 = v_fixOp v2 in ()
  | Infix ((v1, v2)) -> let v1 = v_expression v1 and v2 = v_fixOp v2 in ()
  | Unary ((v1, v2)) -> let v1 = v_expression v1 and v2 = v_unaryOp v2 in ()
  | Binary ((v1, v2, v3)) ->
      let v1 = v_expression v1
      and v2 = v_binaryOp v2
      and v3 = v_expression v3
      in ()
  | ArrayAccess ((v1, v2)) ->
      let v1 = v_expression v1 and v2 = v_bracket v_expression v2 in ()
  | RecordAccess ((v1, t, v2)) ->
      let v1 = v_expression v1 and t = v_tok t and v2 = v_name v2 in ()
  | RecordPtAccess ((v1, t, v2)) ->
      let v1 = v_expression v1 and t = v_tok t and v2 = v_name v2 in ()
  | RecordStarAccess ((v1, t, v2)) ->
      let v1 = v_expression v1 and t = v_tok t and v2 = v_expression v2 in ()
  | RecordPtStarAccess ((v1, t, v2)) ->
      let v1 = v_expression v1 and t = v_tok t and v2 = v_expression v2 in ()
  | SizeOfExpr ((v1, v2)) -> let v1 = v_tok v1 and v2 = v_expression v2 in ()
  | SizeOfType ((v1, v2)) ->
      let v1 = v_tok v1 and v2 = v_paren v_fullType v2 in ()
  | Cast ((v1, v2)) ->
      let v1 = v_paren v_fullType v1 and v2 = v_expression v2 in ()
  | StatementExpr v1 -> let v1 = v_paren v_compound v1 in ()
  | GccConstructor ((v1, v2)) ->
      let v1 = v_paren v_fullType v1
      and v2 = v_brace (v_comma_list v_initialiser) v2
      in ()
  | This v1 -> let v1 = v_tok v1 in ()
  | ConstructedObject ((v1, v2)) ->
      let v1 = v_fullType v1
      and v2 = v_paren (v_comma_list v_argument) v2
      in ()
  | TypeId ((v1, v2)) ->
      let v1 = v_tok v1 and v2 = v_paren v_either_ft_or_expr v2 in ()
  | CplusplusCast ((v1, v2, v3)) ->
      let v1 = v_wrap v_cast_operator v1
      and v2 = v_angle v_fullType v2
      and v3 = v_paren v_expression v3
      in ()
  | New ((v1, v2, v3, v4, v5)) ->
      let v1 = v_option v_tok v1
      and v2 = v_tok v2
      and v3 = v_option (v_paren (v_comma_list v_argument)) v3
      and v4 = v_fullType v4
      and v5 = v_option (v_paren (v_comma_list v_argument)) v5
      in ()
  | Delete ((v1, v2)) ->
      let v1 = v_option v_tok v1 and v2 = v_expression v2 in ()
  | DeleteArray ((v1, v2)) ->
      let v1 = v_option v_tok v1 and v2 = v_expression v2 in ()
  | Throw v1 -> let v1 = v_option v_expression v1 in ()
  | ParenExpr v1 -> let v1 = v_paren v_expression v1 in ()
  | ExprTodo -> ()
and v_ident_info { i_scope = _v_i_scope } =
  (* todo? let arg = Scope_code.v_scope v_i_scope in () *)
  ()
and v_argument v = OCaml.v_either v_expression v_weird_argument v
and v_weird_argument =
  function
  | ArgType v1 -> let v1 = v_fullType v1 in ()
  | ArgAction v1 -> let v1 = v_action_macro v1 in ()
and v_action_macro = function | ActMisc v1 -> let v1 = v_list v_tok v1 in ()
and v_constant =
  function
  | String v1 ->
      let v1 =
        (match v1 with
         | (v1, v2) -> let v1 = v_string v1 and v2 = v_isWchar v2 in ())
      in ()
  | MultiString -> ()
  | Char v1 ->
      let v1 =
        (match v1 with
         | (v1, v2) -> let v1 = v_string v1 and v2 = v_isWchar v2 in ())
      in ()
  | Int v1 -> let v1 = v_string v1 in ()
  | Float v1 ->
      let v1 =
        (match v1 with
         | (v1, v2) -> let v1 = v_string v1 and v2 = v_floatType v2 in ())
      in ()
  | Bool v1 -> let v1 = v_bool v1 in ()
and v_isWchar = function | IsWchar -> () | IsChar -> ()
and v_unaryOp =
  function
  | GetRef -> ()
  | DeRef -> ()
  | UnPlus -> ()
  | UnMinus -> ()
  | Tilde -> ()
  | Not -> ()
  | GetRefLabel -> ()
and v_assignOp =
  function | SimpleAssign -> () | OpAssign v1 -> let v1 = v_arithOp v1 in ()
and v_fixOp = function | Dec -> () | Inc -> ()
and v_binaryOp =
  function
  | Arith v1 -> let v1 = v_arithOp v1 in ()
  | Logical v1 -> let v1 = v_logicalOp v1 in ()
and v_arithOp =
  function
  | Plus -> ()
  | Minus -> ()
  | Mul -> ()
  | Div -> ()
  | Mod -> ()
  | DecLeft -> ()
  | DecRight -> ()
  | And -> ()
  | Or -> ()
  | Xor -> ()
and v_logicalOp =
  function
  | Inf -> ()
  | Sup -> ()
  | InfEq -> ()
  | SupEq -> ()
  | Eq -> ()
  | NotEq -> ()
  | AndLog -> ()
  | OrLog -> ()
and v_ptrOp = function | PtrStarOp -> () | PtrOp -> ()
and v_allocOp =
  function
  | NewOp -> ()
  | DeleteOp -> ()
  | NewArrayOp -> ()
  | DeleteArrayOp -> ()
and v_accessop = function | ParenOp -> () | ArrayOp -> ()
and v_operator =
  function
  | BinaryOp v1 -> let v1 = v_binaryOp v1 in ()
  | AssignOp v1 -> let v1 = v_assignOp v1 in ()
  | FixOp v1 -> let v1 = v_fixOp v1 in ()
  | PtrOpOp v1 -> let v1 = v_ptrOp v1 in ()
  | AccessOp v1 -> let v1 = v_accessop v1 in ()
  | AllocOp v1 -> let v1 = v_allocOp v1 in ()
  | UnaryTildeOp -> ()
  | UnaryNotOp -> ()
  | CommaOp -> ()
and v_cast_operator =
  function
  | Static_cast -> ()
  | Dynamic_cast -> ()
  | Const_cast -> ()
  | Reinterpret_cast -> ()
and v_constExpression v = v_expression v

and v_statement v = 
  let k v = v_wrapx v_statementbis v in
  vin.kstmt (k, all_functions) v

and v_statementbis =
  function
  | Compound v1 -> let v1 = v_compound v1 in ()
  | ExprStatement v1 -> let v1 = v_exprStatement v1 in ()
  | Labeled v1 -> let v1 = v_labeled v1 in ()
  | Selection v1 -> let v1 = v_selection v1 in ()
  | Iteration v1 -> let v1 = v_iteration v1 in ()
  | Jump v1 -> let v1 = v_jump v1 in ()
  | DeclStmt v1 -> let v1 = v_block_declaration v1 in ()
  | Try ((v1, v2, v3)) ->
      let v1 = v_tok v1
      and v2 = v_compound v2
      and v3 = v_list v_handler v3
      in ()
  | NestedFunc v1 -> let v1 = v_func_definition v1 in ()
  | MacroStmt -> ()
  | StmtTodo -> ()
and v_compound v = 
  let k v = v_brace (v_list v_statement_sequencable) v in
  vin.kcompound (k, all_functions) v

and v_statement_sequencable =
  function
  | StmtElem v1 -> let v1 = v_statement v1 in ()
  | CppDirectiveStmt v1 -> let v1 = v_cpp_directive v1 in ()
  | IfdefStmt v1 -> let v1 = v_ifdef_directive v1 in ()
and v_exprStatement v = v_option v_expression v
and v_labeled =
  function
  | Label ((v1, v2)) -> let v1 = v_string v1 and v2 = v_statement v2 in ()
  | Case ((v1, v2)) -> let v1 = v_expression v1 and v2 = v_statement v2 in ()
  | CaseRange ((v1, v2, v3)) ->
      let v1 = v_expression v1
      and v2 = v_expression v2
      and v3 = v_statement v3
      in ()
  | Default v1 -> let v1 = v_statement v1 in ()
and v_selection =
  function
  | If ((v1, v2, v3, v4, v5)) ->
      let v1 = v_tok v1
      and v2 = v_paren v_expression v2
      and v3 = v_statement v3
      and v4 = v_option v_tok v4
      and v5 = v_statement v5
      in ()
  | Switch ((v1, v2, v3)) ->
      let v1 = v_tok v1
      and v2 = v_paren v_expression v2
      and v3 = v_statement v3
      in ()
and v_iteration =
  function
  | While ((v1, v2, v3)) ->
      let v1 = v_tok v1
      and v2 = v_paren v_expression v2
      and v3 = v_statement v3
      in ()
  | DoWhile ((v1, v2, v3, v4, v5)) ->
      let v1 = v_tok v1
      and v2 = v_statement v2
      and v3 = v_tok v3
      and v4 = v_paren v_expression v4
      and v5 = v_tok v5
      in ()
  | For ((v1, v2, v3)) ->
      let v1 = v_tok v1
      and v2 =
        v_paren
          (fun (v1, v2, v3) ->
             let v1 = v_wrapx v_exprStatement v1
             and v2 = v_wrapx v_exprStatement v2
             and v3 = v_wrapx v_exprStatement v3
             in ())
          v2
      and v3 = v_statement v3
      in ()
  | MacroIteration ((v1, v2, v3)) ->
      let v1 = v_wrap v_string v1
      and v2 = v_paren (v_comma_list v_argument) v2
      and v3 = v_statement v3
      in ()
and v_jump =
  function
  | Goto v1 -> let v1 = v_string v1 in ()
  | Continue -> ()
  | Break -> ()
  | Return -> ()
  | ReturnExpr v1 -> let v1 = v_expression v1 in ()
  | GotoComputed v1 -> let v1 = v_expression v1 in ()
and v_handler (v1, v2, v3) =
  let v1 = v_tok v1
  and v2 = v_paren v_exception_declaration v2
  and v3 = v_compound v3
  in ()
and v_exception_declaration =
  function
  | ExnDeclEllipsis v1 -> let v1 = v_tok v1 in ()
  | ExnDecl v1 -> let v1 = v_parameter v1 in ()
and v_block_declaration x =
  let k = function
  | DeclList ((v1, v2)) ->
      let v1 = v_comma_list v_onedecl v1 and v2 = v_tok v2 in ()
  | MacroDecl ((v1, v2, v3, v4)) ->
      let v1 = v_list v_tok v1
      and v2 = v_wrap v_string v2
      and v3 = v_paren (v_comma_list v_argument) v3
      and v4 = v_tok v4
      in ()
  | UsingDecl v1 ->
      let v1 =
        (match v1 with
         | (v1, v2, v3) ->
             let v1 = v_tok v1 and v2 = v_name v2 and v3 = v_tok v3 in ())
      in ()
  | UsingDirective ((v1, v2, v3, v4)) ->
      let v1 = v_tok v1
      and v2 = v_tok v2
      and v3 = v_namespace_name v3
      and v4 = v_tok v4
      in ()
  | NameSpaceAlias ((v1, v2, v3, v4, v5)) ->
      let v1 = v_tok v1
      and v2 = v_wrap v_string v2
      and v3 = v_tok v3
      and v4 = v_namespace_name v4
      and v5 = v_tok v5
      in ()
  | Asm ((v1, v2, v3, v4)) ->
      let v1 = v_tok v1
      and v2 = v_option v_tok v2
      and v3 = v_paren v_asmbody v3
      and v4 = v_tok v4
      in ()
  in
  vin.kblock_decl (k, all_functions) x
and
  v_onedecl { v_namei = v_v_namei; v_type = v_v_type; v_storage = v_v_storage
            } =
  let arg =
    v_option
      (fun (v1, v2) -> let v1 = v_name v1 and v2 = v_option v_init v2 in ())
      v_v_namei in
  let arg = v_fullType v_v_type in
  let arg = v_storage v_v_storage in ()
and v_storage v = v_storagebis v
and v_storagebis =
  function
  | NoSto -> ()
  | StoTypedef v1 -> v_tok v1
  | Sto v1 -> let v1 = v_wrap v_storageClass v1 in ()
and v_storageClass =
  function | Auto -> () | Static -> () | Register -> () | Extern -> ()
and v_func_specifier = function | Inline -> () | Virtual -> ()
and v_init =
  function
  | EqInit ((v1, v2)) -> let v1 = v_tok v1 and v2 = v_initialiser v2 in ()
  | ObjInit v1 -> let v1 = v_paren (v_comma_list v_argument) v1 in ()
and v_initialiser x =
  let k x =
  match x with
  | InitExpr v1 -> let v1 = v_expression v1 in ()
  | InitList v1 -> let v1 = v_brace (v_comma_list v_initialiser) v1 in ()
  | InitDesignators ((v1, v2, v3)) ->
      let v1 = v_list v_designator v1
      and v2 = v_tok v2
      and v3 = v_initialiser v3
      in ()
  | InitFieldOld ((v1, v2, v3)) ->
      let v1 = v_wrap v_string v1
      and v2 = v_tok v2
      and v3 = v_initialiser v3
      in ()
  | InitIndexOld ((v1, v2)) ->
      let v1 = v_bracket v_expression v1 and v2 = v_initialiser v2 in ()
  in
  vin.kinit (k, all_functions) x

and v_designator =
  function
  | DesignatorField ((v1, v2)) ->
      let v1 = v_tok v1 and v2 = v_wrap v_string v2 in ()
  | DesignatorIndex v1 -> let v1 = v_bracket v_expression v1 in ()
  | DesignatorRange v1 ->
      let v1 =
        v_bracket
          (fun (v1, v2, v3) ->
             let v1 = v_expression v1
             and v2 = v_tok v2
             and v3 = v_expression v3
             in ())
          v1
      in ()
and v_asmbody (v1, v2) =
  let v1 = v_list v_tok v1 and v2 = v_list (v_wrapx v_colon) v2 in ()
and v_colon =
  function | Colon v1 -> let v1 = v_comma_list v_colon_option v1 in ()
and v_colon_option v = v_wrapx v_colon_optionbis v
and v_colon_optionbis =
  function
  | ColonMisc -> ()
  | ColonExpr v1 -> let v1 = v_paren v_expression v1 in ()
and
  v_func_definition x =
  let k = function {
                      f_name = v_f_name;
                      f_type = v_f_type;
                      f_storage = v_f_storage;
                      f_body = v_f_body
                    } ->
  let arg = v_name v_f_name in
  let arg = v_functionType v_f_type in
  let arg = v_storage v_f_storage in
  let arg = v_compound v_f_body in ()
  in
  vin.kfunc_def (k, all_functions) x

and
  v_functionType {
                   ft_ret = v_ft_ret;
                   ft_params = v_ft_params;
                   ft_dots = v_ft_dots;
                   ft_const = v_ft_const;
                   ft_throw = v_ft_throw
                 } =
  let arg = v_fullType v_ft_ret in
  let arg = v_paren (v_comma_list v_parameter) v_ft_params in
  let arg =
    v_option (fun (v1, v2) -> let v1 = v_tok v1 and v2 = v_tok v2 in ())
      v_ft_dots in
  let arg = v_option v_tok v_ft_const in
  let arg = v_option v_exn_spec v_ft_throw in
  ()
and
  v_parameter x =
  let k = function  {
                p_name = v_p_name;
                p_type = v_p_type;
                p_register = v_p_register;
                p_val = v_p_val
              } ->
  let arg = v_option (v_wrap v_string) v_p_name in
  let arg = v_fullType v_p_type in
  let arg = v_option v_tok v_p_register in
  let arg =
    v_option
      (fun (v1, v2) -> let v1 = v_tok v1 and v2 = v_expression v2 in ())
      v_p_val
  in ()
  in
  vin.kparameter (k, all_functions) x
and v_func_or_else =
  function
  | FunctionOrMethod v1 -> let v1 = v_func_definition v1 in ()
  | Constructor ((v1)) ->
      let v1 = v_func_definition v1 in ()
  | Destructor v1 -> let v1 = v_func_definition v1 in ()
and v_exn_spec (v1, v2) =
  let v1 = v_tok v1 and v2 = v_paren (v_comma_list2 v_name) v2 in ()

and
  v_class_definition x =
  let k = function {
                       c_kind = v_c_kind;
                       c_name = v_c_name;
                       c_inherit = v_c_inherit;
                       c_members = v_c_members
                     } ->
  let arg = v_wrap v_structUnion v_c_kind in
  let arg = v_option v_ident_name v_c_name in
  let arg =
    v_option
      (fun (v1, v2) ->
         let v1 = v_tok v1 and v2 = v_comma_list v_base_clause v2 in ())
      v_c_inherit in
  let arg = v_brace (v_list v_class_member_sequencable) v_c_members in ()
  in
  vin.kclass_def (k, all_functions) x

and v_structUnion = function | Struct -> () | Union -> () | Class -> ()
and
  v_base_clause {
                  i_name = v_i_name;
                  i_virtual = v_i_virtual;
                  i_access = v_i_access
                } =
  let arg = v_class_name v_i_name in
  let arg = v_option v_tok v_i_virtual in
  let arg = v_option (v_wrap v_access_spec) v_i_access in ()
and v_access_spec = function | Public -> () | Private -> () | Protected -> ()

and v_method_decl = function
  | ConstructorDecl ((v1, v2, v3)) ->
      let v1 = v_wrap v_string v1
      and v2 = v_paren (v_comma_list v_parameter) v2
      and v3 = v_tok v3 in ()
  | DestructorDecl ((v1, v2, v3, v4, v5)) ->
      let v1 = v_tok v1
      and v2 = v_wrap v_string v2
      and v3 = v_paren (v_option v_tok) v3
      and v4 = v_option v_exn_spec v4
      and v5 = v_tok v5
      in ()

  | MethodDecl ((v1, v2, v3)) ->
      let v1 = v_onedecl v1
      and v2 =
        v_option (fun (v1, v2) -> let v1 = v_tok v1 and v2 = v_tok v2 in ())
          v2
      and v3 = v_tok v3
      in ()

and v_class_member x =
  let k =
  function
  | Access ((v1, v2)) ->
      let v1 = v_wrap v_access_spec v1 and v2 = v_tok v2 in ()
  | MemberField (v1, v2) -> 
      let v1 = (v_comma_list v_fieldkind) v1 in 
      let v2 = v_tok v2 in
      ()
  | MemberFunc v1 -> let v1 = v_func_or_else v1 in ()
  | MemberDecl v1 -> let v1 = v_method_decl v1 in ()
  | QualifiedIdInClass ((v1, v2)) ->
      let v1 = v_name v1 and v2 = v_tok v2 in ()
  | TemplateDeclInClass v1 ->
      let v1 =
        (match v1 with
         | (v1, v2, v3) ->
             let v1 = v_tok v1
             and v2 = v_template_parameters v2
             and v3 = v_declaration v3
             in ())
      in ()
  | UsingDeclInClass v1 ->
      let v1 =
        (match v1 with
         | (v1, v2, v3) ->
             let v1 = v_tok v1 and v2 = v_name v2 and v3 = v_tok v3 in ())
      in ()
  | EmptyField v1 -> let v1 = v_tok v1 in ()
  in
  vin.kclass_member (k, all_functions) x

and v_fieldkind x =
  let k = function
  | FieldDecl v1 -> let v1 = v_onedecl v1 in ()
  | BitField ((v1, v2, v3, v4)) ->
      let v1 = v_option (v_wrap v_string) v1
      and v2 = v_tok v2
      and v3 = v_fullType v3
      and v4 = v_constExpression v4
      in ()
  in
  vin.kfieldkind (k, all_functions) x

and v_class_member_sequencable =
  function
  | ClassElem v1 -> let v1 = v_class_member v1 in ()
  | CppDirectiveStruct v1 -> let v1 = v_cpp_directive v1 in ()
  | IfdefStruct v1 -> let v1 = v_ifdef_directive v1 in ()
and v_cpp_directive x =
  let k = function
  | Define ((v1, v2, v3, v4)) ->
      let v1 = v_tok v1
      and v2 = v_wrap v_string v2
      and v3 = v_define_kind v3
      and v4 = v_define_val v4
      in ()
  | Include ((v1, v2, v3)) -> 
    let v1 = v_tok v1 
    and v2 = v_inc_kind v2 
    and v3 = v_string v3
    in ()
  | Undef v1 -> let v1 = v_wrap v_string v1 in ()
  | PragmaAndCo v1 -> let v1 = v_tok v1 in ()
  in
  vin.kcpp (k, all_functions) x
and v_define_kind =
  function
  | DefineVar -> ()
  | DefineFunc v1 ->
      let v1 = v_paren (v_comma_list (v_wrapx v_string)) v1 in ()
and v_define_val =
  function
  | DefinePrintWrapper ((v1, v2, v3)) ->
      let v1 = v_tok v1
      and v2 = v_paren v_expression v2
      and v3 = v_name v3
      in ()
  | DefineExpr v1 -> let v1 = v_expression v1 in ()
  | DefineStmt v1 -> let v1 = v_statement v1 in ()
  | DefineType v1 -> let v1 = v_fullType v1 in ()
  | DefineDoWhileZero v1 -> let v1 = v_wrapx v_statement v1 in ()
  | DefineFunction v1 -> let v1 = v_func_definition v1 in ()
  | DefineInit v1 -> let v1 = v_initialiser v1 in ()
  | DefineText v1 -> let v1 = v_wrapx v_string v1 in ()
  | DefineEmpty -> ()
  | DefineTodo -> ()
and v_inc_kind =
  function
  | Local -> ()
  | Standard -> ()
  | Weird -> ()
and v_inc_elem v = v_string v
and v_ifdef_directive v = v_wrap v_ifdefkind v
and v_ifdefkind =
  function
  | Ifdef -> ()
  | IfdefElse -> ()
  | IfdefElseif -> ()
  | IfdefEndif -> ()
and v_declaration x =
  let k = function
  | BlockDecl v1 -> let v1 = v_block_declaration v1 in ()
  | Func v1 -> let v1 = v_func_or_else v1 in ()
  | TemplateDecl (v1, v2, v3) ->
    let v1 = v_tok v1
    and v2 = v_template_parameters v2
    and v3 = v_declaration v3
    in ()
  | TemplateSpecialization ((v1, v2, v3)) ->
      let v1 = v_tok v1
      and v2 = v_angle v_unit v2
      and v3 = v_declaration v3
      in ()
  | ExternC ((v1, v2, v3)) ->
      let v1 = v_tok v1 and v2 = v_tok v2 and v3 = v_declaration v3 in ()
  | ExternCList ((v1, v2, v3)) ->
      let v1 = v_tok v1
      and v2 = v_tok v2
      and v3 = v_brace (v_list v_declaration_sequencable) v3
      in ()
  | NameSpace ((v1, v2, v3)) ->
      let v1 = v_tok v1
      and v2 = v_wrap v_string v2
      and v3 = v_brace (v_list v_declaration_sequencable) v3
      in ()
  | NameSpaceExtend ((v1, v2)) ->
      let v1 = v_string v1 and v2 = v_list v_declaration_sequencable v2 in ()
  | NameSpaceAnon ((v1, v2)) ->
      let v1 = v_tok v1
      and v2 = v_brace (v_list v_declaration_sequencable) v2
      in ()
  | EmptyDef v1 -> let v1 = v_tok v1 in ()
  | DeclTodo -> ()
  in
  vin.kdeclaration (k, all_functions) x

and v_template_parameter v = v_parameter v
and v_template_parameters v = v_angle (v_comma_list v_template_parameter) v
and v_declaration_sequencable x =
  let k = function
  | NotParsedCorrectly v1 -> let v1 = v_list v_tok v1 in ()
  | DeclElem v1 -> let v1 = v_declaration v1 in ()
  | CppDirectiveDecl v1 -> let v1 = v_cpp_directive v1 in ()
  | IfdefDecl v1 -> let v1 = v_ifdef_directive v1 in ()
  | MacroTop ((v1, v2, v3)) ->
      let v1 = v_wrap v_string v1
      and v2 = v_paren (v_comma_list v_argument) v2
      and v3 = v_option v_tok v3
      in ()
  | MacroVarTop ((v1, v2)) ->
      let v1 = v_wrap v_string v1 and v2 = v_tok v2 in ()
  in
  vin.ktoplevel (k, all_functions) x
and v_toplevel v = v_declaration_sequencable v
and v_program v = v_list v_toplevel v
and v_any =
  function
  | Program v1 -> let v1 = v_program v1 in ()
  | Toplevel v1 -> let v1 = v_toplevel v1 in ()
  | BlockDecl2 v1 -> let v1 = v_block_declaration v1 in ()
  | Stmt v1 -> let v1 = v_statement v1 in ()
  | Stmts v1 -> let v1 = v_list v_statement v1 in ()
  | Expr v1 -> let v1 = v_expression v1 in ()
  | Init v1 -> let v1 = v_initialiser v1 in ()
  | Type v1 -> let v1 = v_fullType v1 in ()
  | Name v1 -> let v1 = v_name v1 in ()
  | Cpp v1 -> let v1 = v_cpp_directive v1 in ()
  | ClassDef v1 -> let v1 = v_class_definition v1 in ()
  | FuncDef v1 -> let v1 = v_func_definition v1 in ()
  | FuncOrElse v1 -> let v1 = v_func_or_else v1 in ()
  | Constant v1 -> let v1 = v_constant v1 in ()
  | Argument v1 -> let v1 = v_argument v1 in ()
  | Parameter v1 -> let v1 = v_parameter v1 in ()
  | Body v1 -> let v1 = v_compound v1 in ()
  | Info v1 -> let v1 = v_info v1 in ()
  | InfoList v1 -> let v1 = v_list v_info v1 in ()
  | ClassMember v1 -> let v1 = v_class_member v1 in ()
  | OneDecl v1 -> let v1 = v_onedecl v1 in ()
  
(* end of auto generation *)

 and all_functions x = v_any x
in
 v_any

  
*)
