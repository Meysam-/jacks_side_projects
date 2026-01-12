module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Events exposing (onInput)
import Random

type GuessStatus =
    TooHigh
    | TooLow
    | Invalid
    | GameOver
    | GameStart

gameStatusString status =
    case status of
        TooHigh ->
            "Your guess was too high"
        TooLow ->
            "Your guess was too low"
        Invalid ->
            "That's not a number you silly billy"
        GameOver ->
            "You guessed right!"
        GameStart ->
            "Type your guess!"

type alias Model =
    { content: String
    , status: GuessStatus
    , numberToGuess: Int
    }

init :  () -> ( Model, Cmd Msg)
init _ =
    (
    { content = ""
    , status = GameStart
    , numberToGuess = 5
    }
    , Cmd.none
    )

main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \model -> Sub.none
        , view = view}

type Msg = 
    Change String
    | Guess
    | Reset
    | NewNumber Int

update msg model =
    case msg of
        Change newContent ->
            ({ model | content = newContent }
            , Cmd.none)
        Guess ->
            (
            case String.toInt model.content of
                Just number ->
                    if number == model.numberToGuess then
                        { model | status = GameOver}
                    else if number > model.numberToGuess then
                        { model | status = TooHigh }
                    else
                        { model | status = TooLow }
                Nothing ->
                        { model | status = Invalid }
            , Cmd.none
            )
        Reset ->
            (
                {model | status = GameStart, content = ""}
                , Random.generate NewNumber (Random.int 1 1000)
            )
        NewNumber num ->
            ( { model | numberToGuess = num }
            , Cmd.none
            )

view : Model -> Html Msg
view model =
    div [align "center"]
        [ div [] [text "Guessing Game!"]
        , div [] [text (gameStatusString model.status)]
        , input [placeholder "Type your guess", value model.content, onInput Change ] []
        , case model.status of
            GameOver -> button [onClick Reset] [text "Reset the game!"]
            _ -> button [onClick Guess] [text "Guess!"]
        ]

