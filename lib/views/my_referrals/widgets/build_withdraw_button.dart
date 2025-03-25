import 'package:flutter/material.dart';
import 'package:referral_memoneet/views/my_referrals/model.dart';

class BuildWithdrawButton extends StatelessWidget {
  const BuildWithdrawButton({required this.viewModel, super.key});

  final MyReferralsModel viewModel;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (viewModel.referralEarnings >= 10) {
            Navigator.pushNamed(
              context,
              '/withdrawal-request',
              arguments: viewModel.referralEarnings,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('You need at least Rs.100 to withdraw earnings')),
            );
          }
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
}
