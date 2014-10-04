(* REG_ALLOC.ML
   Allocation simple de registres par coloriage de graphes
*)

open Liveness
open Fgraph
open Utils

type edges = { 
  prefs : Reg.S.t ;
  intfs : Reg.S.t ;

  (* Noms des noeuds qui ont été fusionnés avec le noeud présent *)
  aliases : Reg.S.t ; 
}

type graph = edges Reg.M.t

type color =
  | Cspilled of int
  | Creg of Reg.real

type coloration = color Reg.M.t

module Cset = Set.Make(struct type t = color let compare = compare end)


(* Quelques fonctions de manipulation de graphe *)

let empty_edges = {
  prefs = Reg.S.empty ; 
  intfs = Reg.S.empty ; 
  aliases = Reg.S.empty
}


let empty_graph nodes_list =
  List.fold_left (fun acc el -> 
    Reg.M.add el empty_edges acc) 
    Reg.M.empty nodes_list

let edges s g = try Reg.M.find s g with Not_found -> empty_edges
let prefs s g = (edges s g).prefs
let intfs s g = (edges s g).intfs
let aliases s g = (edges s g).aliases
let pref x y g = Reg.S.mem x (prefs y g)
let intf x y g = Reg.S.mem x (intfs y g)

let add_pref x y g = 
  if intf x y g || x = y then g 
  else
    let aux x y g =
      let x_edges = edges x g in 
      Reg.M.add x {x_edges with prefs = Reg.S.add y x_edges.prefs} g
    in aux x y (aux y x g)

let remove_pref x y g =
   let aux x y g =
      let x_edges = edges x g in 
      Reg.M.add x {x_edges with prefs = Reg.S.remove y x_edges.prefs} g
    in aux x y (aux y x g)

let add_intf x y g =
  let aux x y g =
    let x_edges = edges x g in 
    Reg.M.add x {x_edges with intfs = Reg.S.add y x_edges.intfs} g
  in aux x y (aux y x (remove_pref x y g))


let remove_node n g = 
  let g = Reg.M.map (fun edges -> 
    { prefs = Reg.S.remove n edges.prefs;
      intfs = Reg.S.remove n edges.intfs;
      aliases = Reg.S.remove n edges.aliases;
    }
  ) g in
  Reg.M.remove n g


let add_aliases x aliases g = 
  let x_edges = edges x g in
  let x_edges' = 
    { x_edges with aliases = Reg.S.union aliases x_edges.aliases } in
  Reg.M.add x x_edges' g


let merge_nodes x y g' =
  let y_edges = edges y g' in
  let g = remove_node y g' in
  let g = Reg.S.fold (add_intf x) y_edges.intfs g in
  let g = Reg.S.fold (add_pref x) y_edges.prefs g in
  let g = add_aliases x (Reg.S.add y (y_edges.aliases)) g in
  g
  
  



