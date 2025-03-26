import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/models/upi_model.dart';
import 'package:referral_memoneet/providers/firestore_provider.dart';
import 'package:referral_memoneet/models/bank_details_model.dart' as bank;

class AddPaymentMethodViewModel extends ChangeNotifier {
  String selectedPaymentMethod = 'UPI';
  bank.BankDetails bankDetails = bank.BankDetails(
    accountHolderName: '',
    accountNumber: '',
    bankName: '',
    branch: '',
    ifscCode: '',
  );
  String upiId = '';

  double amount = 0;

  void setPaymentMethod(String value) {
    selectedPaymentMethod = value;
    notifyListeners();
  }

  Future<void> saveBankDetails(
    BuildContext context,
    bank.BankDetails details,
  ) async {
    final db = Provider.of<FirestoreProvider>(context, listen: false);

    await db.addPartnerPaymentMethod(bank: details);
  }

  Future<void> saveUpiDetails(BuildContext context, UpiModel details) async {
    final db = Provider.of<FirestoreProvider>(context, listen: false);

    await db.addPartnerPaymentMethod(upi: details);
  }
}
