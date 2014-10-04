(* MINIC++ AST *)

open Loc
open Enums

type ident = string

and ty = 
  | Tvoid 
  | Tint
  | Tident of ident
  | Tptr of ty
  | Tref of ty

(* [var] représente un [ident] avec une information de type *)
and var = ty * ident 

(* Le préfixe q- signifie la présence d'une annotation de portée :: *)
and qident = ident * scope
and qvar = ty * qident
and scope = ident option

and file = decl list

and decl = decl_value located
and decl_value = 
  | Decl_globals of var list
  | Decl_impl of (prototype * instr)
  | Decl_class of decl_class


and decl_class = {
  class_name : ident ; 
  class_supers : ident list ; 
  class_members : member list
}

and member = member_value located 
and member_value =
  | Prototype of virt_opt * prototype
  | Attributes of var list

and virt_opt = Virtual | Non_virtual

and prototype =
  | Function_prototype of qvar * (var list)
  | Constructor_prototype of ident * (var list)

and expr = expr_value located
and expr_value = 
  | Const of const
  | This
  | Qident of qident
  | Member of expr * qident
  | Call of expr * (expr list)
  | New of ident * (expr list)
  | Unary_op of unary_op * expr
  | Binary_op of binary_op * expr * expr

and instr = instr_value located
and instr_value = 
  | Nop
  | Block of instr list
  | Expr of expr
  | Decl_locals of (var * var_init) list
  | Cond of expr * instr * (instr option)
  | While of expr * instr
  | For of (expr list) * (expr option) * (expr list) * instr
  | Cout of str_expr list
  | Return of (expr option)

  | Init_obj of ident * ident * (expr list)
  | Init_ref of ident * expr

and var_init =
  | Init_empty
  | Init_expr of expr
  | Init_constructor of ident * (expr list)

and str_expr = 
  | S_expr of expr
  | S_string of string

