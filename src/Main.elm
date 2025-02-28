module Main exposing (main)

import Browser
import Dict
import Ports exposing (..)
import Time
import Types exposing (..)
import Update exposing (update)
import View exposing (view)


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { wallet = Nothing
      , status = Nothing
      , err = Nothing
      , nftId = Nothing
      , isMobile = flags.screen.width < 1024 --|| flags.screen.height < 632
      , screen = flags.screen
      , demoAddress = []
      , keys = []
      , vanity = []
      , idInput = ""
      , startInput = ""
      , endInput = ""
      , containInput = ""
      , idCheck = Nothing
      , idInProg = 0
      , idWaiting = False
      , view = ViewHome
      , mintSig = Nothing
      , walletInUse = False
      , count = 0
      , grinding = False
      , availability = Dict.empty
      , rpc = flags.rpc
      , message = Nothing
      , match = MatchStart
      , startTime = 0

      --, now = Time.millisToPosix 0
      , now = 0
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.walletCb WalletCb
        , Ports.disconnect (always Disconnect)
        , Ports.availabilityCb AvailCb
        , Ports.nftCb NftCb
        , Ports.addrCb AddrCb
        , Ports.idExists IdCheckCb
        , Ports.mintCb MintCb
        , Ports.grindCb GrindCb
        , Ports.vanityCb VanityCb
        , Ports.startTimeCb StartTimeCb
        , Ports.mintErr (always MintErr)
        , if model.grinding then
            Time.every 100 Tick

          else
            Sub.none
        ]
