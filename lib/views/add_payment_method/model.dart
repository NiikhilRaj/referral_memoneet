import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/providers/firestore_provider.dart';
import 'package:referral_memoneet/models/bank_details_model.dart';

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

  Future<void> saveBankDetails(BuildContext context) async {
    final firebaseProvider =
        Provider.of<FirestoreProvider>(context, listen: false);
  }

  Future<void> saveUpiDetails() async {}
}
