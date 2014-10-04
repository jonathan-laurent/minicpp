(* Compilateur MINIC++ 
   Leonard Blier - Jonathan Laurent
*)

open Error
open Lexing
open Printf
open Utils

let parse_only   = ref false
let type_only    = ref false
let spill_all    = ref false
let write_ertl   = ref false
let write_descrs = ref false

let ifile = ref ""
let ofile = ref ""

let set_file f s = f := s 

let options =  [
  
  ("-o", Arg.Set_string ofile,
   "  Set the name of the output file");

  ("--parse-only", Arg.Set parse_only, 
   "  Stop the compilation process after the parsing step");

  ("--type-only", Arg.Set type_only,
   "  Stop the compilation process after the typing step");

  ("--spill-all", Arg.Set spill_all,
   "  Spill all temporary registers");

  ("--obj-descrs", Arg.Set write_descrs,
   "  Print the objects' internal representation in a *.descrs file");

  ("--ertl", Arg.Set write_ertl,
   "  Print the intermediate ERTL code in a *.ertl file");
  ]

let usage = "usage: minic++ [option] file.cpp"

let print_error_and_exit msg exit_code = eprintf "\n%s\n" msg ; exit exit_code



(* Lit un fichier d'entrée, et retourne son arbre de syntaxe abstraite *)

exception File_not_found of string

let parse_from_file filename =
  
  let f = 
    try open_in filename 
    with Sys_error _ -> raise (File_not_found filename) in

  let lexbuf = Lexing.from_channel f in

  begin
    lexbuf.lex_curr_p <- {lexbuf.lex_curr_p with pos_fname = filename} ;
    Tident.reset () ;

    try
      let ast = Parser.file Lexer.token lexbuf in
      close_in f; ast
    with
      | Parser.Error -> 
          let pos = Loc.loc_of_lexing_pos 
            (Lexing.lexeme_start_p lexbuf) 
            (Lexing.lexeme_end_p lexbuf) 
          in error Parse_error pos;
  end  

let print_in_file extension printing = 
  let f = (!ofile) ^ extension in
  let oc = open_out f in 
  let fmt = Format.formatter_of_out_channel oc in
  printing fmt ;
  close_out oc

let write_mips mips =
  
  let f = open_out !ofile in
  let fmt = Format.formatter_of_out_channel f in

  Mips.print_program fmt mips ;
  close_out f


let () = 

  Arg.parse options (set_file ifile) usage;

  if !ifile="" then print_error_and_exit "No file to compile" 1; 

  if not (Filename.check_suffix !ifile ".cpp") then 
    print_error_and_exit "Programs should have the .cpp extension" 1;

  if !ofile="" then ofile := (Filename.chop_extension !ifile) ^ ".s" ;
  
  try
    let ast = parse_from_file !ifile in
    let tt  = if !parse_only then exit 0 else Typer.type_ast ast in

    if !type_only then exit 0;

    let is = Is.convert_prog tt in
    
    let is_data = is.Istree.prog_data in
    let is_procs = is.Istree.prog_procs in

    if !write_descrs then print_in_file ".descrs" 
      (fun fmt -> Is.print_objects_descriptors 
        fmt is_data.Istree.data_obj_descrs);

    let ertl_procs = List.map Ertl.proc is_procs in

    if !write_ertl then print_in_file ".ertl"
      (fun fmt -> List.iter 
        (fun p -> Print_fgraph.print_ertl fmt p) ertl_procs) ;

    let asm_procs = List.map
      (Linearize.linearize_proc % (Ltl.convert_proc !spill_all)) ertl_procs in

    let mips = Linearize.prog is_data asm_procs in

    write_mips mips ;

  with

    | File_not_found filename -> 
        print_error_and_exit (sprintf "File not found : \"%s\"" filename) 1

    | Error.Error (err, loc) -> 
        print_error_and_exit 
          ((Error.loc_message loc) ^ "\n" ^ (Error.error_description err)) 1
	  
    (* Erreur interne du compilateur *)
  (*  | _ -> print_error_and_exit "A fatal error has occured"  2 *)
