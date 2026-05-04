class GameState {
  final int points;
  final int currentIndex;

  const GameState({
    this.points = 0,
    this.currentIndex = 0
  });

  GameState copyWith({
    int? points,
    int? currentIndex,
  }) {
    return GameState(
      points: points ?? this.points,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}