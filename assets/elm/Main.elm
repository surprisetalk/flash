
module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Dict exposing (Dict)

import Char

import Json.Decode as JD
import Json.Encode as JE

import Http
import Keyboard
-- TODO: Consider changing to gizra/elm-keyboard-event

{-

Example cards:
- Add a paragraph onto this essay (with timer): ...
- Link to media from pocket.
- Japanese word.
- Write a letter to Stanley.
- Leg day! How much did you lift?
- How happy are you right now?

-}

-- type Card
--   = CardFact Fact
--     -- Remember it!
--   | CardPrompt Text Text
--     -- Write about it!
--   | CardTask Text Recurrence
--     -- Do it!
--   | CardEvent Text TimeRange
--     -- Go do this thing.
--   | CardStat Text Int
--     -- Rate a thing.

-- type alias Fact
--   = List Factoid

-- type alias Factoid
--   = Text

-- type MemoryLevel
--   = VeryEasy
--   | Easy
--   | Hard
--   | VeryHard

-- saveCard : Card -> Cmd Msg
-- 
-- editCard : Card -> Cmd Msg
-- 
-- fetchCards : Cmd Msg
-- 
-- skipCard : Card -> Cmd Msg
-- 
-- flipFact : Fact -> Cmd Msg
-- 
-- scoreFact : Fact -> MemoryLevel -> Cmd Msg
-- 
-- completeTask : Task -> Cmd Msg

-- viewFactoid factoid
--   = code []
--     [ pre []
--       [ text factoid
--       ]
--     ]
  
-- main { cards }
-- -- TODO: Pretty much all the controls should be keyboard-only.
-- -- TODO: Today's events.
--   = case cards of
-- 
--       [] -> text "no more cards"
-- 
--       card :: _ -> card |> toString |> text

-- MAIN -----------------------------------------------------------------------

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- HELPERS --------------------------------------------------------------------

(=>) = (,)

expectNothing = Http.expectStringResponse (\_ -> Ok ())

cycle items =
  case items of
      [] -> []
      item :: items -> items ++ [ item ]

uncycle = List.reverse >> cycle >> List.reverse

combineResult fx fe res =
  case res of
      Ok x -> fx x
      Err e -> fe e


-- MODEL ----------------------------------------------------------------------

type alias Model =
  { newTask          
  : { body     : String
    , priority : Float
    }
  , draw            : Cards
  , graveyard       : Cards
  , isCardFocused : Bool
  }

type alias CardId = Int

type alias Cards = List Card

type alias Card =
  { id    : CardId
  , sides : Sides
  , ctype : CardType
  }

type CardType
  = Fact
  | Task

toCardType ct =
  case ct of
      "FACT" -> JD.succeed Fact
      "TASK" -> JD.succeed Task
      ct_    -> JD.fail <| ct_ ++ " is not a valid card type."

type alias Sides = List Side

type alias Side = String

type alias Score = Float

bodyDecoder =
  JD.field "data"

cardsDecoder =
  JD.list cardDecoder

cardDecoder =
  JD.map3 Card
    (JD.field "id" JD.int)
    (JD.field "body" (JD.list JD.string))
    (JD.field "card_type" (JD.andThen toCardType JD.string))
              
encodeCard = JE.string


-- INIT -----------------------------------------------------------------------

init : (Model, Cmd Msg)
init =
  Model { body = "", priority = 0.5 } [] [] True ! [ Http.send LoadCards fetchCards ]

fetchCards =
  Http.get "/api/cards" (bodyDecoder cardsDecoder)


-- MSG ------------------------------------------------------------------------

type Msg
  = NoOp
  | Log String
  | LoadCards (Result Http.Error Cards)
  | FetchCards
  | NextCard
  | PrevCard
  | FlipCard
  | FlopCard
  | RateCard Score
  | SubmitNewTask
  | FocusCard
  | FocusNewTask
  | EditNewTaskBody String
  | EditNewTaskPriority Float


-- UPDATE ---------------------------------------------------------------------

