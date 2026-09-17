abstract final class FirestoreCollections {
  static const String leagues = 'leagues';
  static const String rounds = 'rounds';
  static const String fixtures = 'fixtures';
  static const String predictions = 'predictions';

  static String standings(String leagueId) => 'leagues/$leagueId/standings';
}
