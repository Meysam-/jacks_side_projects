module Main exposing (..)

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (align)
import Html.Events exposing (onClick)
import Random


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \m -> Sub.none
        , view = view
        }



-- Model


words : Array String
words =
    Array.fromList [ "obedient", "marble", "scare", "wail", "weary", "temprary", "sour", "relation", "dispensable", "badge", "pleasure", "deeply", "chin", "dashing", "slow", "occur", "dime", "wandering", "carpenter", "alike", "measly", "welcome", "receipt", "guilteless" ]


randomIdx =
    Random.generate WordIdx (Random.int 0 (Array.length words))


type State
    = Loading
    | Playing Model


type alias Model =
    { word : String
    , guesses : List String
    }


init : () -> ( State, Cmd Msg )
init _ =
    ( Loading
    , randomIdx
    )



-- Update


type Msg
    = Guess String
    | WordIdx Int
    | Reset


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case state of
        Playing model ->
            case msg of
                Guess c ->
                    if List.member c model.guesses then
                        ( Playing model, Cmd.none )

                    else
                        ( Playing { model | guesses = List.append model.guesses [ c ] }
                        , Cmd.none
                        )

                Reset ->
                    ( Loading, randomIdx )

                WordIdx _ ->
                    ( state, Cmd.none )

        Loading ->
            case msg of
                WordIdx idx ->
                    case Array.get idx words of
                        Just word ->
                            ( Playing
                                { word = word
                                , guesses = []
                                }
                            , Cmd.none
                            )

                        Nothing ->
                            ( Loading, Cmd.none )

                _ ->
                    ( Loading, Cmd.none )



-- View


charRange from to =
    List.map String.fromChar <| List.map Char.fromCode <| List.range (Char.toCode from) (Char.toCode to)


loadingView =
    div [] [ text "loading!" ]


playingView : Model -> Html Msg
playingView model =
    div [ align "center" ]
        (if String.split "" model.word |> List.all (\s -> List.member s model.guesses) then
            [ div [] [ text "You've successfully guessed the word!", button [ onClick Reset ] [ text "reset" ] ] ]

         else
            [ model.word
                |> String.split ""
                |> List.map
                    (\c ->
                        if List.member c model.guesses then
                            text (c ++ " ")

                        else
                            text "_ "
                    )
                |> div []
            , br [] []
            , charRange 'a' 'z' |> List.map (\c -> button [ onClick (Guess c) ] [ text c ]) |> div []
            ]
        )


view : State -> Html Msg
view state =
    case state of
        Loading ->
            loadingView

        Playing model ->
            playingView model
