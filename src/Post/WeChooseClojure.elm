module Post.WeChooseClojure exposing (post)

import Author


--

import Html exposing (div)
import Html.Attributes exposing (class)
import Markdown
import Css exposing (..)
import Css.Elements as Tag
import Css.Namespace exposing (namespace)


ns =
    "weChooseClojureScript"


intro =
    Markdown.toHtml [] """


# We Choose ClojureScript

For the past few months, I've been researching a bunch of languages and
ecosystems in search of a better way of writing UI's. I have finally
concluded.

The three alternatives I found interesting and to have virtues over plain
old JavaScript; are Eve, Elm and ClojureScript.

## Eve

Eve is a declarative language, with it's own editor and magical debugger.
When you write Eve-code, almost all of it is pure data. Reactions are triggered
by looking up tags you've specified in your blocks of data and returning a modified version of
that block. Editing Eve-code is done using markdown and code-fences. I must say, that this literate form
of writing code is something that really strikes a chord with me.
And finally, the debugger is pure magic and has to be experienced, just have a look at the video below.

So, this is just a long list of pro's, why should you bother reading on?
  Truth told, Eve might be my go-to language in 2022, but it's at it's infant-state where
things will change drastically and crucial pieces are missing to finalize simple puzzles.
You should however go [play.witheve.com](http://play.witheve.com) and see what the future holds though :)

<iframe width='930' height='523' src='https://www.youtube.com/embed/TWAMr72VaaU' frameborder='0' allowfullscreen></iframe>

## Elm

Elm is a strict, strong and algebraic typed language with built-in
time-traveling debugger.  In my opinion the really cool bit here is
algebraic types. Algebraic types means that you can compose your types.
That in turn means you have to be explicit about your whole program, which makes it really transparent.
Another beauty about sprinkling these types all over the place, is the fact that using `fuzzers`
and property-based testing becomes less tedious. Heck! You will find yourself
writing them for the fun of it. Elm is also more than a language, it's a framework
and a package-manager. The selling-point for having it's own package-manger is the fact that it
has enforced semantic versioning. So if you make a breaking change, it's
impossible to publish without updating the major-part of your version-number etc.
So Elm has a great story for versioning, a
great story for writing robust code and a great story for inspecting your code.
It all adds up to software that works!
Are there no downsides?
Well, in the case of Elm, it's strength is also it's weakness. Since you need
to model everything about your program up-front, it's cumbersome to make prototypes.
This strictness also makes interop way more difficult, so you'll have a hard time
taking advantage of the huge amount of open-source code in JavaScript-land.

*Sidenote: The blog your reading was written in Elm * 😄
*Go check it out if you'd like: [Github](http://github.com/bdo-labs/bdo-labs.github.io/)*

<iframe width='930' height='523' src='https://www.youtube.com/embed/oNogm31F2mo' frameborder='0' allowfullscreen></iframe>


## ClojureScript

ClojureScript is a modern lisp for the browser. It has gained quite some
traction and has a plethora of solid frameworks for composing UI's. I've looked at
`om.next` and `re-frame` for the most part. Their quite different from one another, but each
has their own set of qualities that are worth exploring. `Om.next` makes it
possible to offload most of the work of your back-end if you target Datomic,
by composing queries within your UI-components themselves.
When writing your view-code, you know exactly
what you need and when you query exactly what you need, no rubbish is
thrown over the wire.  So, if your starting an entirely fresh project and
are so fortunate that you can choose Datomic as your db, I'd go with
`om.next`.

Now, `Re-frame`! `Re-frame` is
a very easy to understand framework where you can do work against any
back-end with ease. It separates all heavy lifting into
subscriptions and handlers, where subscriptions simply react to changes
made to your application-state via handlers.  The entire framework is
just a couple of hundred lines of Clojure-code and the Readme/documentation
is really good, so getting started is a breeze.

So, for a quick summary of reasons why we choose ClojureScript. ClojureScript is really easy to prototype in, it has
opt-in robustness through specifications and property-based testing. It's got
the best story for interoparability with JavaScript of any functional language
I know of; and the community is really flourishing of great new ideas.
Yeah, I'm not sure what the downsides are, sorry!

<iframe width='930' height='523' src='https://www.youtube.com/embed/xz389Ek2eS8' frameborder='0' allowfullscreen></iframe>

"""


content =
    div [ class ns ]
        [ intro
        ]


post =
    { title = "We Choose ClojureScript"
    , content = content
    , draft = False
    , date = "Januar 17, 2017"
    , author = Author.henrik
    }
