module Amazons
  ( ascii
  , clear
  , amazons
  , fen
  , ended
  , get
  , getSqr
  , legalMoves
  , movesOfSqr
  , load
  , loadPgn
  , move
  , pgn
  , put
  , remove
  , turn
  , takeback
  , initFen
  , validFen
  , parse
  , moveNumber
  , Square(..)
  , Team(..)
  , Game
  , Board
  , San
  , Fen
  , Rank
  ) where

import Prelude
import Data.Array
  ( length
  , head
  , index
  , uncons
  , (:)
  , replicate
  , concatMap
  , last
  , findIndex
  , updateAt
  , zip
  , (..)
  , dropEnd
  , take
  , drop
  , concat
  , filter
  )
import Data.Foldable (all, elem, sum)
import Data.Traversable (sequence)
import Data.Int (fromString, toNumber)
import Data.Maybe (Maybe(..))
import Data.Number.Format (toString)
import Data.String (Pattern(..), joinWith, split, trim)
import Data.String.CodeUnits (fromCharArray, toCharArray, contains)
import Data.Tuple (Tuple(..))
import Data.Version.Internal (isDigit)

-----------------------------------------------------------------------------------------
-- Types & instances --------------------------------------------------------------------
-----------------------------------------------------------------------------------------
data Team
  = White
  | Black

data Square
  = Empty
  | Fire
  | Amazon Team

type Rank
  = Array Square

type Board
  = Array Rank

instance showSquare :: Show Square where
  show Empty = "Empty"
  show Fire = "Fire"
  show (Amazon White) = "Amazon White"
  show (Amazon Black) = "Amazon Black"

instance eqSquare :: Eq Square where
  eq Empty Empty = true
  eq Fire Fire = true
  eq (Amazon White) (Amazon White) = true
  eq (Amazon Black) (Amazon Black) = true
  eq _ _ = false

instance showTeam :: Show Team where
  show White = "White"
  show Black = "Black"

instance eqTeam :: Eq Team where
  eq White White = true
  eq Black Black = true
  eq _ _ = false

type San
  = String

type Fen
  = String

type Game
  = { board :: Board
    , history :: Array San
    , positions :: Array Fen
    }

-----------------------------------------------------------------------------------------
-- Values -------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
amazons :: Game
amazons = load initFen

clear :: Game
clear = load "10/10/10/10/10/10/10/10/10/10 w 1"

initFen :: Fen
initFen = "3b2b3/10/10/b8b/10/10/w8w/10/10/3w2w3 w 1"

ranks :: Array String
ranks = [ "10", "9", "8", "7", "6", "5", "4", "3", "2", "1" ]

