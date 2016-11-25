module Main exposing (..)

import Posts exposing (..)


--

import Html exposing (Html, div, span, button, text, menu, a, img)
import Html.Attributes as Attr exposing (src)
import Html.Events exposing (onClick)
import Html.CssHelpers
import List
import List.Zipper
import Stylesheets exposing (CssClasses(..))
import MD5
import String exposing (toLower)


{ id, class, classList } =
    Html.CssHelpers.withNamespace ""


postItem post =
    a [ onClick (GotoPost post), class [ TimelineItem ] ] [ text post.title ]


photo : List -> Html Msg
photo props =
    let
        { email, size } =
            props

        url =
            "https://www.gravatar.com/avatar/"

        hash =
            (MD5.hex (toLower email))
    in
        img [ class [ Photo ], src (url ++ hash ++ "?s=" ++ size) ]


footer =
    Html.footer []
        [ span [ Attr.class "ion-social-github" ] []
        , a [] [ text "Status" ]
        , a [] [ text "Privacy Policy" ]
        , a [] [ text "Terms of Service" ]
        ]


view : Model -> Html Msg
view model =
    let
        post =
            List.Zipper.current model.posts
    in
        div [ class [ Column ] ]
            [ menu [ class [ Timeline ] ] (List.map postItem (List.Zipper.toList model.posts))
            , div [ class [ Container ] ]
                [ post.content
                , photo [ email post.author.email, size 200 ]
                , footer
                ]
            ]


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }
