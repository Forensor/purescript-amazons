# amazons.js

amazons.js is a viewless js library that allows you to control/validate 6x6 matches of The Amazons Game.

## Documentation

### constructor: Amazons([fen: string])

Amazons() can take an optional param to load another position distinct from the default one. This param must have the [Forsyth-Edwards Notation](http://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation) format.

```js
// Default position loaded
const amazons = new Amazons();
// Custom position loaded
const amazons = new Amazons('1r4/6/2b3/6/6/b2r2 b 26');
```

### .ascii()

Returns an ASCII representation of the current position.

```js
const amazons = new Amazons();
amazons.ascii();
/*
┌──────────────────┐
│ .  .  .  r  .  . │ 6
│ .  .  .  .  .  . │ 5
│ b  .  .  .  .  . │ 4
│ .  .  .  .  .  b │ 3
│ .  .  .  .  .  . │ 2
│ .  .  r  .  .  . │ 1
└──────────────────┘
  a  b  c  d  e  f
*/
```

### .board()

Returns the current position in a 2D array format.

```js
const amazons = new Amazons();
amazons.board();
/*
[
  [ '', '', '', 'r', '', '' ],
  [ '', '', '', '', '', '' ],
  [ 'b', '', '', '', '', '' ],
  [ '', '', '', '', '', 'b' ],
  [ '', '', '', '', '', '' ],
  [ '', '', 'r', '', '', '' ]
]
*/
```

### .clear()

Clears the board and PGN.

```js
const amazons = new Amazons();
amazons.clear();
amazons.ascii();
/*
┌──────────────────┐
│ .  .  .  .  .  . │ 6
│ .  .  .  .  .  . │ 5
│ .  .  .  .  .  . │ 4
│ .  .  .  .  .  . │ 3
│ .  .  .  .  .  . │ 2
│ .  .  .  .  .  . │ 1
└──────────────────┘
  a  b  c  d  e  f
*/
amazons.fen(); // -> 6/6/6/6/6/6 r 1
amazons.pgn(); // -> ''
```

### .fen()

Returns the FEN of the current position.

```js
const amazons = new Amazons();
amazons.fen(); // -> 3r2/6/b5/5b/6/2r3 r 1
```

### .gameOver()

Checks if the game has ended.

```js
const amazons = new Amazons();
amazons.gameOver(); // -> false
// Red can't move
amazons.load('1xbx2/1xxxx1/xxxx1x/xrxbx1/rxxxx1/xxxxxx r 13');
amazons.ascii();
/*
┌──────────────────┐
│ .  x  b  x  .  . │ 6
│ .  x  x  x  x  . │ 5
│ x  x  x  x  .  x │ 4
│ x  r  x  b  x  . │ 3
│ r  x  x  x  x  . │ 2
│ x  x  x  x  x  x │ 1
└──────────────────┘
  a  b  c  d  e  f
*/
amazons.gameOver(); // -> true
```

### .get(square: string)

Gets the piece located in the indicated square. If no valid square is passed, the piece in a6 is returned instead.

```js
const amazons = new Amazons();
amazons.get('d6'); // -> r
// Invalid square
amazons.get('z2'); // -> ''
```

### .history()

Returns the list of the game moves.

```js
const amazons = new Amazons();
amazons.move('d6d5/e5');
amazons.move('a4c4/d3');
amazons.move('c1d1/c2');
amazons.history(); // -> ['d6d5/e5', 'a4c4/d3', 'c1d1/c2']
```

### .load(fen: string)

Loads the specified FEN position. Returns true if it was successfully loaded, otherwise false.

```js
const amazons = new Amazons();
// Correct
amazons.load('1x1xxr/x2xxb/xxx1xx/xxxxx1/xbxxxx/x1xrx1 r 13'); // -> true
// Incorrect
amazons.load('this/doesnt/make/sense/at/all z 90'); // -> false
```

### .loadPgn(pgn: string)

Loads the specified [Portable Game Notation](https://en.wikipedia.org/wiki/Portable_Game_Notation) and returns true if it was successfully loaded, otherwise false. If no valid PGN is passed, the position is reset to the default one.

```js
const amazons = new Amazons();
// Correct
amazons.loadPgn('1. d6d5/e5 a4c4/d3 2. c1d1/c2'); // -> true
// Incorrect
amazons.loadPgn('1. This is 2. weird again'); // -> false
```

### .move(movement: string)

Moves a piece of the board. Returns true if it was done, otherwise false.

```js
const amazons = new Amazons();
amazons.move('d6d5/e5'); // -> true
amazons.move('a4c4/d3'); // -> true
amazons.move('a1a1/a1'); // -> false
amazons.ascii();
/*
┌──────────────────┐
│ .  .  .  .  .  . │ 6
│ .  .  .  r  x  . │ 5
│ .  .  b  .  .  . │ 4
│ .  .  .  x  .  b │ 3
│ .  .  .  .  .  . │ 2
│ .  .  r  .  .  . │ 1
└──────────────────┘
  a  b  c  d  e  f
*/
```

### .moves()

Returns an array with all the possible legal moves.

```js
const amazons = new Amazons('r1x3/2x3/xxx3/6/6/6 r 1');
amazons.ascii();
/*
┌──────────────────┐
│ r  .  x  .  .  . │ 6
│ .  .  x  .  .  . │ 5
│ x  x  x  .  .  . │ 4
│ .  .  .  .  .  . │ 3
│ .  .  .  .  .  . │ 2
│ .  .  .  .  .  . │ 1
└──────────────────┘
  a  b  c  d  e  f
*/
amazons.moves();
/*
[
  'a6b6/a6', 'a6b6/a5',
  'a6b6/b5', 'a6a5/a6',
  'a6a5/b6', 'a6a5/b5',
  'a6b5/a6', 'a6b5/b6',
  'a6b5/a5'
]
*/
```

### .pgn()

Returns the PGN.

```js
const amazons = new Amazons();
amazons.move('d6d5/e5');
amazons.move('a4c4/d3');
amazons.move('c1d1/c2');
amazons.pgn(); // -> 1. d6d5/e5 a4c4/d3 2. c1d1/c2
```

### .positions()

Returns a list of all the game positions in FEN format.

```js
const amazons = new Amazons();
amazons.move('d6d5/e5');
amazons.move('a4c4/d3');
amazons.move('c1d1/c2');
amazons.positions();
/*
[
  '3r2/6/b5/5b/6/2r3 r 1',
  '6/3rx1/b5/5b/6/2r3 b 1',
  '6/3rx1/2b3/3x1b/6/2r3 r 2',
  '6/3rx1/2b3/3x1b/2x3/3r2 b 2'
]
*/
```

### .put(piece: string, square: string)

Places a piece in the indicated square. Returns true if the piece was placed, otherwise false.

```js
const amazons = new Amazons();
// Correct
amazons.put('x', 'a6'); // -> true
// Invalid piece
amazons.put('z', 'b4'); // -> false
```

### .remove(square: string)

Removes and returns the piece of the indicated square from the board. Returns the piece in a6 if an invalid square was passed.

```js
const amazons = new Amazons();
// Correct
amazons.remove('d6'); // -> r
// Invalid square
amazons.remove('z6'); // -> ''
```

### .reset()

Sets board back to its initial position.

```js
const amazons = new Amazons();
amazons.loadPgn('1. d6d4/f6 a4b3/e6 2. c1a3/a2');
amazons.fen(); // -> 4xx/6/3r2/rb3b/x5/6 b 2
amazons.reset();
amazons.fen(); // -> 3r2/6/b5/5b/6/2r3 r 1
```

### .turn()

Returns the side to play.

```js
const amazons = new Amazons();
amazons.turn(); // -> r
amazons.move('d6d4/f6');
amazons.turn(); // -> b
```

### .takeback()

Takebacks the last move, returning it. Returns an empty string if no move has been taken back.

```js
const amazons = new Amazons();
amazons.move('d6d4/f6');
amazons.takeback(); // -> d6d4/f6
// No move to takeback
amazons.takeback(); // -> ''
```