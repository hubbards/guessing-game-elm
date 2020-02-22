module TreeTest exposing (suite)

{-| TODO document
-}

import Expect
import Test
import Tree


{-| Unit test suite for Tree module.
-}
suite : Test.Test
suite =
    Test.describe "Tree" [ depth ]



-- TODO add more tests


depth : Test.Test
depth =
    Test.describe "depth"
        [ Test.test "depth Empty" <|
            \_ -> Expect.equal 0 <| Tree.depth Tree.Empty
        , Test.test "depth (leaf 1)" <|
            \_ -> Expect.equal 1 <| Tree.depth (Tree.leaf 1)
        , Test.test "depth example1" <|
            \_ -> Expect.equal 2 <| Tree.depth example1
        , Test.test "depth example2" <|
            \_ -> Expect.equal 3 <| Tree.depth example2
        , Test.test "depth example3" <|
            \_ -> Expect.equal 3 <| Tree.depth example3
        ]



-- Examples


example1 : Tree.Tree Int
example1 =
    Tree.Node 1
        (Tree.leaf 2)
        (Tree.leaf 3)


example2 : Tree.Tree Int
example2 =
    Tree.Node 1
        (Tree.Node 2 (Tree.leaf 3) (Tree.leaf 4))
        (Tree.leaf 5)


example3 : Tree.Tree Int
example3 =
    Tree.Node 1
        (Tree.leaf 2)
        (Tree.Node 3 (Tree.leaf 4) (Tree.leaf 5))


example4 : Tree.Tree Int
example4 =
    Tree.Node 1
        (Tree.Node 2 Tree.Empty (Tree.leaf 3))
        (Tree.leaf 4)


example5 : Tree.Tree Int
example5 =
    Tree.Node 1
        (Tree.leaf 2)
        (Tree.Node 3 (Tree.leaf 4) Tree.Empty)
