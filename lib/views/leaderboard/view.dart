import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/leaderboard/model.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LeaderboardViewModel(),
      child: const LeaderboardView(),
    );
  }
}

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({Key? key}) : super(key: key);

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  @override
  void initState() {
    super.initState();
    // Fetch leaderboard data when the view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardViewModel>().fetchLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
      ),
      body: Consumer<LeaderboardViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading leaderboard',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchLeaderboard(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.entries.isEmpty) {
            return const Center(
              child: Text('No leaderboard data available'),
            );
          }

          // Determine how many entries to show (up to 20)
          final entriesCount =
              viewModel.entries.length > 20 ? 20 : viewModel.entries.length;

          return ListView.builder(
            itemCount: entriesCount,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemBuilder: (context, index) {
              final entry = viewModel.entries[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                child: ListTile(
                  leading: _buildRankBadge(index + 1),
                  title: Text(
                    entry.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${entry.score} points'),
                  trailing: Text(
                    'Rs.${entry.earnings} earned',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRankBadge(int position) {
    // Special badges for top 3
    if (position == 1) {
      return CircleAvatar(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.emoji_events, color: Colors.white),
      );
    } else if (position == 2) {
      return CircleAvatar(
        backgroundColor: Colors.grey.shade400,
        child: const Icon(Icons.emoji_events, color: Colors.white),
      );
    } else if (position == 3) {
      return CircleAvatar(
        backgroundColor: Colors.brown.shade300,
        child: const Icon(Icons.emoji_events, color: Colors.white),
      );
    } else {
      // Regular number badge for positions 4-20
      return CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Text(
          '$position',
          style: TextStyle(
            color: Colors.blue.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
