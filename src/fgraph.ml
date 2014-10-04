(* RTL Tree
   Représentation sous forme de graphe d'un programme.
   Correspond à un compromis entre RTL, ERTL, et LTL.
*)

open Utils
open Enums

type id       = string
type proc_id  = id
type offset   = int

type label    = Label.t

and ubranch = Beqz | Bneqz
and bbranch = Beq  | Bneq


(* Type parametré par le type de registres utilisé :
   Dans un premier temps, on travaille avec des [Reg.pseudo instr],
   puis avec [Reg.real instr]
*)
and 'reg instr = 
  | Const         of 'reg * iconst * label
  | La            of 'reg * string * label

  | Unop          of 'reg * munop * 'reg * label
  | Binop         of 'reg * mbinop * 'reg * 'reg * label


  (* Le deuxième argument est le nombre d'arguments attendu :
     utile pour l'allocation de registres *)
  | Call          of proc_id * int * label 
  | Callr         of 'reg    * int * label

  (* Arguments dans l'ordre de "lw" *)
  | Load          of 'reg * offset * 'reg * label 

  (* arguments dans l'ordre de "sw" *)
  | Store         of 'reg * offset * 'reg * label

  | Move          of 'reg * 'reg * label
  | Load_stack    of 'reg * offset * label
  | Store_stack   of 'reg * offset * label
  | Stack_addr    of 'reg * offset * label

  | Ubranch       of ubranch * 'reg * label * label
  | Bbranch       of bbranch * 'reg * 'reg * label * label
  | Goto          of label
  | Syscall       of label

  | Alloc_frame   of label
  | Delete_frame  of label
  | Return        

and 'reg graph = ('reg instr) Label.M.t

and storage = 
  | Sstack of int
  | Sreg   of Reg.pseudo

and 'reg proc = {
  proc_id                 : string ;
  proc_entry_label        : label ;
  proc_exit_label         : label ;
  proc_args               : storage Smap.t ;
  proc_locals             : storage Smap.t ;

  proc_frame_size         : int ;
  proc_args_stack_size    : int ;

  proc_graph              : 'reg graph ;
}
