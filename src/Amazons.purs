module Amazons where

import Prelude

import Data.Array ( length, head, index, uncons, (:), replicate, concatMap, last
                  , findIndex, updateAt, zip, (..), dropEnd, take, drop, concat, filter
                  )
import Data.Foldable (all, elem, sum)
import Data.Int (fromString, toNumber)
import Data.Maybe (Maybe(..))
import Data.Number.Format (toString)
import Data.String (Pattern(..), joinWith, split, trim)
import Data.String.CodeUnits (fromCharArray, toCharArray, contains)
import Data.Tuple (Tuple(..))
import Data.Version.Internal (isDigit)

---------v TYPE DECLARATIONS v-----------------------------

data Team = White | Black
data Square = Empty | Fire | Amazon Team
type Rank = Array Square
type Board = Array Rank

instance showSquare :: Show Square where
  show Empty          = "Empty"
  show Fire           = "Fire"
  show (Amazon White) = "Amazon White"
  show (Amazon Black) = "Amazon Black"

instance eqSquare :: Eq Square where
  eq Empty Empty                   = true
  eq Fire Fire                     = true
  eq (Amazon White) (Amazon White) = true
  eq (Amazon Black) (Amazon Black) = true
  eq _ _                           = false

instance showTeam :: Show Team where
  show White = "White"
  show Black = "Black"

instance eqTeam :: Eq Team where
  eq White White = true
  eq Black Black = true
  eq _ _         = false

type San = String
type Fen = String

newtype Amazons = Amazons
  { board :: Board
  , history ::  Array San
  , positions :: Array Fen
  }

---------v VALUES v----------------------------------------

amazons :: Amazons
amazons = load initFen

clear :: Amazons
clear = load "10/10/10/10/10/10/10/10/10/10 w 1"

initFen :: Fen
initFen = "3b2b3/10/10/b8b/10/10/w8w/10/10/3w2w3 w 1"

---------v FUNCTIONS v-------------------------------------

ascii :: Amazons -> String
ascii amzns = "+---------------------+\n" <>
              joinWith "" (map buildRank (zip b (10..1))) <>
              "+---------------------+\n" <>
              "  a b c d e f g h i j"
              where
                b         = gBoard amzns
                buildRank = (\(Tuple r n) -> ascii' r n)

ascii' :: Rank -> Int -> String
ascii' r n = "| " <> joinWith "" (map buildSymbs r) <> "| " <> 
             toString (toNumber n) <> "\n"
             where
               buildSymbs = (\sqr -> sqr2symb sqr <> " ")

sqr2symb :: Square -> String
sqr2symb sqr = case sqr of
                 Amazon White ->
                   "w"

                 Amazon Black ->
                   "b"
                              
                 Fire         ->
                   "x"

                 Empty        ->
                   "."

crd2ind :: String -> Array (Maybe Int)
crd2ind = crd2ind' <<< segSymbs

crd2ind' :: Array String -> Array (Maybe Int)
crd2ind' [c,r] = [ findIndex (_ == r) ranks
                 , findIndex (_ == c) columns
                 ]
                 where
                   ranks   = ["10","9","8","7","6","5","4","3","2","1"]
                   columns = ["a","b","c","d","e","f","g","h","i","j"]

crd2ind' _      = [Nothing,Nothing]

ind2crd  :: Int -> Int -> Maybe San
ind2crd r c = index columns c <> index ranks r
              where
                ranks   = ["10","9","8","7","6","5","4","3","2","1"]
                columns = ["a","b","c","d","e","f","g","h","i","j"]

put :: Amazons -> Square -> String -> Amazons
put amzns sqr crd = put' amzns sqr $ crd2ind crd

put' :: Amazons -> Square -> Array (Maybe Int) -> Amazons
put' amzns sqr [Just r,Just c] = 
  case index b r of
    Just rank ->
      Amazons { board: replace r (replace c sqr rank) b
              , history: gHist amzns
              , positions: gPos amzns
              }
                                    
    Nothing   ->
      amzns
  where
    b  = gBoard amzns

