import 'package:flutter/material.dart';
import 'package:referral_memoneet/views/my_referrals/my_referrals_model.dart';

class ReferralStatsWidget extends StatelessWidget {
  final MyReferralsModel viewModel;

  const ReferralStatsWidget({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
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
              _buildStatItem(
                'Total Referrals',
                '${viewModel.referralCount}',
                isLarge: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem(
                'Balance Earnings',
                'Rs.${viewModel.referralEarnings.toStringAsFixed(2)}',
                isLarge: true,
              ),
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
}
