module TreeTests exposing (..)

{-| TODO document -}

import Test exposing (..)
import Expect

import Tree

-- TODO add more tests

depth : Test
depth =
  describe "Tree.depth"
    [ test "= 0 for empty tree" <| \_ -> Tree.depth Tree.Empty |> Expect.equal 0
    , test "= 1 for leaf" <| \_ -> Tree.depth (Tree.leaf 'a') |> Expect.equal 1
    , test "= 2 for example tree #1" <| \_ -> Tree.depth example1 |> Expect.equal 2
    , test "= 3 for example tree #2" <| \_ -> Tree.depth example2 |> Expect.equal 3
    , test "= 3 for example tree #3" <| \_ -> Tree.depth example3 |> Expect.equal 3 ]

-- Examples

example1 : Tree.Tree Char
example1 =
  Tree.Node 'a' (Tree.leaf 'b') (Tree.leaf 'c')

example2 : Tree.Tree Char
example2 =
  Tree.Node 'a' (Tree.Node 'b' (Tree.leaf 'c') (Tree.leaf 'd')) (Tree.leaf 'e')

example3 : Tree.Tree Char
example3 =
  Tree.Node 'a' (Tree.leaf 'b') (Tree.Node 'c' (Tree.leaf 'd') (Tree.leaf 'e'))

example4 : Tree.Tree Char
example4 =
  Tree.Node 'a' (Tree.Node 'b' Tree.Empty (Tree.leaf 'c')) (Tree.leaf 'd')

example5 : Tree.Tree Char
example5 =
  Tree.Node 'a' (Tree.leaf 'b') (Tree.Node 'c' (Tree.leaf 'd') Tree.Empty)
