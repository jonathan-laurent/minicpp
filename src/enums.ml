(* ENUMS.ML *)

type iconst = string * base
and base = Bin | Dec | Oct | Hex 
and const =
  | True
  | False
  | Null
  | Int of iconst

let iconst_of_int i = (string_of_int i, Dec)

type unary_op =
  | Addr | Unref | Incr_suf | Decr_suf | Incr_pre | Decr_pre 
  | Not | Unary_plus | Unary_minus 

type binary_op = 
  | Assign | Eq | Neq | Lt | Leq | Gt | Geq | Plus | Minus 
  | Mul | Div | Mod | And | Or

type munop = 
  | Maddi of iconst
  | Mneg | Mnot

type mbinop = 
  | Madd  | Msub  | Mmul | Mdiv | Mmod
  | Meq | Mneq | Mlt | Mleq | Mgt | Mgeq

