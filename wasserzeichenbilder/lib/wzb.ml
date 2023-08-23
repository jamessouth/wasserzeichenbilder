open Core
module Unix = Core_unix

let run =
  match Unix.system "echo hello" with
  | Ok u -> u
  | Error e -> (
      match e with
      | error -> (
          match error with
          | `Exit_non_zero c -> Stdlib.print_int c
          | `Signal s -> Stdlib.print_string (Signal.to_string s)))
