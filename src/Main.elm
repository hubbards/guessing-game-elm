module Main exposing (main)

{-| This is a web app for playing a guessing game. It is also an example of
using the Elm architecture to implement a web app. -}

import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Random

import Tree

main : Program Never Model Msg
main =
  Html.program
  { init = init
  , update = update
  , subscriptions = subscriptions
  , view = view }

-- Model

{-| This type represents the state of the guessing game. The state of the game
consists of a decision tree for the computer to guess the users number and a
list of numbers that the user can choose from. Note that the computer is more
efficient at guessing if the tree is balanced.

In general, this type represents the state of the app. -}
type alias Model =
  { guesses: Tree.Tree Int
  , choices: List Int }

-- Init

{-| The empty tree and list along with a command to play the game with a new
list of choices.

In general, this value represents the initial state and an initial commands to
run. -}
init : (Model, Cmd Msg)
init =
  (Model Tree.Empty [], play)

{-| A command to guess numbers from a new list of choices. -}
play : Cmd Msg
play =
  let
    minimum = 1
    maximum = 99
    total = 10
  in
    Random.generate Play <| Random.list total (Random.int minimum maximum)

-- Update

{-| This data type represents messages for playing the guessing game.

In general, this type represents messages which are passed from the UI or
commands for updating the state of the app. -}
type Msg =
    NewGame
  | Play (List Int)
  | Correct
  | Lower
  | Higher

{-| This function starts a new game or updates the decision tree based on the
user's answer. When a new game is started, a command is run to guess numbers
from a new list of choices.

In general, this function updates the state of the app and runs commands.
Whenever a message is passed, this function is applied to the message and the
current state of the app. The Elm runtime updates the state of the app with the
result state and it executes the result command. If the command produces a
message, then the message is passed (and the update function is applied to the
message and current state of the app). -}
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NewGame -> (model, play)
    Play ls ->
      let
        t = Tree.fromList ls
      in
        (Model t <| Tree.inOrder t, Cmd.none)
    Correct -> ({ model | guesses = Tree.Empty }, Cmd.none)
    Lower   ->
      case model.guesses of
        Tree.Node _ l _ -> ({ model | guesses = l }, Cmd.none)
        _               -> (model, Cmd.none)
    Higher  ->
      case model.guesses of
        Tree.Node _ _ r -> ({ model | guesses = r }, Cmd.none)
        _               -> (model, Cmd.none)

-- Subscriptions

{-| TODO document

In general, this function describes which event sources to subscribe to for a
given state. -}
subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

-- View

{-| The view for this app consists of a welcome message, instructions for
playing the guessing game, and controls.

In general, this function describes how to render the app for a given state. -}
view : Model -> Html.Html Msg
view model =
  Html.div
  [ Attributes.style [ ("font-family", "Garamond, serif")
                     , ("font-size", "12pt")
                     , ("text-align", "justify")
                     , ("width", "500px")
                     , ("margin-left", "auto")
                     , ("margin-right", "auto") ] ]
  [ Html.h1 [] [ Html.text "Guessing Game Web Application" ]
  , Html.p
    []
    [ Html.text
        """
          Welcome to the guessing game web application! The guessing game is
          played between a user and the computer. The user chooses a number
          from a list of numbers and the computer tries to guess the users
          number. To play the game, please follow these instructions:
        """ ]
  , Html.ol
    []
    [ Html.li [] [ Html.text <| "Choose an integer from the list: "
                 , Html.pre
                   []
                   [ Html.code
                     []
                     [ Html.text <| toString model.choices ] ] ]
    , Html.li [] [ Html.text "The computer will guess your number. Answer if the guess is correct." ]
    , Html.li [] [ Html.text "Repeat the previous step until the computer guesses correctly." ] ]
  , Html.button [ Events.onClick NewGame ] [ Html.text "New Game" ]
  , game model ]

{-| Helper function for rendering the app. -}
game : Model -> Html.Html Msg
game model =
  case model.guesses of
    Tree.Empty                        ->
      Html.p [] [ Html.text "Good game!" ]
    Tree.Node n Tree.Empty Tree.Empty ->
      Html.p [] [ Html.text <| "Your number is " ++ toString n ]
    Tree.Node n _ _                   ->
      Html.p [] [ Html.text <| "Is your number " ++ toString n ++ "?"
                , control Correct "Correct"
                , control Lower "Lower"
                , control Higher "Higher" ]

{-| Helper function for making a game control button. -}
control : Msg -> String -> Html.Html Msg
control msg text =
  Html.button
  [ Attributes.style [("margin-left", "10px")], Events.onClick msg ]
  [ Html.text text ]
