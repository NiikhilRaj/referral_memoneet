import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/transaction_history/transaction_model.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late TransactionHistoryModel _viewModel;
  
  @override
  void initState() {
    super.initState();
    _viewModel = TransactionHistoryModel();
    
    // Fetch transactions when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaction History'),
        ),
        body: Consumer<TransactionHistoryModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (model.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${model.error}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => model.fetchTransactions(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (model.transactions.isEmpty) {
              return const Center(
                child: Text(
                  'No transactions yet',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: model.transactions.length,
              itemBuilder: (context, index) {
                final transaction = model.transactions[index];
                return _buildTransactionCard(transaction);
              },
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildTransactionCard(Transaction transaction) {
    // Format date
    final dateFormat = DateFormat('MMM d, yyyy');
    final formattedDate = dateFormat.format(transaction.date);
    
    // Format amount
    final amountFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final formattedAmount = amountFormat.format(transaction.amount);
    
    // Determine status color
    Color statusColor;
    switch (transaction.status) {
      case TransactionStatus.completed:
        statusColor = Colors.green;
        break;
      case TransactionStatus.pending:
        statusColor = Colors.orange;
        break;
      case TransactionStatus.failed:
        statusColor = Colors.red;
        break;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedAmount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    transaction.status.name.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(formattedDate),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.payment, size: 16),
                const SizedBox(width: 8),
                Text(
                  transaction.paymentMode == PaymentMode.upi
                      ? 'UPI'
                      : 'Bank Transfer',
                ),
              ],
            ),
            if (transaction.paymentDetail.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      transaction.paymentDetail,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}