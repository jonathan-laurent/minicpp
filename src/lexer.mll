(* LEXER.MLL
   
*)

{
  open Parser
  open Lexing
  open Loc
  open Error

  module Smap = Utils.Smap

  let keywords_list = 
    [("class", CLASS); ("else", ELSE); ("false", FALSE); ("for", FOR); 
     ("if", IF); ("int", INT); ("new", NEW); ("NULL", NULL); 
     ("public", PUBLIC); ("return", RETURN); ("this", THIS); ("true", TRUE); 
     ("virtual", VIRTUAL); ("void", VOID); 
     ("while", WHILE) ; ("#include", INCLUDE_DIRECTIVE)]

  let kdict = Smap.of_list keywords_list

  let newline lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <- 
      { pos with pos_lnum = pos.pos_lnum + 1; pos_bol = pos.pos_cnum }

  let id_or_kwd s =
    try Smap.find s kdict with
      | Not_found -> 
          if Tident.check s then TIDENT s else IDENT s

  let error err lexbuf = Error.error err 
    (loc_of_lexing_pos (lexeme_start_p lexbuf) (lexeme_end_p lexbuf))

}

let letter = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let non_null_digit = ['1'-'9']
let oct_digit = ['0'-'7']
let hex_digit = digit | ['a'-'f' 'A'-'F']

let ident = (letter | '_') (letter | '_' | digit)*

let oct_integer = '0' (oct_digit)+
let dec_integer = non_null_digit digit*
let hex_integer = "0x" (hex_digit)+

(* ASCII code for '\"' : \x22
                  '\\' : \x5C
*)
let char = 
    ['\x20'-'\x21'] | ['\x23'-'\x5B'] | ['\x5D'-'\x7F']
  | "\\\\" | "\\\"" | "\\n" | "\\t" 
  | ("\\x" hex_digit hex_digit)

let space = [' ' '\t']


rule token = parse
  | space {token lexbuf}
  | "\n" {newline lexbuf ; token lexbuf}
  | "//" {comment true lexbuf}
  | "/*" {comment false lexbuf}

  | "#include" {INCLUDE_DIRECTIVE}
  | "(" {LEFT_PAREN}
  | ")" {RIGHT_PAREN}
  | "{" {LEFT_CURLY_BRACKET}
  | "}" {RIGHT_CURLY_BRACKET}


  | "::" {DOUBLE_COLON}
  | ":" {COLON}
  | ";" {SEMICOLON}
  | "," {COMMA}
  | "." {DOT}
  | "->" {ARROW}

  | "=" {ASSIGN}
  | "!" {NOT}
  | "||" {OR}
  | "&&" {AND}
  | "==" {EQUAL}
  | "!=" {NOT_EQUAL}
  | "<" {LT}
  | "<=" {LE}
  | ">" {GT}
  | ">=" {GE}
  | "+" {PLUS}
  | "-" {MINUS}
  | "/" {DIV}
  | "%" {MOD}
  | "++" {INCR}
  | "--" {DECR}

  | "*" {STAR}
  | "&" {AMPERSAND}
  | "<<" {STREAM_OP}
  
  | "0" {DEC_INT "0"}
  | '0' ((oct_digit)+ as s) {OCT_INT s}
  | (non_null_digit digit*) as s {DEC_INT s}
  | "0x" ((hex_digit)+ as s) {HEX_INT s}

  | "\"" (char* as s) "\"" {STRING s}
  | ident as s {id_or_kwd s}

  | eof {EOF}
  | _ as c {error (Illegal_character c) lexbuf}


and comment one_line = parse
  | "\n" { 
    new_line lexbuf ; 
    if one_line then token lexbuf else comment one_line lexbuf }

  | "*/" {token lexbuf}
  | eof {error Unterminated_comment lexbuf}
  | _ {comment one_line lexbuf}
