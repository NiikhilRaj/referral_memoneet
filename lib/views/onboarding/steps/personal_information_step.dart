import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/onboarding/model.dart';
import 'package:referral_memoneet/widgets/custom_text_field.dart';

class PersonalInformationStep extends StatelessWidget {
  const PersonalInformationStep({super.key});
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<OnboardingModel>(context, listen: false);
    return SafeArea(
      child: Form(
        key: model.personalFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Name',
              hint: 'Enter your name',
              controller: model.nameController,
              isRequired: true,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email',
              hint: 'Enter your email address',
              controller: model.emailController,
              isRequired: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Phone Number',
              hint: 'Enter your phone number',
              controller: model.phoneController,
              isRequired: true,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                if (value.length != 10) {
                  return 'Phone number must be 10 digits';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
