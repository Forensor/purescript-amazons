module Test.Main where

import Prelude
import Amazons

import Effect (Effect)
import Effect.Class.Console (log)
import Test.Assert (assertEqual', assertFalse', assertTrue')
import Data.Maybe (Maybe(..))

main :: Effect Unit
main = do
  has3fieldsTest
  rdIsDigTest
  ndIsTeamTest
  st10ranksTest
  stValChrsTest
  st10colsTest
  validFenTest
  parseTest
  fieldTest
  segSymbsTest
  fen2boardTest
  loadTest
  amazonsTest
  clearTest
  initFenTest
  asciiTest
  asciiTest'
  sqr2symbTest
  crd2indTest
  crd2indTest'
  ind2crdTest
  putTest
  putTest'
  moveTest
  removeTest
  pgnTest
  pgnTest'
  getTest
  getTest'
  getSqrTest
  getSqrTest'
  replaceTest
  takebackTest
  takebackTest'
  legalMovesTest
  movesOfSqrTest
  movesOfSqrTest'
  freeSqrTest
  freeSqrDirTest
  loadPgnTest'
  endedTest
  board2fenTest
  board2fenTest'
  rank2fenTest
  sqr2fenTest
  fen2boardTest'
  fen2rankTest
  symb2sqrTest
  segSymbsTest'
  colsTest
  symbValTest
  gBoardTest
  gFenTest
  gFenTest'
  gHistTest
  gTurnTest
  gTurnTest'
  gPosTest
  gMoveNTest
  gMoveNTest'
  log "ALL TEST PASSED!"

gMoveNTest' :: Effect Unit
gMoveNTest' = do
  assertEqual'
    "gMoveN' 1" 
    { actual: gMoveN' (Just "1")
    , expected: 1
    }
  log "gMoveN': PASSED [✔]"

gMoveNTest :: Effect Unit
gMoveNTest = do
  assertEqual'
    "gMoveN 1" 
    { actual: gMoveN amazons
    , expected: 1
    }
  log "gMoveN: PASSED [✔]"

gPosTest :: Effect Unit
gPosTest = do
  assertEqual'
    "gPos 1" 
    { actual: gPos amazons
    , expected: [initFen]
    }
  log "gPos: PASSED [✔]"

gTurnTest' :: Effect Unit
gTurnTest' = do
  assertEqual'
    "gTurn' 1" 
    { actual: gTurn' (Just "b")
    , expected: Black
    }
  log "gTurn': PASSED [✔]"

gTurnTest :: Effect Unit
gTurnTest = do
  assertEqual'
    "gTurn 1" 
    { actual: gTurn amazons
    , expected: White
    }
  log "gTurn: PASSED [✔]"

gHistTest :: Effect Unit
gHistTest = do
  assertEqual'
    "gHist 1" 
    { actual: gHist amazons
    , expected: []
    }
  log "gHist: PASSED [✔]"

gFenTest' :: Effect Unit
gFenTest' = do
  assertEqual'
    "gFen' 1" 
    { actual: gFen' (Just initFen)
    , expected: initFen
    }
  log "gFen': PASSED [✔]"

gFenTest :: Effect Unit
gFenTest = do
  assertEqual'
    "gFen 1" 
    { actual: gFen amazons
    , expected: initFen
    }
  log "gFen: PASSED [✔]"

gBoardTest :: Effect Unit
gBoardTest = do
  assertEqual'
    "gBoard 1" 
    { actual: gBoard amazons
    , expected: [ [Empty,Empty,Empty,Amazon Black,Empty,Empty,Amazon Black,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Amazon Black,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Amazon Black]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Amazon White,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Amazon White]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Amazon White,Empty,Empty,Amazon White,Empty,Empty,Empty]
                ]
    }
  log "gBoard: PASSED [✔]"

symbValTest :: Effect Unit
symbValTest = do
  assertEqual'
    "symbVal 1" 
    { actual: symbVal "x"
    , expected: 1
    }
  log "symbVal: PASSED [✔]"

colsTest :: Effect Unit
colsTest = do
  assertEqual'
    "cols 1" 
    { actual: cols "w8x"
    , expected: 10
    }
  log "cols: PASSED [✔]"

