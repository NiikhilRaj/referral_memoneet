import 'package:flutter/material.dart';
import 'package:referral_memoneet/views/onboarding/model.dart';

class AddPaymentMethodViewModel extends ChangeNotifier {
  String selectedPaymentMethod = 'UPI';
  BankDetails bankDetails = BankDetails(
    accountHolderName: 'john',
    accountNumber: '3456789',
    bankName: 'HDFC',
    branch: 'NYX',
    ifscCode: 'jytQWUKG8',
  );
  String upiId = '';

  double amount = 0;

  void setPaymentMethod(String value) {
    selectedPaymentMethod = value;
    notifyListeners();
  }

  Future<void> saveBankDetails() async {}
  Future<void> saveUpiDetails() async {}
}
