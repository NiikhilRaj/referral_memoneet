import 'package:flutter/foundation.dart';

class TransactionHistoryModel with ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch transactions from a data source
  Future<void> fetchTransactions() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Replace with your actual API call
      // Simulating network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for demonstration
      _transactions = [
        Transaction(
          id: '1',
          amount: 1000.0,
          date: DateTime.now().subtract(const Duration(days: 1)),
          paymentMode: PaymentMode.upi,
          paymentDetail: 'user@okbank',
          status: TransactionStatus.completed,
        ),
        Transaction(
          id: '2',
          amount: 500.0,
          date: DateTime.now().subtract(const Duration(days: 2)),
          paymentMode: PaymentMode.bankAccount,
          paymentDetail: 'XXXX-XXXX-1234',
          status: TransactionStatus.completed,
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Add more business logic as needed
  void filterTransactionsByDate(DateTime startDate, DateTime endDate) {
    // Implementation for filtering
  }

  void filterTransactionsByPaymentMode(PaymentMode mode) {
    // Implementation for filtering
  }
}

class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  final PaymentMode paymentMode;
  final String paymentDetail; // UPI ID or Bank Account Number
  final TransactionStatus status;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.paymentMode,
    required this.paymentDetail,
    required this.status,
  });

  String get formattedDate => '${date.day}/${date.month}/${date.year}';
  String get formattedTime => '${date.hour}:${date.minute}';
}

enum PaymentMode {
  upi,
  bankAccount,
  card,
  cash,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  refunded,
}