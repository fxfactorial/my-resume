open StdLabels
open Reactjs
open Lwt.Infix
open Nodejs_high_level_lwt

module S = Yojson.Safe
module U = Yojson.Safe.Util

let head = Infix.(
    Elem (DOM.make ~tag:`head [
        Elem (DOM.make ~tag:`title [Text "Edgar Aroutiounian - Resume"]);
        Elem (DOM.make ~elem_spec:(object%js
                val name = !*"viewport"
                val content = !*"width=device-width, initial-scale=1"
              end) ~tag:`meta []);
        Common_components.stylesheet
          ~href:"https://maxcdn.bootstrapcdn.com/\
                 bootstrap/3.3.5/css/bootstrap.min.css" ();
        Common_components.stylesheet
          ~href:"https://maxcdn.bootstrapcdn.com/\
                 font-awesome/4.4.0/css/font-awesome.min.css" ();
        Common_components.stylesheet
          ~href:"styles.css" ();

      ])
  )

let resume data =
  make_class_spec
    (fun ~this ->
       let body =
         Elem (DOM.make ~tag:`body [
           Elem (DOM.make ~tag:`div [])
         ])
       in

       DOM.make ~tag:`html [
         head;
         body;
       ]
    )
  |> create_class

let () =
  Lwt.async (fun () ->
      let p = Nodejs_high_level.process in
      let args = p#arguments in

      if List.length args <> 3
      then begin
        "Must provide input json file of resume.json for PDF generation"
        |> prerr_endline;
        p#exit 1
      end;

      let posts_file = List.nth args 2 in

      (* let read_string ~key o = U.member key o |> U.to_string in *)

      Fs.read_file posts_file >|= fun (_, data) ->
      let j = S.from_string data#to_string in

      let rendered =
        (Reactjs.react_dom_server ())
        ##renderToStaticMarkup (resume j
                                |> create_element_from_class)
        |> Js.to_string
      in
      print_endline rendered
    )
