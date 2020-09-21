open Lib
open Expr

(* Big list of TODO:
  - assignment (and tests)
    - assign
    - subset assignment (properly handle mutation and return value)
      - subset1_assign_nothing
      - subset1_assign
      - subset2_assign
    - sequencing
  - various other bugs that were fixed in the semantics
  - refactor?

  - parser
  - test oracle (using ocaml-r?)
  - interactive mode / repl
*)

let () =
  let e =
    Combine
      [ int_exp 1
      ; Negate (Combine [ int_exp ~-2; int_exp ~-3 ])
      ; int_exp 4
      ; int_exp 5
      ; na_exp T_Int
      ] in
  let res = Eval.run e in
  Format.printf "The result of evaluating:\n%s\n\nis:\n%s\n" (show_expression e) (show_val res) ;
  print_endline "Nothing else for now, maybe you meant to run the tests?"
