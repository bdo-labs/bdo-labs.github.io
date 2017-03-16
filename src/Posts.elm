module Posts exposing (..)

import Author exposing (..)
import Post.WeChooseClojure as WeChooseClojure
import Post.GitWorkflow as GitWorkFlow
import List.Zipper exposing (Zipper)
import String exposing (startsWith)
import Maybe


--

import Html exposing (Html, div, text)


notFound : Post
notFound =
    { title = "Not Found"
    , content = div [] [ text "The post you are looking for is not here" ]
    , draft = False
    , date = "November 25, 2016"
    , author = foo
    }


type alias Model =
    { posts : Zipper Post
    , light : Bool
    }


model =
    { posts =
        List.Zipper.withDefault
            notFound
            (List.Zipper.fromList
                [ WeChooseClojure.post,
                  GitWorkFlow.post
                ]
            )
    , light = True
    }


type alias Post =
    { title : String
    , content : Html Msg
    , draft : Bool
    , date : String
    , author : Author
    }


type Msg
    = NextPost
    | PreviousPost
    | GotoPost Post
    | ToggleLight


update msg model =
    case msg of
        NextPost ->
            case (List.Zipper.next model.posts) of
                Just posts ->
                    { model | posts = posts }

                Nothing ->
                    { model | posts = List.Zipper.first model.posts }

        PreviousPost ->
            case (List.Zipper.previous model.posts) of
                Just posts ->
                    { model | posts = posts }

                Nothing ->
                    { model | posts = List.Zipper.last model.posts }

        GotoPost post ->
            case
                (List.Zipper.first model.posts
                    |> List.Zipper.find (\p -> p == post)
                )
            of
                Just posts ->
                    { model | posts = posts }

                Nothing ->
                    { model | posts = List.Zipper.first model.posts }

        ToggleLight ->
            { model | light = (not model.light) }



--         GotoPost title ->
--             let
--                 post =
--                     List.head (List.filter (\p -> p.title == title) model.posts)
--                         |> Maybe.withDefault notFound
--             in
--                 { model | post = post }
