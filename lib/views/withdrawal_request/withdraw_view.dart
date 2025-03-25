import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
    final viewModel = Provider.of<WithdrawalRequestModel>(context, listen: false);

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
          )
        ],
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () => viewModel.submitWithdrawalRequest(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: viewModel.isLoading
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
      body: ListView(
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
                Text(
                  '₹${viewModel.getAvailableBalance()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          StreamBuilder<List>(
            stream: viewModel.availablePaymentMethodsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: Text("Loading..."),
                );
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
              return ListView.builder(
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
                            paymentMethod['type'] == 'UPI'
                                ? Icons.account_balance_wallet
                                : Icons.account_balance,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(
                            paymentMethod['type'] == 'UPI'
                                ? 'UPI Transfer'
                                : 'Bank Transfer',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(paymentMethod['type'] == 'UPI'
                              ? 'Instant transfer to UPI ID'
                              : 'Transfer to bank account'),
                          trailing: Radio<String>(
                            value: paymentMethod['type'],
                            groupValue: viewModel.selectedPaymentMethod,
                            onChanged: (value) =>
                                viewModel.selectedPaymentMethod = value!,
                          ),
                          onTap: () => viewModel.selectedPaymentMethod =
                              paymentMethod['type'],
                        ),
                        // Only show amount input when this payment method is selected
                        if (viewModel.selectedPaymentMethod ==
                            paymentMethod['type'])
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Withdrawal Amount',
                                prefixText: '₹ ',
                                border: OutlineInputBorder(),
                                hintText: 'Enter amount to withdraw',
                              ),
                              onChanged: (value) =>
                                  viewModel.amount = double.parse(value),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
