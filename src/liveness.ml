(* LIVENESS.ML
   Analyse de durée de vie des pseudo-registres
*)

open Fgraph
open Utils

type instr_info = {
  ii_instr            : Reg.pseudo instr ;

  ii_def              : Reg.S.t ;
  ii_use              : Reg.S.t ;
  ii_succs            : label list ;

  ii_live_in          : Reg.S.t ;
  ii_live_out         : Reg.S.t
}


let mkrset l = List.fold_right Reg.S.add l Reg.S.empty

let mklset l = List.fold_right Label.S.add l Label.S.empty

let empty = Reg.S.empty

let new_ii instr (defl, usel, succsl) =
  { ii_instr = instr ;

    ii_succs = succsl ;
    ii_def = mkrset defl ; 
    ii_use = mkrset usel ; 

    ii_live_in = Reg.S.empty ;
    ii_live_out = Reg.S.empty ;
  }

let def_use_succs = function
  | Const (r, _, l) -> [r], [], [l]
  | La (r, _, l) -> [r], [], [l]

  | Unop (r, _, a, l) -> [r], [a], [l]
  | Binop (r, _, a1, a2, l) -> [r], [a1; a2], [l]

  | Call (proc_id, nargs, l) -> 
      Reg.caller_saved, (prefix (min 4 nargs) Reg.params), [l]

  | Callr (r, nargs, l) ->
      Reg.caller_saved, r :: (prefix (min 4 nargs) Reg.params), [l]  

  | Load (d, _, s, l) -> [d], [s], [l]
  | Store (s, _, d, l) -> [], [s; d], [l]
  | Move (d, s, l) -> [d], [s], [l]

  | Store_stack (r, _, l) -> [], [r], [l]
  | Load_stack (r, _, l) -> [r], [], [l]
  | Stack_addr (r, _, l) -> [r], [], [l]

  | Ubranch (_, r1, l1, l2) -> [], [r1], [l1; l2]
  | Bbranch (_, r1, r2, l1, l2) -> [], [r1; r2], [l1; l2]
  | Goto l -> [], [], [l]

  | Return -> [], (Reg.Pseudo.ra :: Reg.callee_saved), []

  | Syscall l -> [Reg.Pseudo.v0], [Reg.Pseudo.v0; Reg.Pseudo.a0], [l]

  | Alloc_frame l -> [Reg.Pseudo.sp], [], [l]
  | Delete_frame l -> [], [Reg.Pseudo.sp], [l]



let compute_def_use_succs graph = 
  Label.M.fold (fun label ins acc ->
    Label.M.add label (new_ii ins **> def_use_succs ins) acc
  ) 
    graph Label.M.empty




let rec fixpoint f x = 
  let (fx, changed) = f x in 
  if changed then fixpoint f fx else fx


let update_infos infos = 

  let update_ii ii = 

    let new_in = Reg.S.union 
      (ii.ii_use) 
      (Reg.S.diff ii.ii_live_out ii.ii_def) in

    let new_out = List.fold_left (fun acc succ -> 
      Reg.S.union acc (Label.M.find succ infos).ii_live_in 
    ) 
      Reg.S.empty ii.ii_succs in

    let changed = not (
      Reg.S.equal new_in  ii.ii_live_in &&
        Reg.S.equal new_out ii.ii_live_out ) in

    let new_ii = { ii with
      ii_live_in = new_in ;
      ii_live_out = new_out ;
    } in

    (new_ii, changed)
  in

  Label.M.fold (fun label ii (acc, c) ->
    let (new_ii, changed) = update_ii ii in
    (Label.M.add label new_ii acc, c || changed)
  ) infos (Label.M.empty, false)
  



let analyse graph =

  (* Méthode du point fixe de Tarski *)
  let infos = fixpoint update_infos (compute_def_use_succs graph) in


  (* On établit une liste de tous les registres utilisés en effectuant 
     l'union sur tout le graphe des [ii_def] et [ii_use]
  *)
  let used_regs = Reg.S.elements **> Label.M.fold (fun _ ii acc ->
    Reg.S.union (Reg.S.union acc ii.ii_def) ii.ii_use
  ) infos Reg.S.empty in
  
  used_regs, infos
