module Post.HavingFunCoding exposing (post, css)

import Author


--

import Html exposing (div)
import Html.Attributes exposing (class)
import Markdown
import Css exposing (..)
import Css.Elements as Tag
import Css.Namespace exposing (namespace)


ns =
    "havingFunCoding"


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

# Having fun coding

For some time now, I've struggled to see the fun in coding; not the exercise
itself, but all the nonsense I have to deal with. In particular JavaScript,
Angular.js and old browsers. I've had it, so it's time to make some radical
changes.  I've set out to find a better alternative for writing engaging UI's
and I believe I've actually stumbled onto a few.

First, before mentioning any cool tech, I would like to say a few words about
my gripes with our current stack, as the issues might not be too much of a
problem for you.

So, OK. JavaScript.  It's a ecosystem that is ever expanding and really
thriving these days, but in my opinion the ecosystem has not yet grown up. What
I mean about that, is that the packages you find out there on the interwebs
often does not follow any version-strategy and you can end up breaking your own
solutions by doing a clean install, even though you've pinned all dependencies.

Works! Yay!

"""


content =
    div [ class ns ] [ intro ]


post =
    { title = "Having Fun Coding"
    , content = content
    , draft = True
    , author = Author.henrik
    }
