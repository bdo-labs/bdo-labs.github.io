module Post.IntroducingLabs exposing (post, css)

import Author


--

import Html exposing (div)
import Html.Attributes exposing (class)
import Markdown
import Css exposing (..)
import Css.Elements as Tag
import Css.Namespace exposing (namespace)


ns =
    "introducingLabs"


type CssClasses
    = Funny


css =
    (stylesheet << namespace ns)
        [ (.) Funny
            [ margin zero
            , padding zero
            ]
        ]


intro =
    Markdown.toHtml [] """

# Introducing Labs

I guess this would be our initial post?

"""


content =
    div [ class ns ] [ intro ]


post =
    { title = "Introducing Labs"
    , content = content
    , draft = True
    , author = Author.henrik
    }
