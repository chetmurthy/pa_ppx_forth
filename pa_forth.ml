(* camlp5o *)
(* pa_forth.ml,v *)
(* Copyright (c) INRIA 2007-2017 *)

open Pa_ppx_base
open Pa_passthru
open Ppxutil

let build_forth loc e =
  let rec brec acc = function
    [] -> acc
  | h::t ->
     let f = "|>" in
     brec <:expr< $lid:f$ $exp:acc$ $exp:h$ >> t in
  let (f,l) = Expr.unapplist e in
  brec <:expr< start () >> (f::l)

let rewrite_expr arg = function
  <:expr:< [%forth $exp:e$ ;] >> -> build_forth loc e
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
