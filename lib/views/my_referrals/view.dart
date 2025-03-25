import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../views/my_referrals/model.dart';

class MyReferralsScreen extends StatelessWidget {
  const MyReferralsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyReferralsModel(),
      child: MyReferralsView(),
    );
  }
}

class MyReferralsView extends StatelessWidget {
  const MyReferralsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Referrals'),
        elevation: 0,
      ),
      body: Consumer<MyReferralsModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserHeader(viewModel),
                  const SizedBox(height: 24),
                  _buildReferralStats(viewModel),
                  const SizedBox(height: 24),
                  _buildReferralLink(context, viewModel),
                  const SizedBox(height: 24),
                  _buildWithdrawalButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildUserHeader(MyReferralsModel viewModel) {
  return Row(
    children: [
      CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(viewModel.profilePictureUrl),
      ),
      const SizedBox(width: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hey, ${viewModel.userName}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Share your link and earn rewards!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildReferralStats(MyReferralsModel viewModel) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatItem('Total Referrals', '${viewModel.referralCount}',
                isLarge: true),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatItem('Total Earnings',
                'Rs.${viewModel.referralEarnings.toStringAsFixed(2)}',
                isLarge: true),
          ],
        ),
      ],
    ),
  );
}

Widget _buildStatItem(String label, String value, {bool isLarge = false}) {
  return Column(
    children: [
      Text(
        value,
        style: TextStyle(
          fontSize: isLarge ? 28 : 22,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: isLarge ? 16 : 14,
          color: Colors.grey.shade700,
        ),
      ),
    ],
  );
}

Widget _buildReferralLink(BuildContext context, MyReferralsModel viewModel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Your Referral Link',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                viewModel.referralLink,
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.blue),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: viewModel.referralLink));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Referral link copied!')),
                );
              },
            ),
            IconButton(
                icon: const Icon(Icons.share, color: Colors.blue),
                onPressed: () {}),
          ],
        ),
      ),
    ],
  );
}

Widget _buildWithdrawalButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const WithdrawalScreen(),
        //   ),
        // );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Withdraw Earnings',
        style: TextStyle(fontSize: 16),
      ),
    ),
  );
}
