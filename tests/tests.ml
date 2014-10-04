(* Programme de lancement automatique des tests *)

open Filename
open Sys
open Printf


let executable_name = "./minic++"


(* Check if all *.cpp files in [dir] are compiled with exit code [code] *)
let start_tests_serie testf test_dir =
 
  let files = readdir test_dir in

  let nsuccess = ref 0 in
  let ntests = ref 0 in

  let test_file filename =
    if check_suffix filename ".cpp" then
      begin
        incr ntests ;
        print_newline () ;
        printf "Testing %s : " filename ; print_newline () ;
        if (testf test_dir filename) then incr nsuccess 
        else print_string "\n/!\\\n";
      end

  in

  Array.iter test_file files ;
  (!nsuccess, !ntests)


let check_ret_code code opts test_dir filename = 
  (command (sprintf "%s %s %s/%s" executable_name opts test_dir filename)) 
  == code


let read_file filename = 
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      lines := input_line chan :: !lines
    done; []
  with End_of_file ->
    close_in chan;
    List.rev !lines ;;

let rec skip n = function
  | [] -> []
  | x::xs -> if n >= 1 then skip (n-1) xs else xs


let check_output test_dir filename =
  let _ = command (sprintf "%s --ertl --obj-descrs %s/%s" executable_name test_dir filename) in

  let asm = (Filename.chop_extension filename) ^ ".s" in
  let out = (Filename.chop_extension filename) ^ ".out" in

  let _ = command 
    (sprintf "java -jar tests/mars.jar %s/%s > tests/tmp" test_dir asm) in

  let expected = (read_file (sprintf "%s/%s" test_dir out)) @ [""] in
  let got = skip 1 (read_file "tests/tmp") in

   printf "$\n%s\n$\n%s\n$\n" 
     (String.concat "\n" expected) (String.concat "\n" got); 

  expected = got


let bad_syntax_examples = 
  ["tests/syntax/bad"]
let good_syntax_examples = 
  ["tests/syntax/good" ; "tests/typing/bad" ; 
   "tests/typing/good" ; "tests/exec"]

let bad_typing_examples = 
  "tests/typing/bad"

let good_typing_examples = 
  "tests/typing/good"

let exec_tests = ["tests/exec/perso" (*; "tests/exec"*)]


let sep_string = 
  "-------------------------------------------------------------------"

let print_test_result msg = 
  printf "\n%s\n  %s\n%s\n\n" sep_string msg sep_string


let _ =
  let results = 
  (*  [start_tests_serie (check_ret_code 1 "--type-only") bad_typing_examples] @
    [start_tests_serie (check_ret_code 0 "--type-only") good_typing_examples] @*)
    (List.map (start_tests_serie (check_output)) exec_tests) in
  
  let sum = List.fold_left (+) 0 in
  let nsuccess = sum (List.map fst results) 
  and ntests = sum (List.map snd results) in

  print_test_result (sprintf "%d / %d tests passed" nsuccess ntests)