put' amzns _ _                  = amzns

move :: Amazons -> String -> Amazons
move amzns san = 
  case crd2ind orig of
    [Just or, Just oc] ->
      case san `elem` (movesOfSqr amzns or oc) of
        true  ->
          case get amzns orig of
            Just piece ->
              Amazons { board: gBoard (put (remove (put amzns piece dest) orig) Fire fire)
                      , history: gHist amzns <> [san]
                      , positions: gPos amzns <> [ board2fen (gBoard (put (remove (put amzns piece dest) orig) Fire fire)) <>
                                                   " " <> (if gTurn amzns == White then "b" else "w") <>
                                                   " " <> (if gTurn amzns == White then toString (toNumber (gMoveN amzns)) else toString (toNumber (gMoveN amzns)+toNumber 1))
                                                 ]
                      }
                           
            Nothing    ->
                             amzns

        false ->
          amzns

    _                  ->
                     amzns
  where
    orig = joinWith "" (take 2 (segSymbs san))
    dest = joinWith "" (take 2 (drop 2 (segSymbs san)))
    fire = joinWith "" (take 2 (drop 5 (segSymbs san)))

remove :: Amazons -> String -> Amazons
remove amzns crd = put amzns Empty crd

pgn :: Amazons -> String
pgn amzns = case head ps of
              Just fen ->
                case field 1 fen of
                  Just "b" ->
                    toString (toNumber sm) <> ". ... " <> (pgn' hs sm false)

                  Just "w" ->
                    pgn' hs sm true
                  
                  _        ->
                    ""

              Nothing  ->
                ""
            where
              sm = gMoveN amzns - ((length (gHist amzns))/2)
              ps = gPos amzns
              hs = gHist amzns

pgn' :: Array San -> Int -> Boolean -> String
pgn' [] _ _    = ""
pgn' ms n true = case uncons ms of
                   Just { head: m, tail: t } ->
                     toString (toNumber n) <> ". " <> m <> " " <> pgn' t n false

                   _                         ->
                     ""

pgn' ms n false = case uncons ms of
                    Just { head: m, tail: t } ->
                      m <> " " <> pgn' t (n+1) true

                    _                         ->
                      ""

get :: Amazons -> String -> Maybe Square
get amzns = get' amzns <<< crd2ind

get' :: Amazons -> Array (Maybe Int) -> Maybe Square
get' amzns [Just r,Just c] = getSqr amzns r c
get' _ _                   = Nothing

getSqr :: Amazons -> Int -> Int -> Maybe Square
getSqr amzns r c = getSqr' (index (gBoard amzns) r) c

getSqr' :: Maybe Rank -> Int -> Maybe Square
getSqr' (Just r) c = index r c
getSqr' _ _        = Nothing

replace :: forall a. Int -> a -> Array a -> Array a
replace i a as = case updateAt i a as of
                   Just as2 ->
                     as2
                   
                   Nothing ->
                     as

takeback :: Amazons -> Amazons
takeback amzns 
  | length (gPos amzns) == 2 = takeback' ( Amazons { board: gBoard amzns
                                                   , history: dropEnd 1 (gHist amzns)
                                                   , positions: dropEnd 1 (gPos amzns)
                                                   }
                                         )
  | otherwise                = amzns

takeback' :: Amazons -> Amazons
takeback' amzns = Amazons { board: fen2board (gFen amzns)
                          , history: gHist amzns
                          , positions: gPos amzns
                          }

legalMoves :: Amazons -> Array San
legalMoves amzns = concatMap (\r -> concatMap (\c -> movesOfSqr amzns r c) (0..9)) (0..9)

movesOfSqr :: Amazons -> Int -> Int -> Array San
movesOfSqr amzns r c = case getSqr amzns r c of
                         Just (Amazon t) ->
                           case gTurn amzns == t of
                             true  ->
                               case ind2crd r c of
                                 Just san ->
                                   movesOfSqr' (map (\d -> san <> d) pDests) fDests

                                 _        ->
                                   []

                             false ->
                               []
                             
                         _               ->
                           []
                       where
                         pDests = freeSqr amzns [r,c] [r,c]
                         fDests  = map (\dest -> case crd2ind dest of
                                                      [Just a, Just b] ->
                                                        freeSqr amzns [a,b] [r,c]
                                                     
                                                      _                ->
                                                        []) pDests

