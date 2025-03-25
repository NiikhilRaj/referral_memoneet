import 'package:flutter/foundation.dart';
import 'package:referral_memoneet/models/leaderboard_entry_model.dart';

class LeaderboardViewModel extends ChangeNotifier {
  List<LeaderboardEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<LeaderboardEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Fetch leaderboard data
  Future<void> fetchLeaderboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      _entries = [
        LeaderboardEntry(
            rank: 1,
            name: 'John Doe',
            score: 1200,
            isCurrentUser: false,
            earnings: 5 * 1200),
        LeaderboardEntry(
            rank: 2,
            name: 'Jane Smith',
            score: 1150,
            isCurrentUser: false,
            earnings: 5 * 1150),
        LeaderboardEntry(
            rank: 3,
            name: 'Alice Brown',
            score: 1100,
            isCurrentUser: true,
            earnings: 5 * 1100),
        LeaderboardEntry(
            rank: 4,
            name: 'Bob Johnson',
            score: 1050,
            isCurrentUser: false,
            earnings: 5 * 1050),
        LeaderboardEntry(
            rank: 5,
            name: 'Charlie Wilson',
            score: 1000,
            isCurrentUser: false,
            earnings: 5 * 1000),
      ];
    } catch (e) {
      _error = "Failed to fetch leaderboard data: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh leaderboard data
  void refresh() {
    fetchLeaderboard();
  }
}
