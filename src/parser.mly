%{
  open Ast
  open Loc
  open Enums
  open Utils

  let add_loc_info startpos endpos x = 
    {value = x ; loc = loc_of_lexing_pos startpos endpos}


  let rec set_type_first_decorator decorator = function
    | Tptr t -> Tptr (set_type_first_decorator decorator t)
    | Tref t -> Tref (set_type_first_decorator decorator t)
    | t -> decorator t

  (* Change l'information de type d'un [Ast.var] ou [Ast.qvar] *)
  let pointer (ty, ident) = 
    (set_type_first_decorator (fun t -> Tptr t) ty, ident)
  let reference (ty, ident) = 
    (set_type_first_decorator (fun t -> Tref t) ty, ident)

  let set_type_base base (ty, ident) = 
    let rec aux = function
      | Tptr t -> Tptr (aux t)
      | Tref t -> Tref (aux t)
      | _ -> base
    in (aux ty, ident)
  

  exception Virtual_attribute

  let set_virtual_flag v = function
    | (Attributes _) as a -> if v = None then a else raise Virtual_attribute
    | Prototype (_, p) -> 
        Prototype ((if v = None then Non_virtual else Virtual), p)

  (* Set the arguments of a [Ast.prototype] value *)
  let set_prototype_args args = function
    | Function_prototype (qvar, _) -> Function_prototype (qvar, args)
    | Constructor_prototype (id, _) -> Constructor_prototype (id, args)

  (* Used in the production [super] *)
  let list_of_list_option = function
    | None -> []
    | Some l -> l


%}

%token EOF
%token <string> IDENT
%token <string> TIDENT
%token <string> DEC_INT OCT_INT HEX_INT
%token <string> STRING

%token INCLUDE_DIRECTIVE
%token LEFT_PAREN RIGHT_PAREN
%token LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET 

%token DOUBLE_COLON COLON SEMICOLON COMMA DOT ARROW

%token ASSIGN NOT OR AND EQUAL NOT_EQUAL LT LE GT GE 
%token PLUS MINUS DIV MOD INCR DECR
%token STAR AMPERSAND STREAM_OP

%token CLASS ELSE FALSE FOR IF INT NEW NULL PUBLIC RETURN 
%token THIS TRUE VIRTUAL VOID WHILE


%start file
%type <Ast.file> file


%nonassoc IF
%nonassoc ELSE

%right ASSIGN
%left OR
%left AND
%left EQUAL NOT_EQUAL
%left LT LE GT GE
%left PLUS MINUS
%left STAR DIV MOD

/* All the unary operators belongs to the following class, 
thanks to further %prec annotations */
%right NOT INCR DECR

%left ARROW DOT

%nonassoc LEFT_PAREN


%%

file : include_directive? decls=decl* EOF {decls}

include_directive : INCLUDE_DIRECTIVE LT IDENT GT {}

decl : d=decl_value {add_loc_info $startpos $endpos d}

decl_value :
  | d=decl_vars SEMICOLON {Decl_globals d}

  | name=decl_class_beg supers=supers? LEFT_CURLY_BRACKET 
    PUBLIC COLON members=member* RIGHT_CURLY_BRACKET SEMICOLON
    {  let supers = list_of_list_option supers in
           Decl_class {class_name = name ; class_supers = supers ; 
                       class_members = members}
    }
  | p=prototype b=block {Decl_impl (p, add_loc_info $startpos $endpos **> b)}


decl_vars : ty=ty vars=separated_list(COMMA, var) 
   {List.map (set_type_base ty) vars}

decl_class_beg : CLASS id=IDENT {Tident.add id ; id}

supers : COLON ids=separated_nonempty_list(COMMA, super_item) {ids}

super_item : PUBLIC id=TIDENT {id}



