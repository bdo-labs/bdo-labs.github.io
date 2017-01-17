module Main exposing (..)

import Posts exposing (..)


--

import Html exposing (Html, div, span, button, text, menu, a, img, small, ul, li, node)
import Html.Attributes as Attr exposing (src, attribute)
import Html.Events exposing (onClick)
import Html.CssHelpers
import List
import List.Zipper
import Stylesheets exposing (CssClasses(..))
import MD5
import String exposing (toLower, trim)


{ id, class, classList } =
    Html.CssHelpers.withNamespace ""


stylesheet scheme =
    let
        tag =
            "link"

        attrs =
            [ Attr.attribute "rel" "stylesheet"
            , Attr.attribute "property" "stylesheet"
            , Attr.attribute "href" ("./styles/paraiso-" ++ scheme ++ ".css")
            ]

        children =
            []
    in
        node tag attrs children


postItem post =
    if (not post.draft) then
        a [ onClick (GotoPost post), class [ TimelineItem ] ] [ text post.title ]
    else
        span [] []


type alias PhotoModel =
    { email : String
    , size : Int
    }


photo : PhotoModel -> Html Msg
photo props =
    let
        { email, size } =
            props

        hash =
            (MD5.hex (toLower (trim email)))

        url =
            "https://www.gravatar.com/avatar/" ++ hash ++ "?s=" ++ (toString size)
    in
        a [ Attr.href ("mailto:" ++ email) ]
            [ img [ class [ Photo ], src url ] [] ]



-- img [ class [ Logo ], Attr.src "./bdo.svg" ] []


footer =
    Html.footer [ class [ Row ] ]
        [ --   a [] [ text "Status" ]
          -- , a [] [ text "Privacy Policy" ]
          -- , a [] [ text "Terms of Service" ]
          span [ class [ Flex ] ] []
        , a [ Attr.href "https://github.com/bdo-labs/", Attr.class "ion-social-github", Attr.style [ ( "font-size", "1.8rem" ) ] ] []
        ]


view : Model -> Html Msg
view model =
    let
        post =
            List.Zipper.current model.posts

        author =
            post.author

        fullname =
            author.firstname ++ " " ++ author.lastname

        scheme =
            if (model.light) then
                "light"
            else
                "dark"
    in
        div
            [ classList
                [ ( "Light", model.light )
                , ( "Dark", (not model.light) )
                , ( "Wrapper", True )
                ]
            ]
            [ (stylesheet scheme)
            , menu [ class [ Timeline ] ] (List.map postItem (List.Zipper.toList model.posts))
            , div [ class [ Container ] ]
                [ button
                    [ class [ LightSwitch ], (onClick ToggleLight) ]
                    [ span
                        [ classList
                            [ ( "ion-ios-lightbulb", model.light )
                            , ( "ion-ios-lightbulb-outline", (not model.light) )
                            ]
                        ]
                        []
                    ]
                , post.content
                , div [ class [ Author, Row ] ]
                    [ photo
                        { email = author.email
                        , size = 200
                        }
                    , div [ class [ Column ] ]
                        [ small []
                            [ text fullname
                            , span [ class [ Published ] ] [ text post.date ]
                            ]
                        , case (author.bio) of
                            Just bio ->
                                small [ class [ Biography ] ] [ text bio ]

                            Nothing ->
                                div [] []
                        , div [ class [ Social ] ]
                            [ case (author.github) of
                                Just username ->
                                    let
                                        url =
                                            "https://github.com/" ++ username
                                    in
                                        a [ Attr.href url, Attr.class "ion-social-github" ] []

                                Nothing ->
                                    span [] []
                            , case (author.twitter) of
                                Just username ->
                                    let
                                        url =
                                            "https://twitter.com/" ++ username
                                    in
                                        a [ Attr.href url, Attr.class "ion-social-twitter" ] []

                                Nothing ->
                                    span [] []
                            ]
                        ]
                    ]
                ]
            , footer
            ]


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }
