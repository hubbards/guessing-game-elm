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
    Play ls -> let t = Tree.fromList ls in (Model t <| Tree.inOrder t, Cmd.none)
    Correct -> ({ model | guesses = Tree.Empty }, Cmd.none)
    Lower   ->
      case model.guesses of
        Tree.Node _ l _ -> ({ model | guesses = l }, Cmd.none)
        _               -> (model, Cmd.none)
    Higher  ->
      case model.guesses of
        Tree.Node _ _ r -> ({ model | guesses = r }, Cmd.none)
        _               -> (model, Cmd.none)

{-| A command to guess numbers from a new list of choices. -}
play : Cmd Msg
play =
  let
    min = 1
    max = 99
    num = 10
  in
    Random.generate Play <| Random.list num (Random.int min max)

-- Subscriptions

{-| Subscriptions for guessing game.

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
  let
    game =
      case model.guesses of
        Tree.Empty                        -> [ Html.text "Good game!" ]
        Tree.Node n Tree.Empty Tree.Empty ->
          [ Html.text <| "Your number is " ++ toString n ]
        Tree.Node n _ _                   ->
          [ Html.text <| "Is your number " ++ toString n ++ "?"
          , Html.button [ Events.onClick Correct ] [ Html.text "Correct" ]
          , Html.button [ Events.onClick Lower ] [ Html.text "Lower" ]
          , Html.button [ Events.onClick Higher ] [ Html.text "Higher" ] ]
  in
    Html.div
      []
      [ Html.p
          []
          [ Html.text "Choose a number from the following list:"
          , Html.br [] []
          , Html.text (toString model.choices) ]
      , Html.button
          [ Events.onClick NewGame ]
          [ Html.text "New Game" ]
      , Html.p [] game ]