member : virt=VIRTUAL? m=member_value SEMICOLON 
    {let m' = 
       try set_virtual_flag virt m 
       with Virtual_attribute -> $syntaxerror in 
     add_loc_info $startpos $endpos m'}

member_value : 
  | attrs=decl_vars {Attributes attrs}
  | p=prototype
    {Prototype (Non_virtual, p)}


prototype : proto=prototype_beg 
    LEFT_PAREN args=separated_list(COMMA, argument) RIGHT_PAREN 
    { set_prototype_args args proto }

prototype_beg :
  | ty=ty var=qvar {Function_prototype (set_type_base ty var, [])}
  | name=TIDENT {Constructor_prototype (name, [])}
  | scope=TIDENT DOUBLE_COLON name=TIDENT 
    {ignore scope ; Constructor_prototype (name, [])} /* assert(scope=name) */

argument : ty=ty var=var {set_type_base ty var}

ty :
  | VOID {Tvoid}
  | INT {Tint}
  | tident=TIDENT {Tident tident}

var :
  | id=IDENT {(Tvoid, id)}
  | STAR v=var {pointer v}
  | AMPERSAND v=var {reference v}

qvar :
  | qid=qident {(Tvoid, qid)}
  | STAR qv=qvar {pointer qv}
  | AMPERSAND qv=qvar {reference qv}

qident :
  | ident=IDENT {(ident, None)}
  | tident=TIDENT DOUBLE_COLON ident=IDENT {(ident, Some tident)}

expr : e=expr_value {add_loc_info $startpos $endpos e}
expr_value :
  | s=DEC_INT {Const (Int (s, Dec))}
  | s=OCT_INT {Const (Int (s, Oct))}
  | s=HEX_INT {Const (Int (s, Hex))}
  | THIS {This}
  | FALSE {Const False}
  | TRUE {Const True}
  | NULL {Const Null}
  | qid=qident {Qident qid}
  | e=expr DOT qid=qident {Member (e, qid)}
  | e=expr ARROW qid=qident 
      {Member (add_loc_info $startpos $endpos **> Unary_op (Unref, e), qid)}
  | f=expr LEFT_PAREN args=separated_list(COMMA, expr) RIGHT_PAREN 
      {Call (f, args)}
  | NEW ctor=TIDENT LEFT_PAREN args=separated_list(COMMA, expr) RIGHT_PAREN 
    {New (ctor, args)}
  | lhs=expr op=binary_op rhs=expr {Binary_op (op, lhs, rhs)}
  | op=prefix_unary_op e=expr {Unary_op (op, e)} %prec NOT
  | e=expr op=suffix_unary_op {Unary_op (op, e)}
  | LEFT_PAREN e=expr_value RIGHT_PAREN {e}

%inline binary_op : 
  | ASSIGN {Assign} | EQUAL {Eq} | NOT_EQUAL {Neq} 
  | LT {Lt} | LE {Leq} | GT {Gt} | GE {Geq}  | PLUS {Plus} | MINUS {Minus}  
  | STAR {Mul} | DIV {Div} | MOD {Mod} | AND {And} | OR {Or}

%inline prefix_unary_op : 
  | AMPERSAND {Addr} | STAR {Unref} | INCR {Incr_pre} | DECR {Decr_pre} 
  | NOT {Not} 
  | PLUS {Unary_plus} | MINUS {Unary_minus}

%inline suffix_unary_op : INCR {Incr_suf} | DECR {Decr_suf}

instr : i=instr_value {add_loc_info $startpos $endpos i}

instr_value :
  | SEMICOLON {Nop}
  | e=expr SEMICOLON {Expr e}
  | ty=ty decls=separated_list(COMMA, decl_local) SEMICOLON 
    {Decl_locals (List.map (fun (var, init) -> 
     (set_type_base ty var, init)) decls )}

  | IF LEFT_PAREN e=expr RIGHT_PAREN then_instr=instr 
    {Cond (e, then_instr, None)}  %prec IF

  | IF LEFT_PAREN e=expr RIGHT_PAREN then_instr=instr ELSE else_instr=instr
    {Cond (e, then_instr, Some else_instr)} 

  | WHILE LEFT_PAREN e=expr RIGHT_PAREN i=instr {While (e, i)}

  | FOR LEFT_PAREN arg1=separated_list(COMMA, expr) 
      SEMICOLON arg2=expr? SEMICOLON arg3=separated_list(COMMA, expr) 
      RIGHT_PAREN i=instr
      {For (arg1, arg2, arg3, i)}

  | b=block {b}
  | IDENT DOUBLE_COLON IDENT args=cout_arg+ SEMICOLON {Cout args}
  | RETURN e=expr? SEMICOLON {Return e}


decl_local : v=var init=var_init? {(v, Utils.get_option Init_empty init)}

var_init :
  | ASSIGN e=expr {Init_expr e}
  | ASSIGN ctor=TIDENT
    LEFT_PAREN args=separated_list(COMMA, expr) RIGHT_PAREN 
    {Init_constructor (ctor, args)}

cout_arg : STREAM_OP e=expr_str {e}

expr_str :
  | e=expr {S_expr e}
  | s=STRING {S_string s}

block : LEFT_CURLY_BRACKET is=instr* RIGHT_CURLY_BRACKET {Block is}
