import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/onboarding/model.dart';
import 'package:referral_memoneet/widgets/custom_text_field.dart';

class BankDetailsStep extends StatelessWidget {
  const BankDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<OnboardingModel>(context, listen: false);

    return Form(
      key: model.bankFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: 'Account Holder Name',
            hint: 'Enter account holder name',
            controller: model.accountHolderNameController,
            isRequired: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Account Number',
            hint: 'Enter account number',
            controller: model.accountNumberController,
            isRequired: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Confirm Account Number',
            hint: 'Re-enter account number',
            isRequired: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirm account number is required';
              }
              if (value != model.accountNumberController?.text) {
                return 'Account numbers do not match';
              }
              return null;
            },
            controller: model.confirmAccountNumberController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'IFSC Code',
            hint: 'Enter IFSC code',
            controller: model.ifscCodeController,
            isRequired: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
              LengthLimitingTextInputFormatter(11),
            ],
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'IFSC code is required';
              }
              if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value)) {
                return 'Enter a valid IFSC code';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Bank Name',
            hint: 'Enter bank name',
            controller: model.bankNameController,
            isRequired: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Branch',
            hint: 'Enter branch name (optional)',
            controller: model.branchController,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
