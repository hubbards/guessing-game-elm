# guessing-game-elm

Guessing game web app in [Elm][elm]

## Instructions

We will assume this project exists locally and we are logged into a shell where
the root of the project is the working directory.

We will also assume [Elm][elm] version 0.19.1 is installed.

### View Web App

View the web app by completing the following steps
1. run the Elm reactor and
2. navigate to the web app in a web browser.

We can run the Elm reactor with the `elm reactor` command.

### Play Game

The guessing game is played between a user and the computer. The user chooses a
number from a list of numbers and the computer tries to guess the users number.

When the computer makes a guess, click on the "lower", "higher", or "correct"
buttons.

A new game can be started by clicking on the "new game" button.

### Test

We will assume [Node.js][node] and [elm-test][test] are installed. Run the tests
with `elm-test` command.

[elm]: https://elm-lang.org
[format]: https://github.com/avh4/elm-format

[node]: https://nodejs.org
[test]: https://www.npmjs.com/package/elm-test
