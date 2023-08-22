open Core

module Gravity = struct
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
  [@@deriving enumerate, show { with_path = false }]

  let to_string = show
end

let gravities =
  Command.Arg_type.enumerated ~accept_unique_prefixes:false
    ~case_sensitive:false ~list_values_in_help:true
    (module Gravity : Command.Enumerable_stringable with type t = Gravity.t)

let () =
  Command_unix.run ~version:"1.0.0" ~build_info:"RWO"
    (Command.basic ~summary:"fib clock"
       ~readme:(fun () -> "Enter ")
       (let%map_open.Command gravity =
          flag "-gravity"
            (optional_with_default Gravity.Center gravities)
            ~doc:"string gravity (default: Center)"
        and font =
          flag_optional_with_default_doc "-font" string
            (fun x -> String.sexp_of_t x)
            ~default:"FiraCode-Nerd-Font-Mono-Reg" ~doc:"string font"
        and pointsize =
          flag_optional_with_default_doc "-pointsize" int
            (fun x -> Int.sexp_of_t x)
            ~default:300 ~doc:"int pointsize"
        and elevation =
          flag_optional_with_default_doc "-elevation" int
            (fun x -> Int.sexp_of_t x)
            ~default:2 ~doc:"int elevation"
        and color1 =
          flag_optional_with_default_doc "-color1" string
            (fun x -> String.sexp_of_t x)
            ~default:"black" ~doc:"string color1"
        and color2 =
          flag_optional_with_default_doc "-color2" string
            (fun x -> String.sexp_of_t x)
            ~default:"white" ~doc:"string color2"
        and color3 =
          flag_optional_with_default_doc "-color3" string
            (fun x -> String.sexp_of_t x)
            ~default:"#555555" ~doc:"string color3"
        and color4 =
          flag_optional_with_default_doc "-color4" string
            (fun x -> String.sexp_of_t x)
            ~default:"#33333355" ~doc:"string color4"
        and logo =
          flag_optional_with_default_doc "-logo" string
            (fun _ -> Sexp.Atom "_")
            ~default:"" ~doc:"string logo (default:  (Linux penguin mascot))"
        in

        fun () ->
          Stdlib.print_string (Gravity.to_string gravity);
          Stdlib.print_string font;
          Stdlib.print_int pointsize;
          Stdlib.print_int elevation;
          Stdlib.print_string color1;
          Stdlib.print_string color2;
          Stdlib.print_string color3;
          Stdlib.print_string color4;
          Stdlib.print_string logo))