(* Création du graphe d'interférences *)
let make_intfs_g (regs, linfs) = 

  let graph = ref (empty_graph regs) in

  let add_intf x y = graph := add_intf x y !graph in
  let add_pref x y = graph := add_pref x y !graph in

  let read_instr_info ii = 
    match ii.ii_instr with
      | Move (v, w, _)-> 
          if v <> w then  begin
            add_pref v w;
            Reg.S.iter 
              (fun wi -> if wi <> v && wi <> w then add_intf v wi) 
              ii.ii_live_out
          end
      | _ -> 
          Reg.S.iter (fun v ->
            Reg.S.iter (fun wi -> if wi <> v then add_intf v wi) ii.ii_live_out
          ) ii.ii_def

  in
  Label.M.iter (fun _ ii -> read_instr_info ii) linfs;


  (* Les registres physiques interfèrent deux à deux *)

  List.iter (fun r -> 
    List.iter (fun r' -> add_intf r r') (Utils.list_remove r Reg.all) 
  ) Reg.all ;

  !graph








(* Affichage du graphe d'allocation *)

open Format

let print_prset print_el ff s = 
  Reg.S.iter (fun el -> fprintf ff "%a " print_el el) s

let print_preg ff preg = fprintf ff "%s" (Reg.string_of_pseudo preg)

let print_edges ff e = 
  fprintf ff "INTFS = { %a},  PREFS = { %a}" 
    (print_prset print_preg) e.intfs
    (print_prset print_preg) e.prefs

let print_graph ff g = 
  Reg.M.iter (fun preg edges -> 
    fprintf ff "[%a] :   %a\n" print_preg preg print_edges edges
  )
    g

let print_color ff = function
  | Cspilled pos -> fprintf ff "stack(%d)" pos
  | Creg r -> fprintf ff "%s" (Reg.name_of_id r)

let dump_colors ff col = 
  Reg.M.iter (fun preg col -> fprintf ff "%s : %a\n"
    (Reg.string_of_pseudo preg)
    print_color col
  ) col







(* Heuristique de coloriage de graphe *)

let colors = List.map (fun r -> Creg r) Reg.colors
let ncols  = List.length colors

(* Dans un premier temps, on ne décide pas de l'emplacement exact
   sur la pile des registres spillés *)
let spilled_col = Cspilled (-1)


(* Un noeud est trivialement colorable s'il ne représente pas un
   registre physique et s'il est soit fusionné avec un registre physique soit
   - Simplifiable : pas d'arrêtes de préférence avec 
     un autre registre temporaire
   - De poids faible : arité inférieure au nombre de couleurs
*)
let is_trivially_colorable g n = 
  (not (Reg.is_real n)) && 
       (Reg.S.for_all Reg.is_real (prefs n g) 
        && (Reg.S.cardinal (intfs n g) < ncols))


(* Renvoie None si le noeud ne peut pas être fusionné, 
   Some ("couple fusionnable") sinon *)
let could_be_merged g n = 

  if Reg.is_real n then None else
  try
    let merged = List.find (fun x ->    
      Reg.S.cardinal (Reg.S.union (intfs n g) (intfs x g)) < ncols
      || Reg.S.for_all (fun v -> intf v x g) (intfs n g)
     ) (List.filter (not % Reg.is_real) **> Reg.S.elements (prefs n g)) 
    in
    if n <> merged then Some (n, merged) else None

  with Not_found -> None


let color_of_pseudo pr = Creg (Reg.real_of_pseudo pr)

(* Tente de colorier un noeud temporaire et le spill sinon *)
let color_node g n coloration = 

  assert (not **> Reg.is_real n);

  let colored = Reg.S.add n (aliases n g) in
  let color =
    let forbidden = Reg.S.fold (fun intf acc ->
      try Cset.add (Reg.M.find intf coloration) acc with Not_found -> acc
    ) (intfs n g) Cset.empty in

    (* On essaie tant que possible de colorier le noeud avec un registre 
       physique relié par une arrête de préférence *)
    let prefered = 
      List.map color_of_pseudo
      (Reg.S.elements **> Reg.S.filter Reg.is_real (prefs n g)) in

    (* Sinon, on essaie tout de même d'utiliser un registre $ti 
       à faible durée de vie *)
    let ti_regs = 
     List.map color_of_pseudo Reg.ti in

    (* En dernier recours, on prend une couleur disponible quelconque *)
    let applicants =  prefered @ ti_regs @ colors in

    try List.find (fun c -> not (Cset.mem c forbidden)) applicants
    with Not_found -> spilled_col

  in 
  Reg.S.fold (fun r acc -> Reg.M.add r color acc) colored coloration
  

(* Indique s'il ne reste que des registres physiques dans le graphe *)
let only_real_regs_left g = 
  List.for_all (Reg.is_real % fst) **> Reg.M.bindings g


(* On colore de manière évidente les registres physiques *)
let real_registers_coloration  = 
  List.fold_left (fun col r -> 
    Reg.M.add r (Creg (Reg.real_of_pseudo r)) col) 
    Reg.M.empty Reg.all



let rec color_graph g = 

  if only_real_regs_left g then real_registers_coloration
  else

    (* On cherche un noeud simplifiable de faible degré ou un registre
       physique déjà colorié, et on le retire *)
    try
      
      let tc = List.find (is_trivially_colorable g) **> 
        List.map fst (Reg.M.bindings g) in

      let coloration = color_graph (remove_node tc g) in
      color_node g tc coloration

    with Not_found -> try_merging_nodes g


(* Premiers recours : fusionner deux noeuds sans risquer de perdre 
   la colorabilité *)
and try_merging_nodes g = 

  try
    let (x, y) = Utils.find_some **>
      List.map ((could_be_merged g) % fst) (Reg.M.bindings g) in
    (* fprintf std_formatter "MERGING (%a, %a)\n" print_preg x print_preg y ; *)
    color_graph (merge_nodes x y g)

  with Not_found -> remove_pref_edges g


(* Second recours : supprimer les arrêtes de préférence 
   d'un noeud de faible degré *)
and remove_pref_edges g = 

  let rec check_nodes = function
    | (n, edges)::ns -> 
        if Reg.S.cardinal edges.intfs < ncols then
          color_graph **> Reg.S.fold (remove_pref n) edges.prefs g
        else
          check_nodes ns

    | [] -> spill_node g

  in check_nodes (Reg.M.bindings g)


(* Dernier recours : spiller potentiellement un noeud de fort degré *)
and spill_node g =

  let applicants = List.map (fun (n, edges) -> 
    (Reg.S.cardinal edges.intfs, n)
  ) (List.filter (not % Reg.is_real % fst)  **> Reg.M.bindings g) in

  let max_arity = Utils.max_list (List.map fst applicants) in
  let spilled = List.assoc max_arity applicants in 

  let coloration = color_graph (remove_node spilled g) in

  color_node g spilled coloration

  

  







  
  

  


(* Stratégie d'allocation minimaliste : 
   tous les registres temporaires sont spillés *)
let spill_all proc =

  let intfs_g = make_intfs_g (Liveness.analyse proc.Fgraph.proc_graph) in

  (* Représente le premier emplacement libre sur le cadre de pile *)
  let next_frame_pos = - proc.Fgraph.proc_frame_size in

  let next_frame_pos, coloration = Reg.M.fold (fun preg _ (offset, cols) -> 
    if Reg.is_real preg then (offset, cols) else
      (offset - word_size, Reg.M.add preg (Cspilled offset) cols)
  ) intfs_g (next_frame_pos, real_registers_coloration) in

  let new_frame_size = - next_frame_pos in

  dump_colors (Format.std_formatter) coloration ;

  (new_frame_size, coloration)



(* Stratégie d'allocation par coloration de graphe *)

let alloc proc =
  let liveness_infos = Liveness.analyse proc.Fgraph.proc_graph in
  let intfs_g = make_intfs_g liveness_infos in

  let coloration = color_graph intfs_g in

  (* Représente le premier emplacement libre sur le cadre de pile *)
  let next_frame_pos = - proc.Fgraph.proc_frame_size in

  let next_frame_pos, coloration = Reg.M.fold (fun preg col (offset, cols) ->
    match col with
      | Cspilled _ -> 
          (offset - word_size, Reg.M.add preg (Cspilled offset) cols)
      | _ -> (offset, Reg.M.add preg col cols)

  ) coloration (next_frame_pos, Reg.M.empty)
  in
  
  let new_frame_size = - next_frame_pos in


  (* A décommenter pour déboger *)

  (*
  let ff = formatter_of_out_channel stdout in

  Print_fgraph.print_ertl_with_liveness_infos 
    ff proc.proc_id proc liveness_infos ;

  
  printf "\n\n" ;

  print_graph ff intfs_g ;

  printf "\n\n" ;

  dump_colors ff (coloration) ;*)


  (new_frame_size, coloration)


  






















