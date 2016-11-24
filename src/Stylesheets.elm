port module Stylesheets exposing (..)

import Post.HavingFunCoding as HavingFunCoding


--

import Css exposing (..)
import Css.Elements as Tag
import Css.Namespace exposing (namespace)
import Css.File exposing (..)
import Platform


type CssClasses
    = Container
    | Timeline


shared =
    (stylesheet)
        [ Tag.body
            [ width (pct 100)
            , height (pct 100)
            , color (rgb 40 40 40)
            , backgroundColor (rgb 245 245 245)
            , margin zero
            , padding zero
            , fontSize (em 1.5)
            , lineHeight (em 1.5)
            , fontFamilies [ "Roboto", "Open Sans", "Helvetica Neue", "Helvetica" ]
            ]
        , (.) Container
            [ maxWidth (px 700)
            , margin2 (em 4) auto
            ]
        , (.) Timeline
            [ position fixed
            , top (pct 50)
            , transform (translateY (pct -50))
            , children
                [ Tag.li
                    [ transform (scale 0.3)
                    , hover
                        [ transform (scale 1) ]
                    ]
                ]
            ]
        ]


port files : CssFileStructure -> Cmd msg


cssFiles : CssFileStructure
cssFiles =
    toFileStructure [ ( "dist/main.css", Css.File.compile [ shared, HavingFunCoding.css ] ) ]


main : Program Never () msg
main =
    Platform.program
        { init = ( (), files cssFiles )
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        }
