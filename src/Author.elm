module Author exposing (Author, foo, henrik)


type alias Author =
    { firstname : String
    , lastname : String
    , email : String
    , bio : Maybe String
    , twitter : Maybe String
    , github : Maybe String
    }


foo : Author
foo =
    { firstname = "foo"
    , lastname = "bar"
    , email = "report@labs.bdo.no"
    , bio = Nothing
    , twitter = Nothing
    , github = Nothing
    }


henrik : Author
henrik =
    { firstname = "Henrik"
    , lastname = "Kjerringvåg"
    , email = "hekj@bdo.no"
    , bio = Nothing
    , twitter = Just "hkjels"
    , github = Just "hkjels"
    }


andreas : Author
andreas =
    { firstname = "Andreas"
    , lastname = "Rein"
    , email = "andreas.rein@bdo.no"
    , bio = Nothing
    , twitter = Nothing
    , github = Nothing
    }
