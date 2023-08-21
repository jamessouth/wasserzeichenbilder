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
          flag "-font"
            (optional_with_default "FiraCode-Nerd-Font-Mono-Reg" string)
            ~doc:"string font (default: FiraCode-Nerd-Font-Mono-Reg)"
        and pointsize =
          flag "-pointsize"
            (optional_with_default 300 int)
            ~doc:"string pointsize (default: 300)"
        and elevation =
          flag "-elevation"
            (optional_with_default 2 int)
            ~doc:"string elevation (default: 2)"
        and color1 =
          flag "-color1"
            (optional_with_default "black" string)
            ~doc:"string color1 (default: black)"
        and color2 =
          flag "-color2"
            (optional_with_default "white" string)
            ~doc:"string color2 (default: white)"
        and color3 =
          flag "-color3"
            (optional_with_default "#555555" string)
            ~doc:"string color3 (default: #555555)"
        and color4 =
          flag "-color4"
            (optional_with_default "#33333355" string)
            ~doc:"string color4 (default: #33333355)"
        and logo =
          flag_optional_with_default_doc "-logo"
            string (fun s -> Sexp.of_string s) ~default: ""
            ~doc:"string logo"
        in
        (* (default:  (Linux penguin mascot)) *)
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
