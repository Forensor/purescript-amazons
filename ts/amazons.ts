class Amazons {
    private _board: string[][];
    private _history: string[];
    private _moveN: number;
    private _positions: string[];
    private _turn: string;

    constructor(fen: string = '3r2/6/b5/5b/6/2r3 r 1') {
        this._board = this.boardFromFen(fen);
        this._history = [];
        this._moveN = this.moveNFromFen(fen);
        this._positions = [this.validFen(fen) ? fen : '3r2/6/b5/5b/6/2r3 r 1'];
        this._turn = this.turnFromFen(fen);
    }
    /**
     * Returns an ASCII representation of the current position
     * @returns {string} ASCII string
     */
    public ascii(): string {
        let builder: string = '┌──────────────────┐\r\n';
        let rNumber: number = 6;
        this._board.forEach(row => {
            builder += `│ ${row[0] === '' ? '.' : row[0]}  ${row[1] === '' ? '.' : row[1]}  ${row[2] === '' ? '.' : row[2]}  ${row[3] === '' ? '.' : row[3]}  ${row[4] === '' ? '.' : row[4]}  ${row[5] === '' ? '.' : row[5]} │ ${rNumber}\r\n`;
            rNumber -= 1;
        });
        builder += '└──────────────────┘\r\n  a  b  c  d  e  f';
        return builder;
    }
    /**
     * Returns the current position in a 2D array format
     * @returns {string[][]} 2D array of the position
     */
    public board(): string[][] {
        return this._board;
    }
    /**
     * Clears the board
     */
    public clear(): void {
        this._board = this.boardFromFen('6/6/6/6/6/6 r 1');
        this._history = [];
        this._moveN = 1;
        this._positions = ['6/6/6/6/6/6 r 1'];
        this._turn = 'r';
    }
    /**
     * Returns the FEN of the current position
     * @returns {string} The FEN
     */
    public fen(): string {
        let builder: string = '';
        this._board.forEach((row, ind) => {
            let counter: number = 0;
            row.forEach(col => {
                if (col === '') {
                    counter += 1;
                } else {
                    builder += `${counter === 0 ? '' : counter}${col}`;
                    counter = 0;
                }
            });
            if (counter !== 0) {
                builder += counter;
            }
            if (ind !== 5) {
                builder += '/';
            }
        });
        builder += ` ${this._turn} ${this._moveN}`;
        return builder;
    }
    /**
     * Checks if the game has ended
     * @returns {boolean} Returns true if the game has ended, otherwise false
     */
    public gameOver(): boolean {
        if (this.moves().length === 0) {
            return true;
        } else {
            return false;
        }
    }
    /**
     * Gets the piece located in the indicated square
     * @param {string} square Coordinates of the desired square, otherwise the piece in 'a6'
     */
    public get(square: string): string {
        return this._board[this.ts(square)[0]][this.ts(square)[1]];
    }
    /**
     * Returns the list of the game moves
     * @returns {string[]} The move history
     */
    public history(): string[] {
        return this._history;
    }
    /**
     * Loads the specified FEN position
     * @param {string} fen The FEN to be loaded
     * @returns {boolean} Returns true if the position was successfully loaded, otherwise false
     */
    public load(fen: string): boolean {
        if (this.validFen(fen)) {
            this._board = this.boardFromFen(fen);
            this._moveN = this.moveNFromFen(fen);
            this._turn = this.turnFromFen(fen);
            return true;
        } else {
            return false;
        }
    }
    /**
     * Loads the specified PGN
     * @param {string} pgn The PGN to be loaded
     * @returns {boolean} Returns true if the pgn was successfully parsed, otherwise false
     */
    public loadPgn(pgn: string): boolean {
        let valid: boolean = true;
        if (pgn.split(/ {0,1}[0-9]{1,3}\. | /).slice(1).length <= 0) {
            valid = false;
        }
        pgn.split(/ {0,1}[0-9]{1,3}\. | /).slice(1).forEach(movement => {
            if (!this.move(movement)) {
                this.reset();
                valid = false;
            }
        });
        return valid;
    }
    /**
     * Moves a piece of the board
     * @param {string} movement The movement to be done in Standard Algebraic Notation
     * @returns {boolean} Returns true if the move was successfully done, otherwise false
     */
    public move(movement: string): boolean {
        if (this.moves().includes(movement)) {
            this.put(this.remove(movement.slice(0, 2)), movement.slice(2, 4));
            this.put('x', movement.slice(5, 7));
            this._history.push(movement);
            this._moveN = Math.floor(this._history.length / 2 + 1);
            this._turn = this._turn === 'r' ? 'b' : 'r';
            this._positions.push(this.fen());
            return true;
        } else {
            return false;
        }
    }
    /**
     * Returns an array with all the possible legal moves
     * @returns {string[]} The list with moves in Standard Algebraic Notation
     */
    public moves(): string[] {
        let posMoves: string[] = [];
        this._board.forEach((row, r) => {
            row.forEach((piece, c) => {
                if (piece === this._turn) {
                    this.rsfs(this.ti(r, c)).forEach(fstMove => {
                        this.rsfs(fstMove, this.ti(r, c)).forEach(sndMove => {
                            posMoves.push(`${this.ti(r, c)}${fstMove}/${sndMove}`);
                        });
                    });
                }
            });
        })
        return posMoves;
    }
    /**
     * Returns the PGN
     * @returns {string} The PGN
     */
    public pgn(): string {
        let builder = '';
        this._history.forEach((move, ind) => {
            if (ind % 2 === 0) {
                builder += `${ind / 2 + 1}. ${move} `;
            } else {
                builder += `${move} `;
            }
        });
        return builder.trim();
    }
    /**
     * Returns a list of all the game positions in FEN format
     * @returns {string[]} The positions
     */
    public positions(): string[] {
        return this._positions;
    }
    /**
     * Places a piece in the indicated square
     * @param {string} piece  The piece to be placed
     * @param {string} square Coordinates of the desired square
     * @returns {boolean} Returns true if the piece was placed, otherwise false
     */
    public put(piece: string, square: string): boolean {
        if (this.validPiece(piece) && this.validSquare(square)) {
            this._board[this.ts(square)[0]][this.ts(square)[1]] = piece;
            return true;
        } else {
            return false;
        }
    }
    /**
     * Removes and returns the piece of the indicated square from the board
     * @param {string} square Coordinates of the desired square
     * @returns {string} Returns the removed piece if correct coords were passed, otherwise the piece at 'a6'
     */
    public remove(square: string): string {
        const piece: string = this.get(square);
        this._board[this.ts(square)[0]][this.ts(square)[1]] = '';
        return piece;
    }
    /**
     * Sets board back to its initial position
     */
    public reset(): void {
        this._board = this.boardFromFen('3r2/6/b5/5b/6/2r3 r 1');
        this._history = [];
        this._moveN = 1;
        this._positions = ['3r2/6/b5/5b/6/2r3 r 1'];
        this._turn = 'r';
    }
    /**
     * Returns the side to play
     * @returns {string} (r)ed or (b)lue
     */
    public turn(): string {
        return this._turn;
    }
    /**
     * Takebacks the last move, returning it
     * @returns {string} The move taken back, otherwise an empty string
     */
    public takeback(): string {
        if (this._history.length > 0) {
            const movement: string = this._history.slice(-1)[0];
            this._history.pop();
            this._positions.pop();
            this._board = this.boardFromFen(this._positions.slice(-1)[0]);
            this._moveN = this.moveNFromFen(this._positions.slice(-1)[0]);
            this._turn = this.turnFromFen(this._positions.slice(-1)[0]);
            return movement;
        } else {
            return '';
        }
    }

    private boardFromFen(fen: string): string[][] {
        if (this.validFen(fen)) {
            let bBuilder: string[][] = [];
            fen.split(' ')[0].split('/').forEach(row => {
                let rBuilder: string[] = [];
                Array.from(row).forEach(piece => {
                    if (isNaN(parseInt(piece))) {
                        rBuilder.push(piece);
                    } else {
                        for (let i: number = parseInt(piece); i > 0; i--) {
                            rBuilder.push('');
                        }
                    }
                });
                bBuilder.push(rBuilder);
            });
            return bBuilder;
        } else {
            return [
                ['','','','r','',''],
                ['','','','','',''],
                ['b','','','','',''],
                ['','','','','','b'],
                ['','','','','',''],
                ['','','r','','','']
            ];
        }
    }

    private moveNFromFen(fen: string): number {
        if (this.validFen(fen)) {
            return parseInt(fen.split(' ')[2]);
        } else {
            return 1;
        }
    }
    // Reachable Squares From Square
    private rsfs(square: string, ignoring: string = ''): string[] {
        if (this.validSquare(square)) {
            let posMoves: string[] = [];
            // 🡴
            for (let row = this.ts(square)[0] - 1, col = this.ts(square)[1] - 1; this.validIndex(row) && this.validIndex(col); row--, col--) {
                if (this.get(this.ti(row, col)) === '' || this.ti(row, col) === ignoring) {
                    posMoves.push(this.ti(row, col));
                } else {
                    break;
                }
            }
            // 🡱
            for (let row = this.ts(square)[0] - 1; this.validIndex(row); row--) {
                if (this.get(this.ti(row, this.ts(square)[1])) === '' || this.ti(row, this.ts(square)[1]) === ignoring) {
                    posMoves.push(this.ti(row, this.ts(square)[1]));
                } else {
                    break;
                }
            }
            // 🡵
            for (let row = this.ts(square)[0] - 1, col = this.ts(square)[1] + 1; this.validIndex(row) && this.validIndex(col); row--, col++) {
                if (this.get(this.ti(row, col)) === '' || this.ti(row, col) === ignoring) {
                    posMoves.push(this.ti(row, col));
                } else {
                    break;
                }
            }
            // 🡰
            for (let col = this.ts(square)[1] - 1; this.validIndex(col); col--) {
                if (this.get(this.ti(this.ts(square)[0], col)) === '' || this.ti(this.ts(square)[0], col) === ignoring) {
                    posMoves.push(this.ti(this.ts(square)[0], col));
                } else {
                    break;
                }
            }
            // 🡲
            for (let col = this.ts(square)[1] + 1; this.validIndex(col); col++) {
                if (this.get(this.ti(this.ts(square)[0], col)) === '' || this.ti(this.ts(square)[0], col) === ignoring) {
                    posMoves.push(this.ti(this.ts(square)[0], col));
                } else {
                    break;
                }
            }
            // 🡷
            for (let row = this.ts(square)[0] + 1, col = this.ts(square)[1] - 1; this.validIndex(row) && this.validIndex(col); row++, col--) {
                if (this.get(this.ti(row, col)) === '' || this.ti(row, col) === ignoring) {
                    posMoves.push(this.ti(row, col));
                } else {
                    break;
                }
            }
            // 🡳
            for (let row = this.ts(square)[0] + 1; this.validIndex(row); row++) {
                if (this.get(this.ti(row, this.ts(square)[1])) === '' || this.ti(row, this.ts(square)[1]) === ignoring) {
                    posMoves.push(this.ti(row, this.ts(square)[1]));
                } else {
                    break;
                }
            }
            // 🡶
            for (let row = this.ts(square)[0] + 1, col = this.ts(square)[1] + 1; this.validIndex(row) && this.validIndex(col); row++, col++) {
                if (this.get(this.ti(row, col)) === '' || this.ti(row, col) === ignoring) {
                    posMoves.push(this.ti(row, col));
                } else {
                    break;
                }
            }
            return posMoves;
        } else {
            return [];
        }
    }
    // Translate Indices
    private ti(row: number, col: number): string {
        if (this.validIndex(row) && this.validIndex(col)) {
            return `${['a','b','c','d','e','f'][col]}${6 - row}`;
        } else {
            return 'a6';
        }
    }
    // Translate Square
    private ts(square: string): number[] {
        if (this.validSquare(square)) {
            return [
                Math.abs(parseInt(square[1]) - 1 - 5),
                ['A','B','C','D','E','F'].findIndex(letter => letter === square[0].toUpperCase())
            ];
        } else {
            return [0, 0];
        }
    }

    private turnFromFen(fen: string): string {
        if (this.validFen(fen)) {
            return fen.split(' ')[1];
        } else {
            return 'r';
        }
    }

    private validFen(fen: string): boolean {
        if (fen.split(' ').length !== 3) {
            return false;
        }
        if (isNaN(parseInt(fen.split(' ')[2])) || parseInt(fen.split(' ')[2]) < 1 || parseInt(fen.split(' ')[2]) > 999) {
            return false;
        }
        if (fen.split(' ')[1] !== 'r' && fen.split(' ')[1] !== 'b') {
            return false;
        }
        if (fen.split(' ')[0].split('/').length !== 6) {
            return false;
        }
        for (let i: number = 0; i < fen.split(' ')[0].split('/').length; i++) {
            let counter: number = 0;
            for (let j: number = 0; j < fen.split(' ')[0].split('/')[i].length; j++) {
                if (isNaN(parseInt(fen.split(' ')[0].split('/')[i][j]))) {
                    if (fen.split(' ')[0].split('/')[i][j] === 'r' || fen.split(' ')[0].split('/')[i][j] === 'b' || fen.split(' ')[0].split('/')[i][j] === 'x') {
                        counter += 1;
                    } else {
                        return false;
                    }
                } else {
                    counter += parseInt(fen.split(' ')[0].split('/')[i][j]);
                }
                if (counter > 6) {
                    return false;
                }
            }
            if (counter < 6) {
                return false;
            }
        }
        return true;
    }

    private validIndex(index: number): boolean {
        return index >= 0 && index <= 5;
    }

    private validPiece(piece: string): boolean {
        if (piece === 'r' || piece === 'b' || piece === 'x' || piece === '') {
            return true;
        } else {
            return false;
        }
    }

    private validSquare(square: string): boolean {
        return /^[a-fA-F][1-6]$/.test(square);
    }
}
