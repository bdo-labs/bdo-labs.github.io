module Author exposing (Author, foo, henrik, andreas, mats)


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
    , email = "hkjels@me.com"
    , bio = Just "Design-Oriented Functional Programmer & Pentester"
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


mats : Author
mats =
    { firstname = "Mats"
    , lastname = "Braa"
    , email = "mab1@bdo.no"
    , bio = Just "Fullstack developer with interest in mobile development"
    , twitter = Nothing
    , github = Just "matsbraa"
    }