symb2sqrTest :: Effect Unit
symb2sqrTest = do
  assertEqual'
    "symb2sqr 1" 
    { actual: symb2sqr "w"
    , expected: [Amazon White]
    }
  log "symb2sqr: PASSED [✔]"

fen2rankTest :: Effect Unit
fen2rankTest = do
  assertEqual'
    "fen2rank 1" 
    { actual: fen2rank "10"
    , expected: [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
    }
  log "fen2rank: PASSED [✔]"

sqr2fenTest :: Effect Unit
sqr2fenTest = do
  assertEqual'
    "sqr2fen 1" 
    { actual: sqr2fen (Amazon White)
    , expected: "w"
    }
  log "sqr2fen: PASSED [✔]"

rank2fenTest :: Effect Unit
rank2fenTest = do
  assertEqual'
    "rank2fen 1" 
    { actual: rank2fen [Empty,Empty,Empty,Amazon Black,Empty,Empty,Amazon Black,Empty,Empty,Empty]
    , expected: ["1","1","1","b","1","1","b","1","1","1"]
    }
  log "rank2fen: PASSED [✔]"

board2fenTest' :: Effect Unit
board2fenTest' = do
  assertEqual'
    "board2fen' 1" 
    { actual: board2fen' "111b11b111/1111111111/1111111111/b11111111b/1111111111/1111111111/w11111111w/1111111111/1111111111/111w11w111"
    , expected: "3b2b3/10/10/b8b/10/10/w8w/10/10/3w2w3"
    }
  log "board2fen': PASSED [✔]"

board2fenTest :: Effect Unit
board2fenTest = do
  assertEqual'
    "board2fen 1" 
    { actual: board2fen $ gBoard amazons
    , expected: "3b2b3/10/10/b8b/10/10/w8w/10/10/3w2w3"
    }
  log "board2fen: PASSED [✔]"

endedTest :: Effect Unit
endedTest = do
  assertEqual'
    "ended 1" 
    { actual: ended amazons
    , expected: false
    }
  log "ended: PASSED [✔]"

loadPgnTest' :: Effect Unit
loadPgnTest' = do
  assertEqual'
    "loadPgn' 1" 
    { actual: gHist $ loadPgn' amazons ["d1d2/d1","a7a6/a7"]
    , expected: ["d1d2/d1","a7a6/a7"]
    }
  log "loadPgn': PASSED [✔]"

loadPgnTest :: Effect Unit
loadPgnTest = do
  assertEqual'
    "loadPgn 1" 
    { actual: gHist $ loadPgn "1. d1d2/d1 a7a6/a7"
    , expected: ["d1d2/d1","a7a6/a7"]
    }
  log "loadPgn: PASSED [✔]"

freeSqrDirTest :: Effect Unit
freeSqrDirTest = do
  assertEqual'
    "freeSqrDir 1" 
    { actual: freeSqrDir amazons [0,0] [1,1] [0,0]
    , expected: ["b9","c8","d7","e6","f5","g4","h3","i2","j1"]
    }
  log "freeSqrDir: PASSED [✔]"

freeSqrTest :: Effect Unit
freeSqrTest = do
  assertEqual'
    "freeSqr 1" 
    { actual: freeSqr amazons [0,0] [0,0]
    , expected: ["b10","c10","a9","a8","b9","c8","d7","e6","f5","g4","h3","i2","j1"]
    }
  log "freeSqr: PASSED [✔]"

movesOfSqrTest' :: Effect Unit
movesOfSqrTest' = do
  assertEqual'
    "movesOfSqr' 1" 
    { actual: movesOfSqr' ["d1d2", "d1d3"] [["d1","d3"],["d1","d2","c3"]]
    , expected: ["d1d2/d1","d1d2/d3","d1d3/d1","d1d3/d2","d1d3/c3"]
    }
  log "movesOfSqr': PASSED [✔]"

movesOfSqrTest :: Effect Unit
movesOfSqrTest = do
  assertEqual'
    "movesOfSqr 1" 
    { actual: movesOfSqr (load "w1x7/2x7/xxx7/10/10/10/10/10/10/10 w 1") 0 0
    , expected: [ "a10b10/a10"
                , "a10b10/a9"
                , "a10b10/b9"
                , "a10a9/a10"
                , "a10a9/b10"
                , "a10a9/b9"
                , "a10b9/a10"
                , "a10b9/b10"
                , "a10b9/a9"
                ]
    }
  log "movesOfSqr: PASSED [✔]"

legalMovesTest :: Effect Unit
legalMovesTest = do
  assertEqual'
    "legalMoves 1" 
    { actual: legalMoves (load "w1x7/2x7/xxx7/10/10/10/10/10/10/10 w 1")
    , expected: [ "a10b10/a10"
                , "a10b10/a9"
                , "a10b10/b9"
                , "a10a9/a10"
                , "a10a9/b10"
                , "a10a9/b9"
                , "a10b9/a10"
                , "a10b9/b10"
                , "a10b9/a9"
                ]
    }
  log "legalMoves: PASSED [✔]"

takebackTest' :: Effect Unit
takebackTest' = do
  assertEqual'
    "takeback' 1" 
    { actual: gBoard $ takeback' $ move amazons "d1d2/d1"
    , expected: gBoard amazons
    }
  log "takeback': PASSED [✔]"

takebackTest :: Effect Unit
takebackTest = do
  assertEqual'
    "takeback 1" 
    { actual: gBoard $ takeback $ move amazons "d1d2/d1"
    , expected: gBoard amazons
    }
  log "takeback: PASSED [✔]"

replaceTest :: Effect Unit
replaceTest = do
  assertEqual'
    "replace 1" 
    { actual: replace 0 Fire [Empty,Fire]
    , expected: [Fire,Fire]
    }
  log "replace: PASSED [✔]"

getSqrTest' :: Effect Unit
getSqrTest' = do
  assertEqual'
    "getSqr' 1" 
    { actual: getSqr' (Just ([Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty])) 0
    , expected: Just Empty
    }
  log "getSqr': PASSED [✔]"

getSqrTest :: Effect Unit
getSqrTest = do
  assertEqual'
    "getSqr 1" 
    { actual: getSqr amazons 0 0
    , expected: Just Empty
    }
  log "getSqr: PASSED [✔]"

getTest' :: Effect Unit
getTest' = do
  assertEqual'
    "get' 1" 
    { actual: get' amazons [Just 0, Just 0]
    , expected: Just Empty
    }
  assertEqual'
    "get' 2" 
    { actual: get' amazons [Just 50, Nothing]
    , expected: Nothing
    }
  log "get': PASSED [✔]"

getTest :: Effect Unit
getTest = do
  assertEqual'
    "get 1" 
    { actual: get amazons "a10"
    , expected: Just Empty
    }
  assertEqual'
    "get 2" 
    { actual: get amazons "what?"
    , expected: Nothing
    }
  log "get: PASSED [✔]"

pgnTest' :: Effect Unit
pgnTest' = do
  assertEqual'
    "pgn' 1" 
    { actual: pgn' ["d1d2/d1"] 1 true
    , expected: "1. d1d2/d1 "
    }
  log "pgn': PASSED [✔]"

pgnTest :: Effect Unit
pgnTest = do
  assertEqual'
    "pgn 1" 
    { actual: pgn $ move amazons "d1d2/d1"
    , expected: "1. d1d2/d1 "
    }
  log "pgn: PASSED [✔]"

removeTest :: Effect Unit
removeTest = do
  assertEqual'
    "remove 1" 
    { actual: gBoard $ remove amazons "d10"
    , expected: [ [Empty,Empty,Empty,Empty,Empty,Empty,Amazon Black,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Amazon Black,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Amazon Black]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Amazon White,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Amazon White]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Amazon White,Empty,Empty,Amazon White,Empty,Empty,Empty]
                ]
    }
  log "remove: PASSED [✔]"

