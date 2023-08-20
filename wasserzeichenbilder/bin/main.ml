open Core

module Gravity : Command.Enumerable_stringable = struct
  type t =
    | NorthWest
    | North
    | NorthEast
    | West
    | Center
    | East
    | SouthWest
    | South
    | SouthEast
  [@@deriving enumerate]

  let to_string = function
    | NorthWest -> "NorthWest"
    | North -> "North"
    | NorthEast -> "NorthEast"
    | West -> "West"
    | Center -> "Center"
    | East -> "East"
    | SouthWest -> "SouthWest"
    | South -> "South"
    | SouthEast -> "SouthEast"
end

let gravity =
  (module Gravity : Command.Enumerable_stringable with type t = Gravity.t)

let gravities =
  Command.Arg_type.enumerated ~accept_unique_prefixes:false
    ~case_sensitive:false ~list_values_in_help:true gravity

let () =
  Command_unix.run ~version:"1.0" ~build_info:"RWO"
    (Command.basic ~summary:"fib clock"
       ~readme:(fun () -> "Enter ")
       (let%map_open.Command gravity =
          flag "-gravity"
            (one_or_more_as_pair gravities)
            ~doc:"string gravity"
        in

        fun () ->
          let grav = fst gravity in

          Stdlib.print_string (Gravity.to_string grav)))
