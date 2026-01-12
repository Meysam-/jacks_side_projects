module Main exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Phrase =
    Array Bool


type alias Model =
    { right : Phrase, left : Phrase, kick : Phrase, hat : Phrase }


type Limb
    = Right
    | Left
    | Kick
    | Hat


type Msg
    = Toggle Int Limb


initialModel : Model
initialModel =
    { right = Array.repeat 4 False
    , left = Array.repeat 4 False
    , kick = Array.repeat 4 False
    , hat = Array.repeat 4 False
    }

makeGrid : Phrase -> Limb -> List (Html Msg)
makeGrid line limb =
    Array.toIndexedList line
        |> List.map
            (\( idx, val ) ->
                button [ onClick (Toggle idx limb) ]
                    [ text <|
                        if val then
                            "o"

                        else
                            "."
                    ]
            )


view : Model -> Html Msg
view model =
    div []
        [ div [ class "container" ]
            [ div [ class "row" ] <| makeGrid model.right Right
            , div [ class "row" ] <| makeGrid model.left Left
            , div [ class "row" ] <| makeGrid model.kick Kick
            , div [ class "row" ] <| makeGrid model.hat Hat
            ]
        ]


updateLimb : Phrase -> Int -> Phrase
updateLimb phrase idx =
    case Array.get idx phrase of
        Just val ->
            Array.set idx (not val) phrase

        Nothing ->
            phrase


updateModel : Int -> Limb -> Model -> Model
updateModel idx limb model =
    case limb of
        Right ->
            { model | right = updateLimb model.right idx }

        Left ->
            { model | left = updateLimb model.left idx }

        Kick ->
            { model | kick = updateLimb model.kick idx }

        Hat ->
            { model | hat = updateLimb model.hat idx }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Toggle idx limb ->
            ( updateModel idx limb model, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
