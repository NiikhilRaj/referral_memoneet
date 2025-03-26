import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/providers/auth_provider.dart';
import 'package:referral_memoneet/providers/firestore_provider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:clipboard/clipboard.dart';
import 'package:referral_memoneet/views/transaction_history/transaction_model.dart'
    as transaction;

class MyReferralsModel extends ChangeNotifier {
  String _userName = "";
  String _profilePictureUrl = "https://picsum.photos/200/300";
  String _referralLink = "";
  int _referralCount = 0;
  double _referralEarnings = 0.0;
  bool _isLoading = false;
  bool _error = false;
  String _errorMessage = "";

  // Getters
  String get userName => _userName;
  String get profilePictureUrl => _profilePictureUrl;
  String get referralLink => _referralLink;
  int get referralCount => _referralCount;
  double get referralEarnings => _referralEarnings;
  bool get isLoading => _isLoading;
  bool get hasError => _error;
  String get errorMessage => _errorMessage;

  // Initialize with user data
  Future<void> initialize(BuildContext context) async {
    try {
      _setLoading(true);

      final firestoreProvider = Provider.of<FirestoreProvider>(
        context,
        listen: false,
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.currentUser == null) {
        debugPrint('User not logged in');
        return;
      }
      final userId = authProvider.currentUser!.uid;

      // Fetch partner details from Firestore
      final partnerData = await firestoreProvider.getPartnerDetails(userId);

      if (partnerData != null) {
        _userName = partnerData['name'] ?? "User";
        _profilePictureUrl =
            partnerData['photoURL'] ?? "https://picsum.photos/200/300";
        _referralCount = partnerData['referralCount'] ?? 0;
        _referralEarnings = double.parse(
          (partnerData['referralEarnings'] ?? 0).toString(),
        );

        // Generate referral link if not already available
        if (_referralLink.isEmpty) {
          await generateReferralLink(userId);
        }
      } else {
        _setError("Could not find user data. Please try again later.");
        return;
      }

      _setLoading(false);
    } catch (e) {
      _setError("Failed to load referral data: ${e.toString()}");
    }
  }

  // Copy referral link to clipboard
  Future<bool> copyReferralLink() async {
    try {
      await FlutterClipboard.copy(_referralLink);
      return true;
    } catch (e) {
      _setError("Failed to copy link: ${e.toString()}");
      return false;
    }
  }

  // Generate or refresh the referral link
  Future<void> generateReferralLink(String userId) async {
    try {
      _setLoading(true);

      // Create a dynamic link using Firebase Dynamic Links
      final dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse(
          'https://referralmemoneet.page.link/signup?ref=$userId',
        ),
        uriPrefix: 'https://referralmemoneet.page.link',
        androidParameters: const AndroidParameters(
          packageName: 'com.memoneet.referral_app',
        ),
        iosParameters: const IOSParameters(
          bundleId: 'com.example.referralMemoneet',
          appStoreId: '123456789',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Join MemoNeet',
          description: 'Sign up using my referral link!',
        ),
      );

      final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
        dynamicLinkParams,
        shortLinkType: ShortDynamicLinkType.unguessable,
      );

      _referralLink = dynamicLink.shortUrl.toString();

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError("Failed to generate referral link: ${e.toString()}");
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    _error = false;
    notifyListeners();
  }

  void _setError(String message) {
    _error = true;
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  // Reset error state
  void clearError() {
    _error = false;
    _errorMessage = "";
    notifyListeners();
  }

  // Fetch user's referrals
  Future<List<Map<String, dynamic>>> fetchUserReferrals(
    BuildContext context,
    String userId,
  ) async {
    try {
      final firestoreProvider = Provider.of<FirestoreProvider>(
        context,
        listen: false,
      );
      return await firestoreProvider.getPartnerReferrals(userId);
    } catch (e) {
      _setError("Failed to fetch referrals: ${e.toString()}");
      return [];
    }
  }

  // Request withdrawal
  Future<bool> requestWithdrawal(
    BuildContext context,
    String userId,
    double amount,
    String paymentMethod,
    String paymentDetails,
  ) async {
    try {
      if (amount > _referralEarnings) {
        _setError("Insufficient balance for withdrawal");
        return false;
      }

      _setLoading(true);

      final firestoreProvider = Provider.of<FirestoreProvider>(
        context,
        listen: false,
      );

      // Convert payment method string to enum
      final paymentMode =
          paymentMethod == 'UPI'
              ? transaction.PaymentMode.upi
              : transaction.PaymentMode.bankAccount;

      await firestoreProvider.createWithdrawalTransaction(
        partnerId: userId,
        amount: amount,
        paymentMode: paymentMode,
        paymentDetail: paymentDetails,
      );

      // Update local data to reflect the withdrawal
      _referralEarnings -= amount;

      _setLoading(false);
      return true;
    } catch (e) {
      _setError("Withdrawal request failed: ${e.toString()}");
      return false;
    }
  }
}
