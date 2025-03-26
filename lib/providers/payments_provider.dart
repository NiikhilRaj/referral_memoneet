import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentsProvider extends ChangeNotifier {
  final Razorpay _razorpay = Razorpay();

  PaymentsProvider();

  void _handlePaymentSuccess(
    PaymentSuccessResponse response,
    double amount,
  ) async {
    // Handle payment success
    debugPrint('Payment success: ${response.paymentId}');
    final db = FirebaseFirestore.instance;
    await db
        .collection(
          'partners/${FirebaseAuth.instance.currentUser!.uid}/transactions',
        )
        .doc()
        .set({
          'amount': amount,
          'data': response.data,
          'status': 'success',
          'timestamp': FieldValue.serverTimestamp(),
        });

    final amtDoc =
        await db
            .collection('partners')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    print(amtDoc.data());
    final currentAmt = double.parse(amtDoc['referralEarnings'].toString());

    await db
        .collection('partners')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'referralEarnings': currentAmt - amount});

    notifyListeners();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
    debugPrint('Payment error: ${response.code} - ${response.message}');
    notifyListeners();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    debugPrint('External wallet: ${response.walletName}');
    notifyListeners();
  }

  Future<void> withdrawEarnings({
    required double amount,
    required String email,
    required String name,
    required String contactNumber,
  }) async {
    try {
      Map<String, dynamic> options = {
        'key': 'rzp_test_iCGA6S5JP4JcCD',
        'amount': (amount * 100),
        'name': 'Earnings Withdrawal',
        'description': 'Withdrawal of referral earnings',
        'prefill': {'contact': contactNumber, 'email': email, 'name': name},
      };

      _razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
        (response) => _handlePaymentSuccess(response, amount),
      );
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

      await _razorpay.open(options);
    } catch (e) {
      debugPrint('Error withdrawing earnings: $e');
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
