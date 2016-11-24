module Main exposing (..)

import Posts exposing (..)


--

import Html exposing (Html, div, span, button, text, ul, li)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import List
import List.Zipper


postItem post =
    li [] [ text post.title ]


view : Model -> Html Msg
view model =
    let
        post =
            List.Zipper.current model.posts
    in
        div []
            [ div [ class "Container" ] [ post.content ]
            , ul [ class "Timeline" ] (List.map postItem (List.Zipper.toList model.posts))
            ]


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }
