import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/transaction_history/transaction_model.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionHistoryModel(),
      child: const TransactionHistoryView(),
    );
  }
}

class TransactionHistoryView extends StatefulWidget {
  const TransactionHistoryView({super.key});

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView> {
  @override
  void initState() {
    super.initState();
    // Fetch transactions after the widget is inserted in the tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionHistoryModel>(context, listen: false)
          .fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TransactionHistoryModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.transactions.isEmpty
              ? const Center(child: Text('No transaction history found'))
              : ListView.builder(
                  itemCount: viewModel.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = viewModel.transactions[index];
                    return TransactionCard(transaction: transaction);
                  },
                ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${transaction.amount}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatDateTime(transaction.date),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  transaction.paymentMode == PaymentMode.upi
                      ? Icons.account_balance_wallet
                      : Icons.account_balance,
                  color: Colors.blue,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  transaction.paymentMode == PaymentMode.upi
                      ? 'UPI'
                      : 'Bank Account',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              transaction.paymentMode == PaymentMode.upi
                  ? 'UPI ID: ${transaction.paymentDetail}'
                  : 'Account No: ${transaction.paymentDetail}',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