movesOfSqr' :: Array San -> Array (Array San) -> Array San
movesOfSqr' ds fss = case uncons ds, uncons fss of
                       Just { head: d, tail: t1 }, Just { head: fs, tail: t2 } ->
                         map (\f -> d <> "/" <> f) fs <> movesOfSqr' t1 t2
                       
                       _, _                                                    ->
                         []

freeSqr :: Amazons -> Array Int -> Array Int -> Array San
freeSqr amzns [r,c] [ri,ci] = concatMap (\d -> freeSqrDir amzns [r,c] d [ri,ci]) dirs
                              where
                                dirs = [ [(-1),(-1)]
                                       , [(-1),0]
                                       , [(-1),1]
                                       , [0,(-1)]
                                       , [0,1]
                                       , [1,(-1)]
                                       , [1,0]
                                       , [1,1]
                                       ]

freeSqr _ _  _              = []

freeSqrDir :: Amazons -> Array Int -> Array Int -> Array Int -> Array San
freeSqrDir amzns [r,c] [rd,cd] [ri,ci] = 
  case [r+rd,c+cd] == [ri, ci] of
    true  ->
      case ind2crd ri ci of
        Just san ->
          san : freeSqrDir amzns [r+rd,c+cd] [rd,cd] [ri,ci]
        
        Nothing ->
          []
    
    false ->
      case getSqr amzns (r+rd) (c+cd) of
        Just Empty ->
          case ind2crd (r+rd) (c+cd) of
            Just san ->
              san : freeSqrDir amzns [r+rd,c+cd] [rd,cd] [ri,ci]
        
            Nothing ->
              []

        _          ->
          []

freeSqrDir _ _ _ _                     = []

load :: String -> Amazons
load fen = Amazons { board: fen2board $ parse fen
                   , history: []
                   , positions: [parse fen]
                   }

loadPgn :: String -> Amazons
loadPgn = loadPgn' amazons 
        <<< filter (not $ contains $ Pattern ".") 
        <<< split (Pattern " ")
        <<< trim

loadPgn' :: Amazons -> Array String -> Amazons
loadPgn' amzns mvs = case uncons mvs of
                       Just { head: m, tail: t } ->
                         loadPgn' (move amzns m) t
                       
                       Nothing                   ->
                         amzns

ended :: Amazons -> Boolean
ended amzns = length (legalMoves amzns) == 0

board2fen :: Board -> Fen
board2fen b = board2fen' ( joinWith 
                           "" 
                           (dropEnd 1 (concat (map (\r -> rank2fen r <> ["/"]) b)))
                         )

board2fen' :: String -> Fen
board2fen' = joinWith "" <<< map tn <<< segSymbs
             where
               tn = (\s ->
                      case fromString s of
                        Just _  ->
                          toString (toNumber (length (toCharArray s)))
                          
                        Nothing ->
                          s
                    )

rank2fen :: Rank -> Array String
rank2fen = map sqr2fen

sqr2fen :: Square -> String
sqr2fen (Amazon White) = "w"
sqr2fen (Amazon Black) = "b"
sqr2fen Fire           = "f"
sqr2fen Empty          = "1"

fen2board :: String -> Board
fen2board = fen2board' <<< field 0 <<< parse

fen2board' :: Maybe Fen -> Board
fen2board' (Just fen) = map fen2rank $ split (Pattern "/") fen
fen2board' Nothing    = map fen2rank $ split (Pattern "/") initFen

fen2rank :: String -> Rank
fen2rank = concatMap symb2sqr <<< segSymbs

symb2sqr :: String -> Array Square
symb2sqr symbol = case fromString symbol of
                    Just n  ->
                      replicate n Empty

                    Nothing ->
                      case symbol of
                        "w" ->
                          [Amazon White]

                        "b" ->
                          [Amazon Black]
                              
                        "x" ->
                          [Fire]

                        _   ->
                          [Empty]

