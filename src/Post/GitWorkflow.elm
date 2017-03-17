module Post.GitWorkflow exposing (post)

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
# Git workflows
Choosing a Git workflow can be a cumbersome task, as there’s no “one size fits all” solution.
It depends on your development routines and preferences, also your Git host provider may play a role.

There’s a plethora of options, I’m not going to go through them all but here’s a rundown of the most common ones:

## Centralized
One central repository(master) where everyone works on the same branch and pushes their changes into master.
## Feature branch
Encapsulates development in feature branches, allowing the team to leverage the power of pull requests.
This also leaves a master branch with a production ready version of the code.
## Gitflow
Defines a strict branching model designed around the project release. More complicated than the feature branch workflow,
but there’s a Git wrapper available that makes using this workflow a breeze.
## GitHub Flow
GitHub made their own workflow aptly named “GitHub Flow”. It’s lightweight, branch-based and great for projects with regular deployments.
## Forking
Every developer has a server-side repository forked (copied) from the official repository.
They then issue a pull request to the official repository where the project maintainer either accepts or rejects the request.

The guys over at Atlassian have a great article [comparing these workflows](https://www.atlassian.com/git/tutorials/comparing-workflows)

# Our workflow of choice

##GitHub Flow
![GitHub Flow](https://raw.githubusercontent.com/bdo-labs/bdo-labs.github.io/blog/architecture/dist/resources/digitalel%C3%B8sningerGitflow.gif)
[](https://guides.github.com/introduction/flow/)

We concluded that GitHub Flow was the best fit for our team.
The decision was based on multiple criteria’s including: ease of use, product release cycles, Git provider and a healthy amount of “gut-feeling”.
The GitHub Flow workflow is basically the same as the feature-branch workflow with some extra rules/guidelines in place. One of those rules are
that the feature-branch gets pushed to production before being merged into master. This preserves a production ready branch in case the feature-branch
code doesn’t behave as intended in the production environment. We also like to initiate the pull request as soon as possible,
as members of your team can comment and make suggestions along the development phase and not only as a review before completion.

I hope you found this post useful and don’t forget the ABC rule of Git: Always Be Committing!
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
