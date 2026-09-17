class PredictionLockedException implements Exception {
  const PredictionLockedException({
    required this.fixtureId,
    required this.kickoff,
  });

  final String fixtureId;
  final DateTime kickoff;

  @override
  String toString() {
    return 'PredictionLockedException: fixture $fixtureId is locked after kickoff $kickoff';
  }
}
