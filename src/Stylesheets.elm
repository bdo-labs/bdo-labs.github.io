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
    | TimelineItem
    | Column
    | Photo


shared =
    (stylesheet)
        [ Tag.html [ height (pct 100) ]
        , Tag.body
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
        , Tag.h1
            [ after
                [ display block
                , backgroundColor (rgba 0 0 0 0.1)
                , lineHeight (int 2)
                , width (em 4)
                , height (em 0.1)
                , margin2 (em 1) zero
                ]
            ]
        , Tag.pre
            [ backgroundColor (rgb 47 30 46)
            , color (rgb 163 158 155)
            , fontFamilies [ "Fira Code", "Monaco", "Monospace" ]
            , padding (em 1)
            , borderRadius (em 0.1)
            ]
        , Tag.footer
            [ opacity (num 0.4)
            , fontSize (em 0.6)
            , flex none
            , padding (px 50)
            , hover
                [ opacity (num 1) ]
            , children
                [ Tag.a
                    [ display inlineBlock
                    , padding2 zero (em 1)
                    ]
                ]
            ]
        , (.) Photo
            [ borderRadius (pct 50)
            , transform (scale 0.5)
            ]
        , (.) Column
            [ (displayFlex)
            , flexDirection column
            , height (pct 100)
            ]
        , (.) Container
            [ maxWidth (px 700)
            , margin2 zero auto
            , padding (px 50)
            , flex (int 1)
            ]
        , (.) Timeline
            [ listStyle none
            , fontSize (em 0.8)
            , padding (px 50)
            , position relative
            , margin zero
            , children
                [ (.) TimelineItem
                    [ display block
                    , cursor pointer
                    ]
                ]
            ]
        , mediaQuery "screen and ( max-width: 1279px )"
            [ (.) Timeline
                [ backgroundColor (rgb 47 30 46)
                , maxHeight (em 10)
                , color (rgb 213 208 205)
                , overflow auto
                , boxShadow5 inset zero (px -8) (px 8) (rgba 27 10 26 0.6)
                , after
                    [ display block
                    , position fixed
                    , bottom zero
                    , left zero
                    , width (pct 100)
                    , height (em 2)
                    ]
                ]
            , (.) TimelineItem
                [ hover
                    [ color (rgb 253 248 245) ]
                ]
            ]
        , mediaQuery "screen and ( min-width: 1280px )"
            [ (.) Timeline
                [ position fixed
                , fontSize (vw 1.5)
                , top zero
                , children
                    [ (.) TimelineItem
                        [ transform (scale 0.5)
                        , position relative
                        , paddingLeft (em 4)
                        , margin2 (em 0.25) zero
                        , before
                            [ backgroundColor (rgba 0 0 0 0.1)
                            , left zero
                            , top (pct 50)
                            , display block
                            , width (em 3)
                            , height (em 0.2)
                            , position absolute
                            ]
                        , hover
                            [ transform (scale 1)
                            , before
                                [ backgroundColor (rgba 0 0 0 0.5) ]
                            ]
                        ]
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
