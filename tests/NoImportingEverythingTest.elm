module NoImportingEverythingTest exposing (all)

import NoImportingEverything exposing (rule)
import Review.Test
import Test exposing (..)


details : List String
details =
    [ "Type annotations help you understand what happens in the code, and it will help the compiler give better error messages."
    ]


all : Test
all =
    describe "NoImportingEverything"
        [ test "should not report imports without exposing clause" <|
            \_ ->
                """module A exposing (thing)
import A
import A as B
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectNoErrors
        , test "should not report imports that expose some elements" <|
            \_ ->
                """module A exposing (thing)
import A exposing (B, c)
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectNoErrors
        , test "should not report imports that expose all constructors of a type" <|
            \_ ->
                """module A exposing (thing)
import A exposing (B(..))
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectNoErrors
        , test "should report imports that expose everything" <|
            \_ ->
                """module A exposing (thing)
import A exposing (..)
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "TODO"
                            , details = [ "TODO" ]
                            , under = "(..)"
                            }
                        ]
        ]