moveTest :: Effect Unit
moveTest = do
  assertEqual'
    "move 1" 
    { actual: gHist $ move amazons "d1d2/d1"
    , expected: ["d1d2/d1"]
    }
  log "move: PASSED [✔]"

putTest' :: Effect Unit
putTest' = do
  assertEqual'
    "put' 1" 
    { actual: gBoard $ put' amazons Fire [Just 0, Just 0]
    , expected: [ [Fire,Empty,Empty,Amazon Black,Empty,Empty,Amazon Black,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Amazon Black,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Amazon Black]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Amazon White,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Amazon White]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Amazon White,Empty,Empty,Amazon White,Empty,Empty,Empty]
                ]
    }
  log "put': PASSED [✔]"

putTest :: Effect Unit
putTest = do
  assertEqual'
    "put 1" 
    { actual: gBoard $ put amazons Fire "a10"
    , expected: [ [Fire,Empty,Empty,Amazon Black,Empty,Empty,Amazon Black,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Amazon Black,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Amazon Black]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Amazon White,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Amazon White]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Amazon White,Empty,Empty,Amazon White,Empty,Empty,Empty]
                ]
    }
  log "put: PASSED [✔]"

ind2crdTest :: Effect Unit
ind2crdTest = do
  assertEqual'
    "ind2crd 1" 
    { actual: ind2crd 0 0
    , expected: Just "a10"
    }
  log "ind2crd: PASSED [✔]"

