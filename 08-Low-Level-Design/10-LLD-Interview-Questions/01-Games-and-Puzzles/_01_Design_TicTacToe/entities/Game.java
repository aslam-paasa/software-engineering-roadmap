class Game {
    private final Board board;
    private final Player[] players;
    private int currentPlayerIndex;
    private GameStatus status;

    public Game(Player player1, Player player2, int boardSize) {
        this.board = new Board(boardSize);
        this.players = new Player[]{player1, player2};
        this.currentPlayerIndex = 0;
        this.status = GameStatus.IN_PROGRESS;
    }

    public synchronized void makeMove(int row, int col) {
        // TODO: Play one move at (row, col) for the current player.
        // 1. If the game is already over, raise/throw an invalid-move error.
        // 2. If the target cell is not empty, raise/throw an invalid-move error.
        // 3. Place the current player's symbol on the board.
        // 4. If the move wins, set the winning status and stop.
        // 5. Otherwise, if the board is full, set status to DRAW and stop.
        // 6. Otherwise, switch to the other player.
    }

    private boolean checkWin(int row, int col, Symbol symbol) {
        // TODO: Return true if placing symbol at (row, col) completes a line.
        // Check the move's row, its column, and the two diagonals (when the move lies on them).
        return false;
    }

    public Board getBoard() { return board; }
    public Player getCurrentPlayer() { return players[currentPlayerIndex]; }
    public GameStatus getStatus() { return status; }

    public Player getWinner() {
        // TODO: Return the winning Player, or null if there is no winner yet.
        // Map the status (winner X / winner O) to whichever player holds that symbol.
        return null;
    }

    public void printBoard() {
        board.printBoard();
    }
}