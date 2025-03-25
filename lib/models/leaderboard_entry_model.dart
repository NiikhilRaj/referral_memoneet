// Model for leaderboard entry
class LeaderboardEntry {
  final int rank;
  final String name;
  final int score;
  final int earnings;
  final bool isCurrentUser;

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.score,
    required this.isCurrentUser,
    required this.earnings
  });
}
