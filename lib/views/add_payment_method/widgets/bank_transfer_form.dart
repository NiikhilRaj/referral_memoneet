import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/add_payment_method/model.dart';
import 'package:referral_memoneet/widgets/custom_button.dart';

class BankTransferForm extends StatelessWidget {
  const BankTransferForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<AddPaymentMethodViewModel>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bank Account Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),

        // Account Holder Name Field
        TextFormField(
          initialValue: viewModel.bankDetails.accountHolderName,
          decoration: const InputDecoration(
            labelText: 'Account Holder Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => viewModel.bankDetails.accountHolderName = value,
        ),

        const SizedBox(height: 10),

        // Account Number Field
        TextFormField(
          initialValue: viewModel.bankDetails.accountNumber,
          decoration: const InputDecoration(
            labelText: 'Account Number',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => viewModel.bankDetails.accountNumber = value,
        ),

        const SizedBox(height: 10),

        // IFSC Code Field
        TextFormField(
          initialValue: viewModel.bankDetails.ifscCode,
          decoration: const InputDecoration(
            labelText: 'IFSC Code',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => viewModel.bankDetails.ifscCode = value,
        ),

        const SizedBox(height: 10),

        // Bank Name Field
        TextFormField(
          initialValue: viewModel.bankDetails.bankName,
          decoration: const InputDecoration(
            labelText: 'Bank Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => viewModel.bankDetails.bankName = value,
        ),

        const SizedBox(height: 32),

        CustomButton(
          text: 'Save Payment Method',
          onPressed: () async {
            await viewModel.saveBankDetails();

            if (!context.mounted) return;
            context.pop();
          },
        ),
      ],
    );
  }
}
