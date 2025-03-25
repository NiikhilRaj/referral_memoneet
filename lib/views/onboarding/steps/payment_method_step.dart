import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/onboarding/onboarding_model.dart';

class PaymentMethodStep extends StatelessWidget {
  const PaymentMethodStep({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<OnboardingModel>(
      builder: (context, model, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How would you like to receive your payments?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            RadioListTile<bool>(
              title: const Text('Bank Account'),
              value: false,
              groupValue: model.getUseUpi,
              onChanged: (value) {
                model.setUseUpi = value!;
              },
            ),
            RadioListTile<bool>(
              title: const Text('UPI'),
              value: true,
              groupValue: model.getUseUpi,
              onChanged: (value) {
                model.setUseUpi = value!;
              },
            ),
          ],
        );
      }
    );
  }
}
