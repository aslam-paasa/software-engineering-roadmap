class Board {
    private final int size;
    private final Map<Integer, Integer> snakesAndLadders;

    public Board(int size, List<BoardEntity> entities) {
        this.size = size;
        this.snakesAndLadders = new HashMap<>();

        for (BoardEntity entity : entities) {
            snakesAndLadders.put(entity.getStart(), entity.getEnd());
        }
    }

    public int getSize() {
        return size;
    }

    public int getFinalPosition(int position) {
        // TODO: Return the final position after applying any snake or ladder.
        // Look up `position` in the snakes-and-ladders map.
        // If an entry exists, return its mapped end position.
        // Otherwise return `position` unchanged.
        return 0;
    }
}