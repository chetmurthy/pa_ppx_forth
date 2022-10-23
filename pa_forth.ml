(* camlp5o *)
(* pa_forth.ml,v *)
(* Copyright (c) INRIA 2007-2017 *)

open Pa_ppx_base
open Pa_passthru
open Ppxutil

let conv = function
    <:expr:< $int:n$ >> -> <:expr< num $int:n$ >>
  | e -> e

let build_forth loc eopt =
  let rec brec acc = function
    [] -> acc
  | h::t ->
     let f = "|>" in
     brec <:expr< $lid:f$ $exp:acc$ $exp:conv h$ >> t in
  match  eopt with
    None -> brec <:expr< start () >> []
  | Some e ->
     let (f,l) = Expr.unapplist e in
     brec <:expr< start () >> (f::l)

let rewrite_expr arg = function
  <:expr:< [%forth $exp:e$ ;] >> -> build_forth loc (Some e)
| <:expr:< [%forth] >> -> build_forth loc None
| _ -> assert false


let install () = 
let ef = EF.mk () in 
let ef = EF.{ (ef) with
            expr = extfun ef.expr with [
    <:expr:< [%forth] >> | <:expr:< [%forth $_$ ;] >> as z ->
    fun arg fallback ->
      Some (rewrite_expr arg z)
  ] } in
  Pa_passthru.(install { name = "pa_forth"; ef =  ef ; pass = None ; before = [] ; after = [] })
;;

install();;
