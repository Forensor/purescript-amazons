<div id="top"></div>
<br />
<div align="center">
  <a href="https://github.com/forensor/amazons">
    <img src="documentation/logo.png" alt="Logo" height="80">
  </a>

<h3 align="center"><b>The Game of the Amazons PureScript Engine</b></h3>

  <p align="center">
    <sup>A viewless library to control/validate matches of The Game of the Amazons.</sup>
    <br />
    <a href="/documentation"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/forensor/amazons">Try it online!</a>
    ·
    <a href="https://github.com/Forensor/purescript-amazons/issues">Report Bug</a>
    ·
    <a href="https://github.com/Forensor/purescript-amazons/issues">Request Feature</a>
  </p>
</div>

## Contents

* [About The Project and The Game](#about)
* [Getting Started](#started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)

<a id="about"></a>

## About The Project and The Game

[The Game of the Amazons](https://en.wikipedia.org/wiki/Game_of_the_Amazons) (*El Juego de las Amazonas*) was invented in 1988 by Walter Zamkauskas of Argentina, and first published (in Spanish) in issue number 4 of the puzzle magazine *El Acertijo* in December of 1992. It is a game of territorial strategy, in which both players compete to leave their opponent's pieces without movements. Its rules are simple, but mastering the game takes a lifetime.

**The Game of the Amazons PureScript Engine** (GAPE) is a project that aims to bring more people to appreciate the beauty of this wonderful game and allow them to contribute in a coordinate manner. That's why we believe that [PureScript](https://www.purescript.org/) is the right language for two main reasons:

1. It's a strongly-typed functional programming language with powerful tools very similar to [Haskell](https://www.haskell.org/) (algebraic data types, pattern matching, higher kinded types, typeclasses...).
2. It compiles to JavaScript, one of the most popular languages used (see [GitHut Stats](https://madnight.github.io/githut)).

There is also an unmaintained pre-release version done with TypeScript [here](legacy).

<p align="right"><a href="#top">back to top</a></p>

<a id="started"></a>

## Getting Started

<a id="prerequisites"></a>

### Prerequisites

You will need [Node](https://nodejs.org/) to install the PureScript compiler.

```node
npm install -g purescript
```

[Spago](https://github.com/purescript/spago) is the recommended package manager and build tool for PureScript.

If you don't have Spago installed, install it now:

```node
npm install -g spago
```

Complete quickstart guide available [here](https://github.com/purescript/documentation/blob/master/guides/Getting-Started.md).

<a id="installation"></a>

### Installation

GAPE is not released yet, but you can clone/fork the project to test it. Go to *[this guide](https://github.com/Forensor/purescript-amazons/tree/master/documentation#coding)* for more info

<p align="right"><a href="#top">back to top</a></p>

<a id="usage"></a>

## Usage

Here's a simple example of a random game generator:

```haskell
import Effect
import Effect.Console (log)
import Effect.Random (randomInt)
import Prelude

import Amazons

import Data.Array (index, length)
import Data.Maybe (Maybe(..))

match :: Amazons -> Effect Unit
match amzns =
  if ended amzns then do
    log $ ascii amzns
    log $ "Game ended. " <> (show $ gTurn amzns) <> " lost!"
    log $ pgn amzns
  else do
    i <- randomInt 0 (length movs - 1)
    case index movs i of
      Just san -> match $ move amzns san
      Nothing  -> log $ "Invalid movement."
  where
    movs = legalMoves amzns

main :: Effect Unit
main = match amazons
```

Output:

```haskell
{-
+---------------------+
| . . . x x x b x . x | 10
| x x x . . x x x . x | 9
| . . x x x x x x x x | 8
| x x . . x x x x x . | 7
| b x x x x w x . x x | 6
| x x x . x x x x x w | 5
| . . x x x x . x x . | 4
| x x w x x x . . x . | 3
| b x x x w x x x . . | 2
| b x x . . . x . x x | 1
+---------------------+
  a b c d e f g h i j
Game ended. Black lost!
1. g1g3/e5 d10d3/i8 2. g3f4/d2 g10h10/h4 3. f4d4/g1 d3f1/f5 4. j4i5/i1 j7f3/b7 5. d4e3/g5 f3e4/f4 6. d1i6/h5 f1b1/d3 7. i6c6/b6 ...
-}
```

<p align="right"><a href="#top">back to top</a></p>

<a id="roadmap"></a>

## Roadmap

- [ ] Refactor piece movement functions
- [ ] Testing with purescript-quickcheck
- [ ] Discuss new names for functions/values
- [ ] Refactor `case of case of ...` nests

See the [open issues](https://github.com/Forensor/purescript-amazons/issues) for a full list of proposed features (and known issues).

<p align="right"><a href="#top">back to top</a></p>

<a id="contributing"></a>

## Contributing

GAPE needs your help, and it'll be greatly appreciated! Go to the [documentation](/documentation/) to learn how can you help.

<p align="right"><a href="#top">back to top</a></p>

<a id="license"></a>

## License

GAPE is distributed under the BSD 2-Clause License. See [LICENSE](LICENSE) for more information.

<p align="right"><a href="#top">back to top</a></p>

<a id="contact"></a>

## Contact

For inquires about bugs or new feature requests go to [contributor's guide](guide). For everything else feel free to DM or send an email! 🙂

Álvaro Sánchez - [@Forensor](https://twitter.com/forensor) - forensor@hotmail.com

<p align="right"><a href="#top">back to top</a></p>

---
<p align="center"><sup>The Game of the Amazons PureScript Engine</sup></p>
