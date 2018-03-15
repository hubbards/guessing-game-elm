module Tree exposing (..)

{-| This is a module for a binary tree data structure. Binary trees are common
data structures for learning about functional programming. This module is meant
to demonstrate functional programming in Elm. -}

{-| Data type for binary tree. -}
type Tree a =
    Empty
  | Node a (Tree a) (Tree a)

{-| Smart constructor for leaf nodes. -}
leaf : a -> Tree a
leaf x =
  Node x Empty Empty

{-| Right fold operation for binary tree. -}
foldr : (a -> b -> b) -> b -> Tree a -> b
foldr f y tree =
  case tree of
    Empty      -> y
    Node x l r -> f x <| foldr f (foldr f y l) r

{-| Alternative fold operation for binary tree. -}
tfold : (a -> b -> b -> b) -> b -> Tree a -> b
tfold f y tree =
  case tree of
    Empty      -> y
    Node x l r -> f x (tfold f y l) (tfold f y r)

{-| Map operation for binary tree. -}
-- TODO rewrite in terms of `foldr`
map : (a -> b) -> Tree a -> Tree b
map f tree =
  case tree of
    Empty      -> Empty
    Node x l r -> Node (f x) (map f l) (map f r)

{-| Data type for context in a zipper. -}
type Context a =
    Hole
  | Left a (Context a) (Tree a)
  | Right a (Tree a) (Context a)

{-| Data type for tree zipper. -}
type alias Zipper a = (Tree a, Context a)

{-| Enter a zipper. -}
enter : Tree a -> Zipper a
enter tree =
  (tree, Hole)

{-| Exit a zipper. -}
exit : Zipper a -> Tree a
exit zipper =
  case zipper of
    (t, Hole)        -> t
    (t, Left x c r)  -> exit (Node x t r, c)
    (t, Right x l c) -> exit (Node x l t, c)

{-| Focus on the left child. -}
left : Zipper a -> Maybe (Zipper a)
left zipper =
  case zipper of
    (Node x l r, c) -> Just (l, Left x c r)
    (Empty, _)      -> Nothing

{-| Focus on the right child. -}
right : Zipper a -> Maybe (Zipper a)
right zipper =
  case zipper of
    (Node x l r, c) -> Just (r, Right x l c)
    (Empty, _)      -> Nothing

{-| Computes the depth of a given binary tree. -}
-- TODO rewrite in terms of `foldr`
depth : Tree a -> Int
depth tree =
  case tree of
    Empty      -> 0
    Node x l r -> 1 + max (depth l) (depth r)

{-| Pre-order traversal of binary tree. Note that we could also define the
pre-order traversal using `foldr` as follows: `preOrder = foldr (::) []`. -}
preOrder : Tree a -> List a
preOrder tree =
  case tree of
    Empty      -> []
    Node x l r -> x :: preOrder l ++ preOrder r

{-| Post-order traversal of binary tree. -}
postOrder : Tree a -> List a
postOrder tree =
  case tree of
    Empty      -> []
    Node x l r -> postOrder l ++ postOrder r ++ [x]

{-| In-order traversal of binary tree. -}
inOrder : Tree a -> List a
inOrder tree =
  case tree of
    Empty      -> []
    Node x l r -> inOrder l ++ x :: inOrder r

-- TODO implement level-order traversal of binary tree
--levelOrder : Tree a -> List a
--levelOrder = undefined

{-| Finds the maximum value in a given binary tree. -}
findMax : Tree comparable -> Maybe comparable
findMax tree =
  case tree of
    Empty      -> Nothing
    Node x l r -> helper max x (findMax l) (findMax r)

{-| Finds the minimum value in a given binary tree. -}
findMin : Tree comparable -> Maybe comparable
findMin tree =
  case tree of
    Empty      -> Nothing
    Node x l r -> helper min x (findMin l) (findMin r)

-- Helper function.
helper : (a -> a -> a) -> a -> Maybe a -> Maybe a -> Maybe a
helper f x my mz =
  case (my, mz) of
    (Nothing, Nothing) -> Just x
    (Nothing, Just z)  -> Just (f x z)
    (Just y, Nothing)  -> Just (f x y)
    (Just y, Just z)   -> Just (f x <| f y z)

{-| Checks if a given binary tree is a binary search tree. -}
isBst : Tree comparable -> Bool
isBst tree =
  case tree of
    Empty      -> True
    Node x l r ->
      let
        f = Maybe.withDefault True
        p = f <| Maybe.map ((>=) x) (findMax l)
        q = f <| Maybe.map ((<=) x) (findMax r)
      in
        isBst l && isBst r && p && q

{-| Checks if a given value is an element of a given binary search tree. -}
isElement : comparable -> Tree comparable -> Bool
isElement x tree =
  case tree of
    Empty      -> False
    Node y l r -> x == y || if y < x then isElement x r else isElement x l

{-| Inserts a given value into a given binary search tree. -}
-- TODO rebalance tree
insert : comparable -> Tree comparable -> Tree comparable
insert x tree =
  case tree of
    Empty      -> leaf x
    Node y l r -> if y < x then Node y l (insert x r) else Node y (insert x l) r

{-| Inserts all values in a given list into a binary search tree. -}
fromList : List comparable -> Tree comparable
fromList =
  List.foldr insert Empty
