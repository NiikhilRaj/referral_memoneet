import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/onboarding/onboarding_model.dart';
import 'package:referral_memoneet/widgets/custom_text_field.dart';

class UpiDetailsStep extends StatelessWidget {
  const UpiDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<OnboardingModel>(context, listen: false);
    return Form(
      key: model.upiFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: 'UPI ID',
            hint: 'Enter your UPI ID (e.g., name@upi)',
            controller: model.upiIdController,
            isRequired: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'UPI ID is required';
              }
              if (!value.contains('@')) {
                return 'Enter a valid UPI ID';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'UPI App',
            hint: 'Enter UPI app name (optional)',
            controller: model.upiAppController,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
