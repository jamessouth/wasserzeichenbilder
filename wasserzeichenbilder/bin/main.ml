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

let image_file =
  Command.Arg_type.create (fun filename ->
      match
        ( Sys_unix.is_file filename,
          List.exists [ "jpg"; "jpeg"; "png"; "webp"; "gif" ] ~f:(fun x ->
              match snd (Filename.split_extension filename) with
              | Some e -> String.( = ) e x
              | None -> false) )
      with
      | `Yes, true -> filename
      | `Yes, false -> failwith "Not an image file"
      | `No, _ -> failwith "Not a regular file"
      | `Unknown, _ -> failwith "Could not determine if this was a regular file")

let () =
  Command_unix.run ~version:"1.0.0" ~build_info:"RWO"
    (Command.basic
       ~summary:
         "        Wasserzeichenbilder (watermark images)\n\
          Linux-ize your background images with your distro logo\n\
         \            󱄛     󰣨         󱄚 "
       ~readme:(fun () -> "Enter your image and a name for the output")
       (let%map_open.Command gravity =
          flag_optional_with_default_doc "-gravity" gravities
            (fun x -> String.sexp_of_t (Gravity.to_string x))
            ~default:Center ~doc:"string placement of the logo on the image"
        and font =
          flag_optional_with_default_doc "-font" string
            (fun x -> String.sexp_of_t x)
            ~default:"FiraCode-Nerd-Font-Mono-Reg"
            ~doc:"string font containing the logo character"
        and pointsize =
          flag_optional_with_default_doc "-pointsize" int
            (fun x -> Int.sexp_of_t x)
            ~default:300 ~doc:"int pointsize of the logo character"
        and elevation =
          flag_optional_with_default_doc "-elevation" int
            (fun x -> Int.sexp_of_t x)
            ~default:2 ~doc:"int height/depth of logo"
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
            ~default:""
            ~doc:"string logo character (default:  (Linux penguin))"
        and image =
          flag "-image" (required image_file)
            ~doc:"string the input image (jpg, jpeg, png, webp, gif)"
        and output =
          flag "-output" (required string) ~doc:"string the output filename"
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
          Stdlib.print_string logo;
          Stdlib.print_string image;
          Stdlib.print_string output;
          Stdlib.print_newline ();
          
          
          Wasserzeichenbilder.Wzb.run
          
          ))
