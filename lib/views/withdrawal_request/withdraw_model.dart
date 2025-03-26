import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/models/payment_method_model.dart';
import 'package:referral_memoneet/providers/firestore_provider.dart';
import 'package:referral_memoneet/providers/payments_provider.dart';
import 'package:referral_memoneet/views/onboarding/onboarding_model.dart';

class WithdrawalRequestModel extends ChangeNotifier {
  // Status of the withdrawal request
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;
  int _lastRefresh = DateTime.now().millisecondsSinceEpoch;

  TextEditingController amountController = TextEditingController();

  // Form data
  String _bankName = '';
  String _accountNumber = '';
  String _accountHolderName = '';
  String _ifscCode = '';
  String _selectedPaymentMethodId = '';

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  String get bankName => _bankName;
  String get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  String get ifscCode => _ifscCode;
  String get selectedPaymentMethodId => _selectedPaymentMethodId;
  int get lastRefresh => _lastRefresh;

  //TODO: make this functional:
  final bankDetails = BankDetails(
    accountHolderName: "accountHolderName",
    accountNumber: "accountNumber",
    ifscCode: "ifscCode",
    bankName: "bankName",
  );

  set lastRefresh(int value) {
    _lastRefresh = value;
    notifyListeners();
  }

  set bankName(String value) {
    _bankName = value;
    notifyListeners();
  }

  set accountNumber(String value) {
    _accountNumber = value;
    notifyListeners();
  }

  set accountHolderName(String value) {
    _accountHolderName = value;
    notifyListeners();
  }

  set ifscCode(String value) {
    _ifscCode = value;
    notifyListeners();
  }

  set selectedPaymentMethodId(String value) {
    _selectedPaymentMethodId = value;
    notifyListeners();
  }

  // Methods
  void resetForm() {
    amountController.clear();
    _bankName = '';
    _accountNumber = '';
    _accountHolderName = '';
    _ifscCode = '';
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();
  }

  Future<double> getAvailableBalance(BuildContext context) async {
    final db = Provider.of<FirestoreProvider>(context, listen: false);
    final balance = await db.fetchBalance();
    amountController.text = balance.toString();
    return balance;
  }

  Future<String> getActiveUpiID() async {
    return 'meow@wekj';
  }

  Future<List<PaymentMethodModel>> availablePaymentMethods(
    BuildContext context,
  ) async {
    final db = Provider.of<FirestoreProvider>(context, listen: false);
    final paymentMethods = await db.getPaymentMethods();
    return paymentMethods;
  }

  Future<bool> submitWithdrawalRequest(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final balance = await getAvailableBalance(context);
    if (balance < double.parse(amountController.text)) {
      _isLoading = false;
      _errorMessage = 'Insufficient balance';
      notifyListeners();
      return false;
    }

    try {
      final payments = Provider.of<PaymentsProvider>(context, listen: false);
      await payments.withdrawEarnings(
        amount: double.parse(amountController.text),
        email: "emai@ekrj.com",
        name: "xyz",
        contactNumber: "8947557456",
      );

      // If success
      _isLoading = false;
      _isSuccess = true;
      notifyListeners();
      if (context.mounted) context.pop();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  bool validateForm() {
    if (double.parse(amountController.text) <= 0) {
      _errorMessage = 'Amount should be greater than 0';
      notifyListeners();
      return false;
    }

    if (_bankName.isEmpty) {
      _errorMessage = 'Bank name is required';
      notifyListeners();
      return false;
    }

    if (_accountNumber.isEmpty) {
      _errorMessage = 'Account number is required';
      notifyListeners();
      return false;
    }

    if (_accountHolderName.isEmpty) {
      _errorMessage = 'Account holder name is required';
      notifyListeners();
      return false;
    }

    if (_ifscCode.isEmpty) {
      _errorMessage = 'IFSC code is required';
      notifyListeners();
      return false;
    }

    _errorMessage = null;
    notifyListeners();
    return true;
  }

  void refresh() {
    lastRefresh = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }
}
