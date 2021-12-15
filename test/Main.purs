module Test.Main where

import Amazons
import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main =
  launchAff_
    $ runSpec [ consoleReporter ] do
        describe "purescript-spec" do
          describe "Tests" do
            it "ascii" do
              ascii amazons
                `shouldEqual`
                  ( "+---------------------+\n"
                      <> "| . . . b . . b . . . | 10\n"
                      <> "| . . . . . . . . . . | 9\n"
                      <> "| . . . . . . . . . . | 8\n"
                      <> "| b . . . . . . . . b | 7\n"
                      <> "| . . . . . . . . . . | 6\n"
                      <> "| . . . . . . . . . . | 5\n"
                      <> "| w . . . . . . . . w | 4\n"
                      <> "| . . . . . . . . . . | 3\n"
                      <> "| . . . . . . . . . . | 2\n"
                      <> "| . . . w . . w . . . | 1\n"
                      <> "+---------------------+\n"
                      <> "  a b c d e f g h i j"
                  )
            it "clear" do
              clear.history `shouldEqual` []
            it "amazons" do
              amazons.positions `shouldEqual` [ "3b2b3/10/10/b8b/10/10/w8w/10/10/3w2w3 w 1" ]
            it "fen" do
              fen amazons `shouldEqual` "3b2b3/10/10/b8b/10/10/w8w/10/10/3w2w3 w 1"
            it "ended" do
              ended amazons `shouldEqual` false
            it "get" do
              get amazons "d1" `shouldEqual` Just (Amazon White)
            it "getSqr" do
              getSqr amazons 9 3 `shouldEqual` Just (Amazon White)
            it "legalMoves" do
              ( legalMoves (load "w1x7/2x7/xxx7/10/10/10/10/10/10/10 w 1")
                  `shouldEqual`
                    [ "a10b10/a10"
                    , "a10b10/a9"
                    , "a10b10/b9"
                    , "a10a9/a10"
                    , "a10a9/b10"
                    , "a10a9/b9"
                    , "a10b9/a10"
                    , "a10b9/b10"
                    , "a10b9/a9"
                    ]
              )
            it "movesOfSqr" do
              ( movesOfSqr (load "w1x7/2x7/xxx7/10/10/10/10/10/10/10 w 1") 0 0
                  `shouldEqual`
                    [ "a10b10/a10"
                    , "a10b10/a9"
                    , "a10b10/b9"
                    , "a10a9/a10"
                    , "a10a9/b10"
                    , "a10a9/b9"
                    , "a10b9/a10"
                    , "a10b9/b10"
                    , "a10b9/a9"
                    ]
              )
            it "load" do
              load "3b2b3/10/10/b8b/10/10/w8w/10/10/3w2w3 w 1" `shouldEqual` amazons
            it "loadPgn" do
              (loadPgn "1. d1d2/d1 a7a6/a7").history `shouldEqual` [ "d1d2/d1", "a7a6/a7" ]
            it "move" do
              (move amazons "d1d2/d1").history `shouldEqual` [ "d1d2/d1" ]
            it "pgn" do
              pgn (move amazons "d1d2/d1") `shouldEqual` "1. d1d2/d1 "
            it "put" do
              ( fen (put amazons Fire "a10")
                  `shouldEqual`
                    "f2b2b3/10/10/b8b/10/10/w8w/10/10/3w2w3 w 1"
              )
            it "remove" do
              ( fen (remove amazons "d10")
                  `shouldEqual`
                    "6b3/10/10/b8b/10/10/w8w/10/10/3w2w3 w 1"
              )
            it "turn" do
              turn amazons `shouldEqual` White
            it "takeback" do
              (takeback $ move amazons "d1d2/d1").board `shouldEqual` amazons.board
            it "validFen" do
              validFen "3b2b3/10/10/b8b/10/10/w8w/10/10/3w2w3 w 1" `shouldEqual` true
            it "parse" do
              ( parse "3b2b3/10/10/b8b/10/10/w8w/10/10/3w2w3 w 1"
                  `shouldEqual`
                    "3b2b3/10/10/b8b/10/10/w8w/10/10/3w2w3 w 1"
              )
            it "moveNumber" do
              moveNumber amazons `shouldEqual` 1
