import 'package:flutter/material.dart';
import 'package:referral_memoneet/views/my_referrals/my_referrals_model.dart';

class UserHeaderWidget extends StatelessWidget {
  const UserHeaderWidget({
    required this.viewModel,
    super.key,
  });

  final MyReferralsModel viewModel;

  @override
  Widget build(BuildContext context) {
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
              'Hey ${viewModel.userName}!',
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
}
