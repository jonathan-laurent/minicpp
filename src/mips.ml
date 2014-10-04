type register = string

type address =
  | Alab of string
  | Areg of int * register

type operand =
  | Oimm of string
  | Oreg of register

type arith = Add | Sub | Mul | Div | Rem

type condition = Eq | Ne | Le | Lt | Ge | Gt

type label = string

type instruction =
  | Nop
  | Move of register * register
  | Li of register * string
  | Li32 of register * string
  | La of register * label
  | Lw of register * address
  | Sw of register * address
  | Lb of register * address
  | Sb of register * address
  | Arith of arith * register * register * operand
  | Addi of register * register * string
  | Neg of register * register
  | Set of condition * register * register * operand
  | B of label
  | Beq of register * register * label
  | Bne of register * register * label
  | Beqz of register * label
  | Bnez of register * label
  | J of string
  | Jal of string
  | Jr of register
  | Jalr of register
  | Syscall
  | Label of string
  | Inline of string

type word = Wint of string | Waddr of string

type data =
  | Dlabel of string
  | Asciiz of string * string
  | Word of word list
  | Space of string * int
  | Align of int

type code =
  | Clist of instruction list
  | Capp of code * code

let nop = Clist []

let mips l = Clist l

let inline s = Clist [Inline s]

let (++) c1 c2 = Capp (c1, c2)

type program = {
  text : code;
  data : data list;
}

open Format

let print_register fmt r = fprintf fmt "%s" r

let print_arith fmt = function
  | Add -> pp_print_string fmt "add"
  | Sub -> pp_print_string fmt "sub"
  | Mul -> pp_print_string fmt "mul"
  | Div -> pp_print_string fmt "div"
  | Rem -> pp_print_string fmt "rem"

let print_condition fmt = function
  | Eq -> pp_print_string fmt "seq"
  | Ne -> pp_print_string fmt "sne"
  | Lt -> pp_print_string fmt "slt"
  | Le -> pp_print_string fmt "sle"
  | Gt -> pp_print_string fmt "sgt"
  | Ge -> pp_print_string fmt "sge"

let print_address fmt = function
  | Alab s -> pp_print_string fmt s
  | Areg (ofs, r) -> fprintf fmt "%d(%a)" ofs print_register r

let print_operand fmt = function
  | Oimm s -> pp_print_string fmt s
  | Oreg r -> print_register fmt r

let print_instruction fmt = function
  | Nop -> ()
  | Move (dst, src) ->
      fprintf fmt "\tmove %a, %a\n" print_register dst print_register src
  | Li (r, s) ->
      fprintf fmt "\tli   %a, %s\n" print_register r s
  | Li32 (r, s) ->
      fprintf fmt "\tli   %a, %s\n" print_register r s
  | La (r, s) ->
      fprintf fmt "\tla   %a, %s\n" print_register r s
  | Addi(r1, r2, s) ->
      fprintf fmt "\taddi %a, %a, %s\n" print_register r1 print_register r2 s

  | Lw (r, a) ->
      fprintf fmt "\tlw   %a, %a\n" print_register r print_address a
  | Sw (r, a) ->
      fprintf fmt "\tsw   %a, %a\n" print_register r print_address a
  | Lb (r, a) ->
      fprintf fmt "\tlb   %a, %a\n" print_register r print_address a
  | Sb (r, a) ->
      fprintf fmt "\tsb   %a, %a\n" print_register r print_address a
  | Arith (a, dst, src, op) ->
      fprintf fmt "\t%a  %a, %a, %a\n"
	print_arith a print_register dst print_register src print_operand op
  | Neg (dst, src) ->
      fprintf fmt "\tneg  %a, %a\n" print_register dst print_register src
  | Set (cond, dst, src, op) ->
      fprintf fmt "\t%a  %a, %a, %a\n"
	print_condition cond print_register dst print_register src
	print_operand op
  | B l ->
      fprintf fmt "\tb    %s\n" l
  | Beq (r1, r2,  l) ->
      fprintf fmt "\tbeq  %a, %a, %s\n" print_register r1 print_register r2 l
  | Bne (r1, r2,  l) ->
      fprintf fmt "\tbne  %a, %a, %s\n" print_register r1 print_register r2 l
  | Beqz (r, l) ->
      fprintf fmt "\tbeqz %a, %s\n" print_register r l
  | Bnez (r, l) ->
      fprintf fmt "\tbnez %a, %s\n" print_register r l
  | J s ->
      fprintf fmt "\tj    %s\n" s
  | Jal s ->
      fprintf fmt "\tjal  %s\n" s
  | Jalr r ->
      fprintf fmt "\tjalr %a\n" print_register r
  | Jr r ->
      fprintf fmt "\tjr   %a\n" print_register r
  | Syscall ->
      fprintf fmt "\tsyscall\n"
  | Label s ->
      fprintf fmt "%s:\n" s
  | Inline s ->
      fprintf fmt "%s" s

let rec print_code fmt = function
  | Clist l -> List.iter (print_instruction fmt) l
  | Capp (c1, c2) -> print_code fmt c1; print_code fmt c2

let print_word fmt = function
  | Wint s -> pp_print_string fmt s
  | Waddr s -> pp_print_string fmt s

let rec print_list print fmt = function
  | [] -> ()
  | [x] -> print fmt x
  | x :: r -> fprintf fmt "%a, %a" print x (print_list print) r

let print_data fmt = function
  | Asciiz (l, s) ->
      fprintf fmt "%s:\n\t.asciiz \"%s\"\n" l s
  | Word n ->
      fprintf fmt "\t.word %a\n" (print_list print_word) n
  | Dlabel l -> fprintf fmt "%s:\n" l
  | Space (l, n) ->
      fprintf fmt "%s:\n\t.space %d\n" l n
  | Align n ->
      fprintf fmt "\t.align %d\n" n

let print_program fmt p =
  fprintf fmt "\t.text\n";
  print_code fmt p.text;
  fprintf fmt "\t.data\n";
  List.iter (print_data fmt) p.data;
  fprintf fmt "@."


