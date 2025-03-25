import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/add_payment_method/model.dart';
import 'package:referral_memoneet/widgets/custom_button.dart';

class WithdrayUpiForm extends StatelessWidget {
  const WithdrayUpiForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<AddPaymentMethodViewModel>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'UPI Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),

        // UPI ID Field
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'UPI ID',
            hintText: 'name@upi',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => viewModel.upiId = value,
        ),

        const SizedBox(height: 32),

        CustomButton(
          text: 'Save Payment Method',
          onPressed: () async {
            await viewModel.saveUpiDetails();

            if (!context.mounted) return;
            context.pop();
          },
        ),
      ],
    );
  }
}