crd2indTest' :: Effect Unit
crd2indTest' = do
  assertEqual'
    "crd2ind' 1" 
    { actual: crd2ind' ["a", "10"]
    , expected: [Just 0, Just 0]
    }
  log "crd2ind': PASSED [✔]"

crd2indTest :: Effect Unit
crd2indTest = do
  assertEqual'
    "crd2ind 1" 
    { actual: crd2ind "a10"
    , expected: [Just 0, Just 0]
    }
  log "crd2ind: PASSED [✔]"

sqr2symbTest :: Effect Unit
sqr2symbTest = do
  assertEqual'
    "sqr2symb 1" 
    { actual: sqr2symb Fire
    , expected: "x"
    }
  log "sqr2symb: PASSED [✔]"

asciiTest' :: Effect Unit
asciiTest' = do
  assertEqual'
    "ascii' 1" 
    { actual: ascii' [Empty,Fire,Empty,Amazon White,Empty,Fire,Fire,Empty,Amazon Black,Fire] 1
    , expected: "| . x . w . x x . b x | 1\n"
    }
  log "ascii': PASSED [✔]"

asciiTest :: Effect Unit
asciiTest = do
  assertEqual'
    "ascii 1" 
    { actual: ascii amazons
    , expected: "+---------------------+\n"    <>
                "| . . . b . . b . . . | 10\n" <>
                "| . . . . . . . . . . | 9\n"  <>
                "| . . . . . . . . . . | 8\n"  <>
                "| b . . . . . . . . b | 7\n"  <>
                "| . . . . . . . . . . | 6\n"  <>
                "| . . . . . . . . . . | 5\n"  <>
                "| w . . . . . . . . w | 4\n"  <>
                "| . . . . . . . . . . | 3\n"  <>
                "| . . . . . . . . . . | 2\n"  <>
                "| . . . w . . w . . . | 1\n"  <>
                "+---------------------+\n"    <>
                "  a b c d e f g h i j"        
    }
  log "ascii: PASSED [✔]"

initFenTest :: Effect Unit
initFenTest = do
  assertTrue'
    "initFen 1" 
    $ validFen initFen
  log "initFen: PASSED [✔]"

clearTest :: Effect Unit
clearTest = do
  assertEqual'
    "clear 1" 
    { actual: gHist $ clear
    , expected: []
    }
  log "clear: PASSED [✔]"

amazonsTest :: Effect Unit
amazonsTest = do
  assertEqual'
    "amazons 1" 
    { actual: gFen $ amazons
    , expected: initFen
    }
  log "amazons: PASSED [✔]"

loadTest :: Effect Unit
loadTest = do
  assertEqual'
    "load 1" 
    { actual: gFen $ load initFen
    , expected: initFen
    }
  log "load: PASSED [✔]"

fen2boardTest :: Effect Unit
fen2boardTest = do
  assertEqual'
    "fen2board 1" 
    { actual: fen2board initFen
    , expected: [ [Empty,Empty,Empty,Amazon Black,Empty,Empty,Amazon Black,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Amazon Black,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Amazon Black]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Amazon White,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Amazon White]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Amazon White,Empty,Empty,Amazon White,Empty,Empty,Empty]
                ]
    }
  log "fen2board: PASSED [✔]"