columns :: Array String
columns = [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j" ]

-----------------------------------------------------------------------------------------
-- Ascii generation ---------------------------------------------------------------------
-----------------------------------------------------------------------------------------
ascii :: Game -> String
ascii g =
  "+---------------------+\n"
    <> joinWith "" (map rankBuilder (zip g.board (10 .. 1)))
    <> "+---------------------+\n"
    <> "  a b c d e f g h i j"

rankBuilder :: Tuple Rank Int -> String
rankBuilder (Tuple r n) = "| " <> joinWith "" (map sqr2symb r) <> "| " <> show n <> "\n"

sqr2symb :: Square -> String
sqr2symb (Amazon White) = "w "

sqr2symb (Amazon Black) = "b "

sqr2symb (Fire) = "x "

sqr2symb (Empty) = ". "

-----------------------------------------------------------------------------------------
-- Coord translation --------------------------------------------------------------------
-----------------------------------------------------------------------------------------
crd2ind :: San -> Maybe (Array Int)
crd2ind = crd2ind' <<< segSymbs

crd2ind' :: Array String -> Maybe (Array Int)
crd2ind' [ c, r ] =
  sequence
    [ findIndex (_ == r) ranks
    , findIndex (_ == c) columns
    ]

crd2ind' _ = Nothing

ind2crd :: Int -> Int -> Maybe San
ind2crd r c = index columns c <> index ranks r

-----------------------------------------------------------------------------------------
-- Interactions with pieces -------------------------------------------------------------
-----------------------------------------------------------------------------------------
put :: Game -> Square -> San -> Game
put g s c = put' g s $ crd2ind c

put' :: Game -> Square -> Maybe (Array Int) -> Game
put' g s (Just [ r, c ]) =
  g
    { board = newBoard
    , positions = dropEnd 1 g.positions <> [ newFen ]
    }
  where
  newBoard = replace2d r c s g.board

  newFen =
    board2fen newBoard
      <> " "
      <> field 1 (fen g)
      <> " "
      <> field 2 (fen g)

put' g _ _ = g

move :: Game -> San -> Game
move g san = case crd2ind orig of
  Just [ or, oc ] -> case san `elem` (movesOfSqr g or oc) of
    true -> case get g orig of
      Just piece ->
        { board: (put (remove (put g piece dest) orig) Fire fire).board
        , history: g.history <> [ san ]
        , positions:
            g.positions
              <> [ board2fen ((put (remove (put g piece dest) orig) Fire fire).board)
                    <> " "
                    <> ( if turn g == White then
                          "b"
                        else
                          "w"
                      )
                    <> " "
                    <> ( if turn g == White then
                          show (moveNumber g)
                        else
                          show ((moveNumber g) + 1)
                      )
                ]
        }
      Nothing -> g
    false -> g
  _ -> g
  where
  orig = joinWith "" (take 2 (segSymbs san))

  dest = joinWith "" (take 2 (drop 2 (segSymbs san)))

  fire = joinWith "" (take 2 (drop 5 (segSymbs san)))

remove :: Game -> San -> Game
remove g c = put g Empty c

get :: Game -> San -> Maybe Square
get g = get' g <<< crd2ind

get' :: Game -> Maybe (Array Int) -> Maybe Square
get' g (Just [ r, c ]) = getSqr g r c

get' _ _ = Nothing

getSqr :: Game -> Int -> Int -> Maybe Square
getSqr g r c = do
  row <- index g.board r
  sqr <- index row c
  pure sqr

takeback :: Game -> Game
takeback g
  | length g.positions >= 2 =
    takeback'
      ( { board: g.board
        , history: dropEnd 1 g.history
        , positions: dropEnd 1 g.positions
        }
      )
  | otherwise = g

takeback' :: Game -> Game
takeback' g =
  g
    { board = fen2board $ fen g
    }

ended :: Game -> Boolean
ended g = length (legalMoves g) == 0

-----------------------------------------------------------------------------------------
-- Valid movements generator ------------------------------------------------------------
-----------------------------------------------------------------------------------------
legalMoves :: Game -> Array San
legalMoves g = concatMap (\r -> concatMap (\c -> movesOfSqr g r c) (0 .. 9)) (0 .. 9)

movesOfSqr :: Game -> Int -> Int -> Array San
movesOfSqr g r c = case getSqr g r c of
  Just (Amazon t) -> case turn g == t of
    true -> case ind2crd r c of
      Just san -> movesOfSqr' (map (\d -> san <> d) pDests) fDests
      _ -> []
    false -> []
  _ -> []
  where
  pDests = freeSqr g [ r, c ] [ r, c ]

  fDests =
    map
      ( \dest -> case crd2ind dest of
          Just [ a, b ] -> freeSqr g [ a, b ] [ r, c ]
          _ -> []
      )
      pDests

movesOfSqr' :: Array San -> Array (Array San) -> Array San
movesOfSqr' ds fss = case uncons ds, uncons fss of
  Just { head: d, tail: t1 }, Just { head: fs, tail: t2 } ->
    map (\f -> d <> "/" <> f) fs
      <> movesOfSqr' t1 t2
  _, _ -> []

freeSqr :: Game -> Array Int -> Array Int -> Array San
freeSqr g [ r, c ] [ ri, ci ] = concatMap (\d -> freeSqrDir g [ r, c ] d [ ri, ci ]) dirs
  where
  dirs =
    [ [ (-1), (-1) ]
    , [ (-1), 0 ]
    , [ (-1), 1 ]
    , [ 0, (-1) ]
    , [ 0, 1 ]
    , [ 1, (-1) ]
    , [ 1, 0 ]
    , [ 1, 1 ]
    ]

freeSqr _ _ _ = []

freeSqrDir :: Game -> Array Int -> Array Int -> Array Int -> Array San
freeSqrDir g [ r, c ] [ rd, cd ] [ ri, ci ] = case direction == [ ri, ci ] of
  true -> case ind2crd ri ci of
    Just san -> san : freeSqrDir g direction [ rd, cd ] [ ri, ci ]
    Nothing -> []
  false -> case getSqr g (r + rd) (c + cd) of
    Just Empty -> case ind2crd (r + rd) (c + cd) of
      Just san -> san : freeSqrDir g direction [ rd, cd ] [ ri, ci ]
      Nothing -> []
    _ -> []
  where
  direction = [ r + rd, c + cd ]

freeSqrDir _ _ _ _ = []

-----------------------------------------------------------------------------------------
-- Game loading -------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
load :: String -> Game
load f =
  { board: fen2board $ parse f
  , history: []
  , positions: [ parse f ]
  }

loadPgn :: String -> Game
loadPgn =
  loadPgn' amazons
    <<< filter (not $ contains $ Pattern ".")
    <<< split (Pattern " ")
    <<< trim

loadPgn' :: Game -> Array String -> Game
loadPgn' g mvs = case uncons mvs of
  Just { head: m, tail: t } -> loadPgn' (move g m) t
  Nothing -> g

-----------------------------------------------------------------------------------------
-- Board to fen & viceversa -------------------------------------------------------------
-----------------------------------------------------------------------------------------
board2fen :: Board -> Fen
board2fen b =
  board2fen'
    ( joinWith
        ""
        (dropEnd 1 (concat (map (\r -> rank2fen r <> [ "/" ]) b)))
    )

board2fen' :: String -> Fen
board2fen' = joinWith "" <<< map tn <<< segSymbs
  where
  tn =
    ( \s -> case fromString s of
        Just _ -> toString (toNumber (length (toCharArray s)))
        Nothing -> s
    )

rank2fen :: Rank -> Array String
rank2fen = map sqr2fen

sqr2fen :: Square -> String
sqr2fen (Amazon White) = "w"

sqr2fen (Amazon Black) = "b"

sqr2fen Fire = "f"

sqr2fen Empty = "1"

fen2board :: String -> Board
fen2board = map fen2rank <<< split (Pattern "/") <<< field 0 <<< parse

fen2rank :: String -> Rank
fen2rank = concatMap symb2sqr <<< segSymbs

symb2sqr :: String -> Array Square
symb2sqr symbol = case fromString symbol of
  Just n -> replicate n Empty
  Nothing -> case symbol of
    "w" -> [ Amazon White ]
    "b" -> [ Amazon Black ]
    "x" -> [ Fire ]
    _ -> [ Empty ]

-----------------------------------------------------------------------------------------
-- Helpers ------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
replace2d :: forall a. Int -> Int -> a -> Array (Array a) -> Array (Array a)
replace2d r c a ass = case mr of
  Just rank -> replace r (replace c a rank) ass
  Nothing -> ass
  where
  mr = index ass r

replace :: forall a. Int -> a -> Array a -> Array a
replace i a as = case updateAt i a as of
  Just as2 -> as2
  Nothing -> as

field :: Int -> Fen -> String
field n f = case index (split (Pattern " ") f) n of
  Just fd -> fd
  Nothing -> ""

segSymbs :: String -> Array String
segSymbs =
  split (Pattern ",")
    <<< fromCharArray
    <<< segSymbs'
    <<< toCharArray

segSymbs' :: Array Char -> Array Char
segSymbs' [] = []

segSymbs' xs = case uncons xs of
  Just { head: a, tail: as } -> case isDigit a of
    true -> case head as of
      Just b -> case isDigit b of
        true -> a : segSymbs' as
        false -> a : ',' : segSymbs' as
      Nothing -> a : segSymbs' []
    false -> case head as of
      Just _ -> a : ',' : segSymbs' as
      Nothing -> a : segSymbs' []
  Nothing -> []

-----------------------------------------------------------------------------------------
-- Fen parsing --------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
has3fields :: String -> Boolean
has3fields = (_ == 3) <<< length <<< split (Pattern " ")

rdIsDig :: String -> Boolean
rdIsDig = all isDigit <<< toCharArray <<< field 2

ndIsTeam :: Fen -> Boolean
ndIsTeam f = f1 == "w" || f1 == "b"
  where
  f1 = field 1 f

st10ranks :: String -> Boolean
st10ranks = (_ == 10) <<< length <<< split (Pattern "/") <<< field 0

stValChrs :: String -> Boolean
stValChrs = all (flip elem $ validChars) <<< toCharArray <<< field 0
  where
  validChars = toCharArray "0123456789wbx/"

st10cols :: String -> Boolean
st10cols = all (_ == 10) <<< map cols <<< split (Pattern "/") <<< field 0

cols :: String -> Int
cols = sum <<< map symbVal <<< segSymbs

symbVal :: String -> Int
symbVal symbol = case fromString symbol of
  Just n -> n
  Nothing -> 1

validFen :: Fen -> Boolean
validFen f = all (_ $ f) rules
  where
  rules =
    [ has3fields
    , rdIsDig
    , ndIsTeam
    , st10ranks
    , stValChrs
    , st10cols
    ]

parse :: String -> Fen
parse f
  | validFen f = f
  | otherwise = initFen

-----------------------------------------------------------------------------------------
-- Getting info of the current turn -----------------------------------------------------
-----------------------------------------------------------------------------------------
fen :: Game -> Fen
fen g = case last g.positions of
  Just f -> f
  Nothing ->
    "PLEASE, AVOID CREATING GAMES MANUALLY. "
      <> "USE load OR loadPgn INSTEAD."

turn :: Game -> Team
turn g = case field 1 (fen g) of
  "b" -> Black
  _ -> White

moveNumber :: Game -> Int
moveNumber g = case fromString (field 2 (fen g)) of
  Just n -> n
  Nothing -> 0

pgn :: Game -> String
pgn g = case head ps of
  Just f -> case field 1 f of
    "b" -> show sm <> ". ... " <> (pgn' hs sm false)
    "w" -> pgn' hs sm true
    _ -> ""
  Nothing -> ""
  where
  sm = moveNumber g - ((length (g.history)) / 2)

  ps = g.positions

  hs = g.history

pgn' :: Array San -> Int -> Boolean -> String
pgn' [] _ _ = ""

pgn' ms n true = case uncons ms of
  Just { head: m, tail: t } -> show n <> ". " <> m <> " " <> pgn' t n false
  _ -> ""

pgn' ms n false = case uncons ms of
  Just { head: m, tail: t } -> m <> " " <> pgn' t (n + 1) true
  _ -> ""
