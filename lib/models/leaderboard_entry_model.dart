// Model for leaderboard entry
class LeaderboardEntry {
  final int? rank;
  final String? name;
  final int? score;
  final int? earnings;
  final bool? isCurrentUser;

  LeaderboardEntry({
    this.rank,
    this.name,
    this.score,
    this.isCurrentUser,
    this.earnings,
  });
}