field :: Int -> String -> Maybe String
field n = flip index n <<< split (Pattern " ")

segSymbs :: String -> Array String
segSymbs = split (Pattern ",")
         <<< fromCharArray
         <<< segSymbs'
         <<< toCharArray

segSymbs' :: Array Char -> Array Char
segSymbs' [] = []
segSymbs' xs = case uncons xs of
               Just { head: a, tail: as } ->
                 case isDigit a of
                   true  ->
                     case head as of
                       Just b  ->
                         case isDigit b of
                           true  ->
                             a : segSymbs' as
                                     
                           false ->
                             a : ',' : segSymbs' as
                                 
                       Nothing ->
                         a : segSymbs' []

                   false ->
                     case head as of
                       Just _  ->
                         a : ',' : segSymbs' as
                                 
                       Nothing ->
                         a : segSymbs' []
                         
               Nothing                    ->
                 []

has3fields :: String -> Boolean
has3fields = (_ == 3) <<< length <<< split (Pattern " ")

rdIsDig :: String -> Boolean
rdIsDig = rdIsDig' <<< field 2

rdIsDig' :: Maybe String -> Boolean
rdIsDig' (Just x) = all isDigit $ toCharArray x
rdIsDig' Nothing  = false

ndIsTeam :: String -> Boolean
ndIsTeam = ndIsTeam' <<< field 1

ndIsTeam' :: Maybe String -> Boolean
ndIsTeam' (Just x) = x == "w" || x == "b"
ndIsTeam' Nothing  = false

st10ranks :: String -> Boolean
st10ranks = st10ranks' <<< field 0

st10ranks' :: Maybe String -> Boolean
st10ranks' (Just x) = (_ == 10) $ length $ split (Pattern "/") x
st10ranks' Nothing  = false

stValChrs :: String -> Boolean
stValChrs = stValChrs' <<< field 0

stValChrs' :: Maybe String -> Boolean
stValChrs' (Just x) = all (flip elem $ validChars) 
                    $ toCharArray x
                      where
                        validChars = toCharArray "0123456789wbx/"

stValChrs' Nothing  = false

st10cols :: String -> Boolean
st10cols = st10cols' <<< field 0

st10cols' :: Maybe String -> Boolean
st10cols' (Just x) = all (_ == 10)
                   $ map cols
                   $ split (Pattern "/") x

st10cols' Nothing  = false

cols :: String -> Int
cols = sum <<< map symbVal <<< segSymbs

symbVal :: String -> Int
symbVal symbol = case fromString symbol of
                   Just n  ->
                     n
                       
                   Nothing ->
                     1

validFen :: String -> Boolean
validFen fen = all (_ $ fen) rules
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
parse fen | validFen fen = fen
          | otherwise    = initFen

gBoard :: Amazons -> Board
gBoard (Amazons amzns) = amzns.board

gFen :: Amazons -> Fen
gFen (Amazons amzns) = gFen' $ last amzns.positions

gFen' :: Maybe Fen -> Fen
gFen' (Just fen) = fen
gFen' Nothing    = "PLEASE, AVOID CREATING GAMES MANUALLY. " <>
                   "USE load OR loadPgn INSTEAD."

gHist :: Amazons -> Array San
gHist (Amazons amzns) = amzns.history

gTurn :: Amazons -> Team
gTurn = gTurn' <<< field 1 <<< gFen

gTurn' :: Maybe String -> Team
gTurn' (Just "b") = Black
gTurn' _          = White

gPos :: Amazons -> Array Fen
gPos (Amazons amzns) = amzns.positions

gMoveN :: Amazons -> Int
gMoveN = gMoveN' <<< field 2 <<< gFen

gMoveN' :: Maybe String -> Int
gMoveN' (Just s) = case fromString s of
                     Just n  ->
                       n
                     
                     Nothing ->
                       0

gMoveN' Nothing  = 0