update : Msg -> Model -> (Model, Cmd Msg)
update msg ({newTask,draw,graveyard} as model) =
  case msg of

    NoOp -> model ! []

    Log x -> let _ = Debug.log "LOG" x in model ! []

    FocusCard -> { model | isCardFocused = True } ! []

    FocusNewTask -> { model | isCardFocused = False } ! []

    FetchCards -> model ! [ Http.send LoadCards fetchCards ]

    LoadCards (Ok cards) -> { model | draw = cards, graveyard = [] } ! []

    LoadCards (Err err) -> let _ = Debug.log "ERROR" err in model ! []

    NextCard -> case draw of

                    [] -> model ! []

                    card :: cards -> { model | draw = cards, graveyard = card :: graveyard } ! []

    PrevCard -> case graveyard of

                    [] -> model ! []

                    card :: cards -> { model | draw = card :: draw, graveyard = cards } ! []

    FlipCard -> case draw of

                    [] -> model ! []

                    card :: cards -> { model | draw = { card | sides = cycle card.sides } :: cards } ! []

    FlopCard -> case draw of

                    [] -> model ! []

                    card :: cards -> { model | draw = { card | sides = uncycle card.sides } :: cards } ! []

    RateCard n -> case draw of

                      [] -> model ! []

                      {id,ctype} :: _ ->
                        
                        case ctype of

                          Task ->

                            model ! []

                          Fact ->

                            model ! [ Http.send
                                      (combineResult (always NextCard) (toString >> Log))
                                      <| Http.request
                                         { method = "PUT"
                                         , headers = []
                                         , url = "/api/facts/" ++ toString id
                                         , body = Http.jsonBody
                                               <| JE.object
                                                  [ "score" => JE.float n
                                                  ]
                                         , expect = expectNothing
                                         , timeout = Nothing
                                         , withCredentials = False
                                         }
                                    ]

    SubmitNewTask -> model !
                     [ Http.send
                         (combineResult (always (EditNewTaskBody "")) (toString >> Log))
                         <| Http.request
                            { method = "POST"
                            , headers = []
                            , url = "/api/tasks"
                            , body = Http.jsonBody (JE.object [ "task" => JE.object [ "body" => JE.string newTask.body, "priority" => JE.float newTask.priority ] ])
                            , expect = expectNothing
                            , timeout = Nothing
                            , withCredentials = False
                            }
                     ]

    EditNewTaskBody body -> { model | newTask = { newTask | body = body } } ! []

    EditNewTaskPriority priority -> { model | newTask = { newTask | priority = clamp 0 1 priority } } ! []


-- SUBSCRIPTIONS --------------------------------------------------------------

subscriptions : Model -> Sub Msg
subscriptions {newTask,isCardFocused} =
  Sub.batch
    [ let handleKeypress keyCode =
        case isCardFocused of
          False ->
            case Char.fromCode keyCode of
              'À'  -> FocusCard
               -- `
              _    -> NoOp
          True ->
            case Char.fromCode keyCode of
              'À'  -> FocusNewTask
               -- `
              '\r' -> SubmitNewTask
              -- 'J'  -> EditNewTaskPriority <| newTask.priority - 0.1
              -- 'K'  -> EditNewTaskPriority <| newTask.priority + 0.1
              'R'  -> FetchCards
              'L'  -> NextCard
              'H'  -> PrevCard
              'J'  -> FlopCard
              'K'  -> FlipCard
              ' '  -> FlipCard
              '%'  -> PrevCard
              -- Left arrow.
              '&'  -> FlipCard
              -- Up arrow.
              '('  -> FlopCard
              -- Down arrow.
              '\'' -> NextCard
              -- Also the right arrow.
              '0'  -> EditNewTaskPriority 0.0
              '1'  -> EditNewTaskPriority 0.1
              '2'  -> EditNewTaskPriority 0.2
              '3'  -> EditNewTaskPriority 0.3
              '4'  -> EditNewTaskPriority 0.4
              '5'  -> EditNewTaskPriority 0.5
              '6'  -> EditNewTaskPriority 0.6
              '7'  -> EditNewTaskPriority 0.7
              '8'  -> EditNewTaskPriority 0.8
              '9'  -> EditNewTaskPriority 0.9
              'B'  -> RateCard 0.0
              'M'  -> RateCard 0.25
              'W'  -> RateCard 0.5
              'V'  -> RateCard 0.75
              'Z'  -> RateCard 1.0
              -- _    -> NoOp
              c    -> Log <| toString c
      in Keyboard.downs handleKeypress
    ]


-- VIEW -----------------------------------------------------------------------

view : Model -> Html Msg
view ({newTask,draw,isCardFocused} as model) =

  main_ []
  [ div [ id "card"
        , onClick FocusCard
        , style <| if isCardFocused then [] else [ "background-color" => "#DDD" ]
        ]
      <| case draw of

           [] -> [ span [] [] ]
             
           {id,sides} :: _ ->

             case sides of

               [] ->

                 [ id |> toString |> text
                 ]

               front :: _ ->

                 [ h3 []
                   [ id |> toString |> text
                   ]
                 , p []
                   [ text front
                   ]
                 ]

  , div [ id "new-task"
        , onClick FocusNewTask
        , style <| if isCardFocused then [ "background-color" => "#DDD" ] else []
        ]
    [ h1 [] [ newTask.priority |> (*) 10 |> round |> toString |> text ]
    , textarea [ value newTask.body, onInput EditNewTaskBody ] []
    ]
  ]