fen2boardTest' :: Effect Unit
fen2boardTest' = do
  assertEqual'
    "fen2board' 1" 
    { actual: fen2board' (Just initFen)
    , expected: [ [Empty,Empty,Empty,Amazon Black,Empty,Empty,Amazon Black,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Amazon Black,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Amazon Black]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Amazon White,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Amazon White]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                , [Empty,Empty,Empty,Amazon White,Empty,Empty,Amazon White,Empty,Empty,Empty,Empty,Amazon White,Empty,Empty]
                ]
    }
  log "fen2board': PASSED [✔]"

segSymbsTest' :: Effect Unit
segSymbsTest' = do
  assertEqual'
    "segSymbs' 1" 
    { actual: segSymbs' ['3','b','2','b','3']
    , expected: ['3',',','b',',','2',',','b',',','3']
    }
  log "segSymbs': PASSED [✔]"

segSymbsTest :: Effect Unit
segSymbsTest = do
  assertEqual'
    "segSymbs 1" 
    { actual: segSymbs "3b2b3"
    , expected: ["3","b","2","b","3"]
    }
  assertEqual'
    "segSymbs 2" 
    { actual: segSymbs "3b10b3"
    , expected: ["3","b","10","b","3"]
    }
  log "segSymbs: PASSED [✔]"

fieldTest :: Effect Unit
fieldTest = do
  assertEqual'
    "field 1" 
    { actual: field 1 "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 w 1"
    , expected: (Just "w")
    }
  log "field: PASSED [✔]"

has3fieldsTest :: Effect Unit
has3fieldsTest = do
  assertTrue'
    "has3fields 1" 
    (has3fields "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 b 1")
  assertEqual'
    "has3fields 2" 
    { actual: has3fields "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 1"
    , expected: false
    }
  log "has3fields: PASSED [✔]"

rdIsDigTest :: Effect Unit
rdIsDigTest = do
  assertTrue'
    "rdIsDig 1"
    (rdIsDig "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 b 1")
  assertFalse'
    "rdIsDig 2"
    (rdIsDig "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 b z")
  log "rdIsDig: PASSED [✔]"

ndIsTeamTest :: Effect Unit
ndIsTeamTest = do
  assertTrue'
    "ndIsTeam 1"
    (ndIsTeam "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 b 1")
  assertFalse'
    "ndIsTeam 2"
    (ndIsTeam "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 z 1")
  log "ndIsTeam: PASSED [✔]"

st10ranksTest :: Effect Unit
st10ranksTest = do
  assertTrue'
    "st10ranks 1"
    (st10ranks "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 b 1")
  assertFalse'
    "st10ranks 2"
    (st10ranks "3w6/10/bx7b/10/10/w8w/10/10/6w3 b 1")
  log "st10ranks: PASSED [✔]"

stValChrsTest :: Effect Unit
stValChrsTest = do
  assertTrue'
    "stValChrs 1"
    (stValChrs "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 b 1")
  assertFalse'
    "stValChrs 2"
    (stValChrs "3w6/10/bx7b/1OTTER0/10/w8w/10/10/6w3 b 1")
  log "stValChrs: PASSED [✔]"

st10colsTest :: Effect Unit
st10colsTest = do
  assertTrue'
    "st10cols 1"
    (st10cols "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 b 1")
  assertFalse'
    "st10cols 2"
    (st10cols "3w6/10/bx7b/1OTT125ER0/10/w8w/10/10/6w3 b 1")
  log "st10cols: PASSED [✔]"

validFenTest :: Effect Unit
validFenTest = do
  assertTrue'
    "validFen 1"
    (validFen "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 b 1")
  assertFalse'
    "validFen 2"
    (validFen "3w6/10 /bx7b/1 OTTER 0/10/w8w/10/10/6w3 z 1")
  log "validFen: PASSED [✔]"

parseTest :: Effect Unit
parseTest = do
  assertEqual'
    "parse 1" 
    { actual: parse "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 b 1"
    , expected: "3b2b3/3w6/10/bx7b/10/10/w8w/10/10/6w3 b 1"
    }
  assertEqual'
    "parse 2" 
    { actual: parse "3b2b3/3w6/15/bx7b/10/10/w8w/10/10/6w3 b 1"
    , expected: initFen
    }
  log "parse: PASSED [✔]"
