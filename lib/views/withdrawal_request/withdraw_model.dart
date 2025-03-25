import 'package:flutter/foundation.dart';
import 'package:referral_memoneet/views/onboarding/onboarding_model.dart';

class WithdrawalRequestModel extends ChangeNotifier {
  // Status of the withdrawal request
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  // Form data
  double _amount = 0.0;
  String _bankName = '';
  String _accountNumber = '';
  String _accountHolderName = '';
  String _ifscCode = '';
  String _selectedPaymentMethod = 'UPI';

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  double get amount => _amount;
  String get bankName => _bankName;
  String get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  String get ifscCode => _ifscCode;
  String get selectedPaymentMethod => _selectedPaymentMethod;

  //TODO: make this functional:
  final bankDetails = BankDetails(
    accountHolderName: "accountHolderName",
    accountNumber: "accountNumber",
    ifscCode: "ifscCode",
    bankName: "bankName",
  );

  // Setters that notify listeners
  set amount(double value) {
    _amount = value;
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

  set selectedPaymentMethod(String value) {
    _selectedPaymentMethod = value;
    notifyListeners();
  }

  // Methods
  void resetForm() {
    _amount = 0.0;
    _bankName = '';
    _accountNumber = '';
    _accountHolderName = '';
    _ifscCode = '';
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();
  }

  Future<int> getAvailableBalance() async {
    return 7;
  }

  Future<String> getActiveUpiID() async {
    return 'meow@wekj';
  }

  Stream<List> availablePaymentMethodsStream() async* {
    await Future.delayed(Duration(seconds: 2));
    yield [
      {
        "type": "UPI",
      },
      {
        "type": "BANK",
      }
    ];
  }

  Future<bool> submitWithdrawalRequest() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Implement API call to submit withdrawal request

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // If success
      _isLoading = false;
      _isSuccess = true;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  bool validateForm() {
    if (_amount <= 0) {
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
}
