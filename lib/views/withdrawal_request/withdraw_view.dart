import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/models/payment_method_model.dart';
import 'withdraw_model.dart';

class WithdrawalRequestScreen extends StatelessWidget {
  const WithdrawalRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WithdrawalRequestModel>(
      create: (_) => WithdrawalRequestModel(),
      child: const WithdrawalRequestView(),
    );
  }
}

class WithdrawalRequestView extends StatelessWidget {
  const WithdrawalRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WithdrawalRequestModel>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdrawal Request'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => context.push('/add_payment_method'),
              child: Icon(Icons.add_circle_outline_rounded),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: ElevatedButton(
                onPressed:
                    viewModel.isLoading
                        ? null
                        : () => viewModel.submitWithdrawalRequest(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child:
                    viewModel.isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                          'Withdraw',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => viewModel.refresh(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Available Balance Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Balance',
                    style: TextStyle(fontSize: 16),
                  ),

                  FutureBuilder(
                    future: viewModel.getAvailableBalance(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return CircularProgressIndicator.adaptive();
                      }
                      return Text(
                        '₹${snapshot.data}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<PaymentMethodModel>>(
              future: viewModel.availablePaymentMethods(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: Text("Loading..."));
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "No payment methods available",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/add_payment_method'),
                          icon: const Icon(Icons.add),
                          label: const Text("Add Payment Method"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Consumer<WithdrawalRequestModel>(
                  key: ValueKey('Refreshed-on-${viewModel.lastRefresh}'),
                  builder: (context, model, child) {
                    return ListView.builder(
                      key: ValueKey('LV-Refreshed-on-${viewModel.lastRefresh}'),

                      itemCount: snapshot.data?.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final paymentMethod = snapshot.data![index];

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  paymentMethod.type == 'UPI'
                                      ? Icons.account_balance_wallet
                                      : Icons.account_balance,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Text(
                                  paymentMethod.type == 'UPI'
                                      ? 'UPI Transfer'
                                      : 'Bank Transfer',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  paymentMethod.type == 'UPI'
                                      ? "Recieve Payment to ${paymentMethod.upi!.upiId}"
                                      : 'Transfer to ${paymentMethod.bankDetails!.accountNumber}',
                                ),
                                trailing: Radio<String>(
                                  value: paymentMethod.methodId,
                                  groupValue: model.selectedPaymentMethodId,
                                  onChanged:
                                      (value) =>
                                          model.selectedPaymentMethodId =
                                              value!,
                                ),
                                onTap:
                                    () =>
                                        model.selectedPaymentMethodId =
                                            paymentMethod.methodId,
                              ),
                              // Only show amount input when this payment method is selected
                              if (model.selectedPaymentMethodId ==
                                  paymentMethod.methodId)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Withdrawal Amount',
                                      prefixText: '₹ ',
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter amount to withdraw',
                                    ),
                                    controller: model.amountController,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
