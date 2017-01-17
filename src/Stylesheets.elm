port module Stylesheets exposing (..)

-- import Post.HavingFunCoding as HavingFunCoding
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
    | Row
    | Photo
    | Author
    | Social
    | LightSwitch
    | Light
    | Dark
    | Spread
    | Wrapper
    | Published
    | Biography
    | Flex
    | Logo


shared =
    (stylesheet)
        [ each [ Tag.html, Tag.body ]
            [ margin zero
            , padding zero
            , height (pct 100)
            ]
        , Tag.body
            [ overflow hidden
            , fontSize (em 1.5)
            , lineHeight (em 1.5)
            , fontFamilies [ "Roboto", "Open Sans", "Helvetica Neue", "Helvetica" ]
            ]
        , Tag.a
            [ color (rgb 130 130 130)
            , hover
                [ color (rgb 80 80 80) ]
            ]
        , Tag.button
            [ cursor pointer
            , outline none
            ]
        , (.) Wrapper
            [ height (pct 100)
            , overflow auto
            ]
        , (.) Logo
            [ transform (scale 0.5) ]
        , (.) Flex
            [ flex (num 1) ]
        , (.) Light
            [ backgroundColor (rgb 245 245 245)
            , color (rgb 40 40 40)
            , descendants
                [ Tag.pre
                    [ backgroundColor (rgb 47 30 46)
                    , color (rgb 163 158 155)
                    ]
                ]
            ]
        , (.) Biography
            [ fontSize (em 0.5)
            ]
        , (.) Dark
            [ backgroundColor (rgb 27 35 44)
            , color (rgb 235 235 225)
            , descendants
                [ Tag.pre
                    [ backgroundColor (rgb 231 233 219)
                    , color (rgb 79 66 76)
                    ]
                , (.) LightSwitch
                    [ color (rgb 255 255 255) ]
                , (.) Social
                    [ backgroundColor (rgb 20 20 20) ]
                , Tag.a [ hover [ color (rgb 250 250 250) ] ]
                ]
            ]
        , Tag.h1
            [ after
                [ display block
                , backgroundColor (rgba 0 0 0 0.2)
                , lineHeight (int 2)
                , width (em 4)
                , height (em 0.1)
                , margin2 (em 1) zero
                ]
            ]
        , each [ Tag.h2, Tag.h3, Tag.h4, Tag.h5 ]
            [ marginTop (em 2) ]
        , Tag.pre
            [ fontFamilies [ "Fira Code", "Monaco", "Monospace" ]
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
        , (.) LightSwitch
            [ borderStyle none
            , backgroundColor transparent
            , position absolute
            , fontSize (em 1)
            , right (px 50)
            , top (px 50)
            , after
                [ display block
                , top (px 14)
                , left (pct 50)
                , transform (translateX (pct -50))
                , position absolute
                , width (px 4)
                , height (px 1)
                , backgroundColor (rgb 255 255 220)
                , boxShadow5 zero zero (px 10) (px 2) (rgb 255 255 220)
                , opacity (num 0)
                ]
            , hover
                [ after
                    [ opacity (num 1)
                    ]
                ]
            ]
        , (.) Photo
            [ borderRadius (em 0.2)
            , overflow hidden
            , width (px 100)
            ]
        , (.) Author
            [ marginTop (em 3)
            , alignItems center
            , children
                [ Tag.div [ marginLeft (em 1) ]
                , Tag.small
                    [ marginLeft (em 1)
                    ]
                ]
            ]
        , (.) Published
            [ fontSize (em 0.6)
            , marginLeft (em 1)
            , color (rgb 145 145 145)
            ]
        , (.) Social
            [ padding2 (em 0.1) (em 0.2)
            , borderRadius (em 0.8)
            , backgroundColor (rgb 255 255 255)
            , alignSelf flexStart
            , transform (scale 0.75)
            , children
                [ Tag.a
                    [ display inlineBlock
                    , margin2 zero (em 0.5)
                    ]
                ]
            ]
        , (.) Column
            [ (displayFlex)
            , flexDirection column
            , height (pct 100)
            ]
        , (.) Row
            [ (displayFlex)
            , flexDirection row
            ]
        , (.) Container
            [ maxWidth (px 700)
            , width (pct 100)
            , margin2 zero auto
            , padding (px 50)
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
            [ (.) Container [ position relative ]
            , (.) Dark
                [ descendants
                    [ (.) Timeline
                        [ borderBottom3 (px 1) solid (rgb 50 50 50) ]
                    , (.) TimelineItem
                        [ hover
                            [ color (rgb 80 80 80) ]
                        ]
                    ]
                ]
            , (.) Timeline
                [ backgroundColor (rgb 245 245 245)
                , borderRadius (em 0.2)
                , margin (px 25)
                , padding (px 25)
                , maxHeight (em 10)
                , overflow auto
                ]
            ]
        , mediaQuery "screen and ( min-width: 1280px )"
            [ (.) Timeline
                [ position fixed
                , fontSize (vw 0.7)
                , top zero
                , children
                    [ (.) TimelineItem
                        [ position relative
                        , padding4 (em 0.25) (em 4) (em 0.25) (em 4)
                        , before
                            [ backgroundColor (rgba 0 0 0 0.2)
                            , left zero
                            , top (pct 50)
                            , display block
                            , width (em 3)
                            , height (em 0.2)
                            , position absolute
                            ]
                        , hover
                            [ transform (scale 1.8)
                            , before
                                [ backgroundColor (rgba 0 0 0 0.5) ]
                            , adjacentSiblings
                                [ (.) TimelineItem
                                    [ transform (scale 1.4) ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


port files : CssFileStructure -> Cmd msg


cssFiles : CssFileStructure
cssFiles =
    toFileStructure
        [ ( "dist/main.css"
          , Css.File.compile
                [ shared
                  -- , HavingFunCoding.css
                ]
          )
        ]


main : Program Never () msg
main =
    Platform.program
        { init = ( (), files cssFiles )
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        }
