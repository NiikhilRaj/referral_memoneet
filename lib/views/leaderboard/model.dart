import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:referral_memoneet/models/leaderboard_entry_model.dart';
import 'package:referral_memoneet/providers/firestore_provider.dart';

class LeaderboardViewModel extends ChangeNotifier {
  final FirestoreProvider _firestoreProvider = FirestoreProvider();
  List<LeaderboardEntry> _entries = [];
  bool _isLoading = false;
  String? _error;
  String _period = 'weekly'; // Default to weekly

  // Getters
  List<LeaderboardEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  String get period => _period;

  // Toggle between weekly and monthly
  void togglePeriod() {
    _period = _period == 'weekly' ? 'monthly' : 'weekly';
    fetchLeaderboard();
  }

  // Fetch leaderboard data
  Future<void> fetchLeaderboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final leaderboardData = await _firestoreProvider.getLeaderboard(_period);
      // final currentUserPosition = await _firestoreProvider
      //     .getCurrentUserLeaderboardPosition(_period);

      _entries =
          leaderboardData.map((entry) {
            return LeaderboardEntry(
              rank: entry['rank'],
              name: entry['name'],
              score: entry['score'],
              earnings: entry['earnings'],
              isCurrentUser:
                  entry['partnerId'] == FirebaseAuth.instance.currentUser?.uid,
            );
          }).toList();
    } catch (e) {
      // _error = "Failed to fetch leaderboard data: ${e.toString()}";
      rethrow;
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
