import 'package:flutter/foundation.dart';
import 'package:referral_memoneet/providers/auth_provider.dart';
import 'package:referral_memoneet/providers/firestore_provider.dart';

enum PaymentMode { upi, bankAccount }

enum TransactionStatus {
  pending("pending"),
  success("success"),
  failed("failed");

  final String savedAs;
  const TransactionStatus(this.savedAs);

  static TransactionStatus fromString(String status) {
    return TransactionStatus.values.firstWhere((e) => e.savedAs == status);
  }
}

class TransactionHistoryModel with ChangeNotifier {
  final FirestoreProvider _firestoreProvider = FirestoreProvider();
  final AuthProvider _authProvider = AuthProvider();

  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch transactions from Firestore
  Future<void> fetchTransactions() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final partnerId = _authProvider.currentUser?.uid;
      if (partnerId == null) {
        _error = "User not authenticated";
        _isLoading = false;
        notifyListeners();
        return;
      }

      _transactions = await _firestoreProvider.getPartnerTransactions(
        partnerId,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add filter methods as needed
  void filterTransactionsByDate(DateTime startDate, DateTime endDate) {
    // Implementation will filter the already fetched transactions
  }

  void filterTransactionsByPaymentMode(PaymentMode mode) {
    // Implementation will filter the already fetched transactions
  }
}

class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  final PaymentMode paymentMode;
  final String paymentDetail;
  final TransactionStatus status;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.paymentMode,
    required this.paymentDetail,
    required this.status,
  });
}
