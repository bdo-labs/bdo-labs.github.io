module Post.IntroducingLabs exposing (post, css)

import Author


--

import Html exposing (div)
import Html.Attributes exposing (class)
import Markdown exposing (Options, defaultOptions)
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


options : Options
options =
    { defaultOptions | smartypants = True }


intro =
    Markdown.toHtmlWith options [] """

# Introducing Labs

I guess this would be our initial post?

```javascript
var foo = "bar";
```

"""


content =
    div [ class ns ] [ intro ]


post =
    { title = "Introducing Labs"
    , content = content
    , draft = True
    , author = Author.henrik
    }
