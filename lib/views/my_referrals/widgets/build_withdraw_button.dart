import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:referral_memoneet/views/my_referrals/my_referrals_model.dart';

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
            context.push('/withdraw');
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
