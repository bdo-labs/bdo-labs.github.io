module Posts exposing (..)

import Author exposing (..)
import Post.HavingFunCoding as HavingFunCoding
import Post.IntroducingLabs as IntroducingLabs
import List.Zipper exposing (Zipper)
import Maybe


--

import Html exposing (Html, div, text)


notFound : Post
notFound =
    { title = "Not Found"
    , content = div [] [ text "The post you are looking for is not here" ]
    , draft = False
    , author = foo
    }


type alias Model =
    { posts : Zipper Post
    }


model =
    { posts =
        List.Zipper.withDefault
            notFound
            (List.Zipper.fromList
                [ HavingFunCoding.post
                , IntroducingLabs.post
                ]
            )
    }


type alias Post =
    { title : String
    , content : Html Msg
    , draft : Bool
    , author : Author
    }


type Msg
    = NextPost
    | PreviousPost


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



--         GotoPost title ->
--             let
--                 post =
--                     List.head (List.filter (\p -> p.title == title) model.posts)
--                         |> Maybe.withDefault notFound
--             in
--                 { model | post = post }
