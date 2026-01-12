module Boids exposing (..)

import Browser
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Line exposing (lineWidth)
import Color
import Random
import Html exposing (Html)



-- MODEL --



type alias Model =
    {}


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )

-- VIEW --


view : Model -> Html msg
view model =
    Canvas.toHtml ( 400, 400 ) [] []


-- UPDATE --

type Msg = Something


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    (model, Cmd.none)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
