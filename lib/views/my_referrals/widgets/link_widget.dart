import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/my_referrals/my_referrals_model.dart';

class ReferralLinkWidget extends StatelessWidget {
  const ReferralLinkWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MyReferralsModel viewModel =
        Provider.of<MyReferralsModel>(context, listen: false);

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
                  Clipboard.setData(
                      ClipboardData(text: viewModel.referralLink));
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
}
