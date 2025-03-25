import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/add_payment_method/model.dart';
import 'package:referral_memoneet/views/add_payment_method/widgets/bank_transfer_form.dart';
import 'package:referral_memoneet/views/add_payment_method/widgets/upi_form.dart';

class AddPaymentMethodWidget extends StatelessWidget {
  const AddPaymentMethodWidget({super.key});

  @override
  // Create a consumer with the new view model
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AddPaymentMethodViewModel(),
        child: AddPaymentMethodView());
  }
}

class AddPaymentMethodView extends StatelessWidget {
  const AddPaymentMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Payment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<AddPaymentMethodViewModel>(
          builder: (context, viewModel, child) {
        return Column(
          children: [
            // UPI Option
            RadioListTile<String>(
              title: const Text('UPI'),
              value: "UPI",
              groupValue: viewModel.selectedPaymentMethod,
              onChanged: (value) => viewModel.setPaymentMethod(value!),
            ),

            // Bank Transfer Option
            RadioListTile<String>(
              title: const Text('Bank Transfer'),
              value: "BANK",
              groupValue: viewModel.selectedPaymentMethod,
              onChanged: (value) => viewModel.setPaymentMethod(value!),
            ),

            const SizedBox(height: 20),

            // Payment Details Form
            Padding(
              padding: const EdgeInsets.all(16),
              child: viewModel.selectedPaymentMethod == "UPI"
                  ? WithdrayUpiForm()
                  : BankTransferForm(),
            ),

            const SizedBox(height: 30),
          ],
        );
      }),
    );
  }
}
