import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/models/payment_method_model.dart';
import 'package:referral_memoneet/models/upi_model.dart';
import 'package:referral_memoneet/providers/dynamic_links_provider.dart';
import 'package:referral_memoneet/views/onboarding/onboarding_model.dart';
import 'package:referral_memoneet/models/bank_details_model.dart' as bank;
import 'package:referral_memoneet/views/transaction_history/transaction_model.dart'
    as txnModel;

class FirestoreProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // PARTNER OPERATIONS

  // Create or update partner profile
  // Update createPartnerProfile method to accept isOnboardingComplete parameter

  Future<void> createPartnerProfile(
    BuildContext context, {
    required String userId,
    required String name,
    required String email,
    String? referralCode,
    bool isOnboardingComplete = false, // Added parameter with default value
  }) async {
    try {
      debugPrint('Creating partner profile for userId: $userId');
      final links = Provider.of<DynamicLinksProvider>(context, listen: false);
      // final link = await links.createPartnerReferralLink(partnerId: userId);
      final link = "https://google.com/";
      final userData = {
        'partnerId': userId,
        'name': name,
        'email': email,
        'referralCount': 0,
        'referralEarnings': 0.0,
        'referralLink': link,
        'isOnboardingComplete': isOnboardingComplete, // Use the parameter value
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // First check if document already exists
      final docSnapshot =
          await _firestore.collection('partners').doc(userId).get();

      if (!docSnapshot.exists) {
        debugPrint('Partner document does not exist, creating new one');
        await _firestore.collection('partners').doc(userId).set(userData);
        debugPrint('Partner profile created successfully');
      } else {
        debugPrint('Partner document already exists, updating with new data');
        await _firestore.collection('partners').doc(userId).update({
          'name': name,
          'email': email,
          'isOnboardingComplete': isOnboardingComplete,
          'referralLink': link,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Process referral code if provided
      if (referralCode != null && referralCode.isNotEmpty) {
        debugPrint('Processing referral code: $referralCode');
        await _processReferralCode(userId, referralCode);
      }
    } catch (e) {
      debugPrint('Error creating partner profile: $e');
      rethrow;
    }
  }

  Future<void> createStudentProfile(
    BuildContext context, {
    required String userId,
    required String name,
    required String email,
    String? referralCode,
    bool isOnboardingComplete = false, // Added parameter with default value
  }) async {
    try {
      debugPrint('Creating partner profile for userId: $userId');

      final userData = {
        'id': userId,
        'name': name,
        'email': email,
        'isOnboardingComplete': isOnboardingComplete, // Use the parameter value
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // First check if document already exists
      final docSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (!docSnapshot.exists) {
        debugPrint('User document does not exist, creating new one');
        await _firestore.collection('users').doc(userId).set(userData);
        debugPrint('User profile created successfully');
      } else {
        debugPrint('User document already exists, updating with new data');
        await _firestore.collection('users').doc(userId).update(userData);
      }

      // Process referral code if provided
      if (referralCode != null && referralCode.isNotEmpty) {
        debugPrint('Processing referral code: $referralCode');
        await _processReferralCode(userId, referralCode);
      }
    } catch (e) {
      debugPrint('Error creating partner profile: $e');
      rethrow;
    }
  }

  // Add helper method for processing referral codes
  Future<void> _processReferralCode(
    String newUserId,
    String referralCode,
  ) async {
    try {
      // Find the referrer's document
      final referrersQuery =
          await _firestore
              .collection('partners')
              .where('partnerId', isEqualTo: referralCode)
              .limit(1)
              .get();

      if (referrersQuery.docs.isNotEmpty) {
        final referrerId = referrersQuery.docs.first.id;
        debugPrint('Found referrer with ID: $referrerId');

        // Update referrer's stats
        await _firestore.collection('partners').doc(referrerId).update({
          'referralCount': FieldValue.increment(1),
          'referralEarnings': FieldValue.increment(100), // ₹100 per referral
        });

        // Create referral record
        await _firestore.collection('referrals').add({
          'referralId': _firestore.collection('referrals').doc().id,
          'referredByPartnerId': referralCode,
          'studentId': newUserId,
          'date': FieldValue.serverTimestamp(),
          'status': 'completed',
        });

        debugPrint('Referral processed successfully');
      } else {
        debugPrint('No referrer found with code: $referralCode');
      }
    } catch (e) {
      debugPrint('Error processing referral: $e');
    }
  }

  // Save onboarding data
  Future<bool> saveOnboardingData(OnboardingModel model) async {
    if (currentUser == null) return false;

    try {
      final userId = currentUser!.uid;
      final data = {
        'name': model.name,
        'email': model.email,
        'phoneNumber': model.phoneNumber,
        'isOnboardingComplete': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add payment information based on selected method
      if (model.getUseUpi && model.upiDetails != null) {
        data['paymentMethod'] = 'upi';
        data['upiDetails'] = model.upiDetails!.toMap();
      } else if (model.bankDetails != null) {
        data['paymentMethod'] = 'bank';
        data['bankDetails'] = model.bankDetails!.toMap();
      }

      await _firestore.collection('partners').doc(userId).update(data);

      return true;
    } catch (e) {
      debugPrint('Error saving onboarding data: $e');
      return false;
    }
  }

  // Get partner details
  Future<Map<String, dynamic>?> getPartnerDetails(String partnerId) async {
    try {
      final docSnapshot =
          await _firestore.collection('partners').doc(partnerId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      debugPrint('Error getting partner details: $e');
      rethrow;
    }
  }

  // Update partner payment method
  Future<void> addPartnerPaymentMethod({
    UpiModel? upi,
    bank.BankDetails? bank,
  }) async {
    try {
      if (currentUser == null) {
        throw Exception('User not logged in');
      }
      final partnerId = currentUser!.uid;

      Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (upi != null) {
        updateData = upi.toMap();
      } else if (bank != null) {
        updateData = bank.toMap();
      }

      final doc =
          _firestore.collection('partners/$partnerId/payment_methods').doc();
      updateData['method_id'] = doc.id;
      await doc.set(updateData);
    } catch (e) {
      debugPrint('Error updating payment method: $e');
      rethrow;
    }
  }

  // REFERRAL OPERATIONS

  // Create new referral
  Future<void> createReferral({
    required String referredByPartnerId,
    required String studentEmail,
    required String studentId,
  }) async {
    try {
      // Create a new referral document
      final referralRef = _firestore.collection('referrals').doc();

      await referralRef.set({
        'referralId': referralRef.id,
        'referredByPartnerId': referredByPartnerId,
        'studentEmail': studentEmail,
        'studentId': studentId,
        'date': FieldValue.serverTimestamp(),
        'status': 'completed', // or 'pending' if you have verification process
      });

      // Update partner statistics
      await _firestore.collection('partners').doc(referredByPartnerId).update({
        'referralCount': FieldValue.increment(1),
        'referralEarnings': FieldValue.increment(
          100,
        ), // Assuming ₹100 per referral
      });

      // Update leaderboards
      await updateLeaderboards(referredByPartnerId);
    } catch (e) {
      debugPrint('Error creating referral: $e');
      rethrow;
    }
  }

  // Get referrals by partner
  Future<List<Map<String, dynamic>>> getPartnerReferrals(
    String partnerId,
  ) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('referrals')
              .where('referredByPartnerId', isEqualTo: partnerId)
              .orderBy('date', descending: true)
              .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error getting partner referrals: $e');
      rethrow;
    }
  }

  // TRANSACTION OPERATIONS

  // Add this method to your FirestoreProvider class
  Future<List<txnModel.Transaction>> getPartnerTransactions(
    String partnerId,
  ) async {
    try {
      debugPrint('Fetching transactions for partner: $partnerId');

      // Query transactions where partnerId matches
      final querySnapshot =
          await _firestore
              .collection('partners/$partnerId/transactions')
              .orderBy('timestamp', descending: true) // Most recent first
              .get();

      // Map the query results to Transaction objects
      final transactions =
          querySnapshot.docs.map((doc) {
            final data = doc.data();

            // Convert Firestore timestamp to DateTime
            final timestamp = (data['timestamp'] as Timestamp).toDate();

            // Convert payment mode string to enum
            txnModel.PaymentMode paymentMode;
            if (data['paymentMode'] == 'upi') {
              paymentMode = txnModel.PaymentMode.upi;
            } else {
              paymentMode = txnModel.PaymentMode.bankAccount;
            }

            // Create and return Transaction object
            return txnModel.Transaction(
              id: doc.id,
              amount: (data['amount'] as num).toDouble(),
              date: timestamp,
              paymentMode: paymentMode,
              paymentDetail: data['paymentDetail'] ?? '',
              status: txnModel.TransactionStatus.fromString(data['status']),
            );
          }).toList();

      debugPrint('Found ${transactions.length} transactions');
      return transactions;
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      rethrow;
    }
  }

  // Add this method to create withdrawal transactions
  Future<void> createWithdrawalTransaction({
    required String partnerId,
    required double amount,
    required txnModel.PaymentMode paymentMode,
    String? paymentDetail,
  }) async {
    try {
      // Get partner details to include payment information
      final partnerData = await getPartnerDetails(partnerId);
      if (partnerData == null) {
        throw Exception('Partner profile not found');
      }

      String paymentDetailString = '';

      // Get appropriate payment details based on the payment mode
      if (paymentMode == txnModel.PaymentMode.upi) {
        if (partnerData['upiDetails'] != null) {
          paymentDetailString = partnerData['upiDetails']['upiId'] ?? '';
        }
      } else {
        if (partnerData['bankDetails'] != null) {
          final bank = partnerData['bankDetails'];
          paymentDetailString =
              '${bank['accountHolderName']} - ${bank['accountNumber']} (${bank['ifscCode']})';
        }
      }

      // Override with specific payment detail if provided
      if (paymentDetail != null && paymentDetail.isNotEmpty) {
        paymentDetailString = paymentDetail;
      }

      // Create transaction document
      final transactionRef = _firestore.collection('transactions').doc();

      await transactionRef.set({
        'transactionId': transactionRef.id,
        'partnerId': partnerId,
        'amount': amount,
        'timestamp': FieldValue.serverTimestamp(),
        'paymentMode':
            paymentMode == txnModel.PaymentMode.upi ? 'upi' : 'bankAccount',
        'paymentDetail': paymentDetailString,
        'status': 'pending', // Start as pending
        'type': 'withdrawal',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update partner's balance
      await _firestore.collection('partners').doc(partnerId).update({
        'referralEarnings': FieldValue.increment(-amount),
        'pendingWithdrawals': FieldValue.increment(amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('Created withdrawal transaction: ${transactionRef.id}');
    } catch (e) {
      debugPrint('Error creating withdrawal transaction: $e');
      rethrow;
    }
  }

  // Helper method to convert string to PaymentMode enum
  txnModel.PaymentMode _getPaymentModeFromString(String mode) {
    if (mode == 'upi') {
      return txnModel.PaymentMode.upi;
    }
    return txnModel.PaymentMode.bankAccount;
  }

  // LEADERBOARD OPERATIONS

  // Update leaderboards when a referral is added
  Future<void> updateLeaderboards(String partnerId) async {
    try {
      // Get current time to determine which leaderboards to update
      final now = DateTime.now();
      final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day - now.weekday + 1,
      );
      final startOfMonth = DateTime(now.year, now.month, 1);

      // Update weekly leaderboard
      await _updateLeaderboard(partnerId, 'weekly', startOfWeek);

      // Update monthly leaderboard
      await _updateLeaderboard(partnerId, 'monthly', startOfMonth);
    } catch (e) {
      debugPrint('Error updating leaderboards: $e');
      rethrow;
    }
  }

  // Helper method to update a specific leaderboard
  Future<void> _updateLeaderboard(
    String partnerId,
    String period,
    DateTime startDate,
  ) async {
    final partnerDoc =
        await _firestore.collection('partners').doc(partnerId).get();
    final partnerData = partnerDoc.data();

    if (partnerData == null) return;

    // Get referrals for this partner within the period
    final periodStart = Timestamp.fromDate(startDate);

    final referralsQuery =
        await _firestore
            .collection('referrals')
            .where('referredByPartnerId', isEqualTo: partnerId)
            .where('date', isGreaterThanOrEqualTo: periodStart)
            .get();

    final referralCount = referralsQuery.docs.length;
    final earnings = referralCount * 100; // Assuming ₹100 per referral

    // Update the leaderboard entry
    await _firestore
        .collection('leaderboards')
        .doc(period)
        .collection('entries')
        .doc(partnerId)
        .set({
          'partnerId': partnerId,
          'name': partnerData['name'],
          'score': referralCount,
          'earnings': earnings,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  // Get leaderboard entries
  Future<List<Map<String, dynamic>>> getLeaderboard(String period) async {
    try {
      Query<Map<String, dynamic>> querySnapshot = _firestore.collection(
        'referrals',
      );

      if (period == "weekly") {
        querySnapshot = querySnapshot.where(
          'date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(
            DateTime.now().subtract(Duration(days: 7)),
          ),
        );
      } else if (period == "monthly") {
        querySnapshot = querySnapshot.where(
          'date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(
            DateTime.now().subtract(Duration(days: 30)),
          ),
        );
      }
      querySnapshot.orderBy('date', descending: true);

      final dbData = await querySnapshot.get();
      Map<String, dynamic> result = {};

      for (int i = 0; i < dbData.docs.length; i++) {
        final doc = dbData.docs[i];
        final data = doc.data();
        if (!result.containsKey(data['referredByPartnerId'])) {
          result[data['referredByPartnerId']] = {
            'referralCount': 1,
            'earnings': 35,
          };
        } else {
          result[data['referredByPartnerId']]['referralCount']++;
          result[data['referredByPartnerId']]['earnings'] += 35;
        }
      }

      List<MapEntry<String, dynamic>> entriesList = result.entries.toList();

      entriesList.sort((a, b) {
        return b.value['earnings'].compareTo(a.value['earnings']);
      });

      result.clear();
      for (var item in entriesList) {
        result[item.key] = Map.from(item.value);
        final userData = await getPartnerDetails(item.key);
        result[item.key]['name'] = userData?['name'];
      }

      return entriesList.map((entry) {
        return {
          'partnerId': entry.key,
          'score': entry.value['referralCount'],
          'earnings': entry.value['earnings'],
          'name': result[entry.key]['name'],
        };
      }).toList();
    } catch (e) {
      debugPrint('Error getting leaderboard: $e');
      rethrow;
    }
  }

  // Get current user's rank and details in the leaderboard
  Future<Map<String, dynamic>?> getCurrentUserLeaderboardPosition(
    String period,
  ) async {
    if (currentUser == null) return null;

    try {
      final userDoc =
          await _firestore
              .collection('leaderboards')
              .doc(period)
              .collection('entries')
              .doc(currentUser!.uid)
              .get();

      if (!userDoc.exists) return null;

      // Get all entries with higher score
      final higherScoresQuery =
          await _firestore
              .collection('leaderboards')
              .doc(period)
              .collection('entries')
              .where('score', isGreaterThan: userDoc.data()!['score'])
              .get();

      // Calculate rank (add 1 because ranks are 1-based)
      final rank = higherScoresQuery.docs.length + 1;

      final userData = userDoc.data()!;
      userData['rank'] = rank;
      return userData;
    } catch (e) {
      debugPrint('Error getting user leaderboard position: $e');
      return null;
    }
  }

  Future<bool> checkPartnerDocumentExists(String userId) async {
    try {
      final docSnapshot =
          await _firestore.collection('partners').doc(userId).get();
      final exists = docSnapshot.exists;
      debugPrint('Partner document for $userId exists: $exists');
      return exists;
    } catch (e) {
      debugPrint('Error checking document: $e');
      return false; // Return false, not null
    }
  }

  Future<double> fetchBalance() async {
    if (currentUser == null) return 0.0;

    try {
      final docSnapshot =
          await _firestore.collection('partners').doc(currentUser!.uid).get();
      final data = docSnapshot.data();
      if (data != null) {
        return data['referralEarnings'] ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      debugPrint('Error fetching balance: $e');
      return 0.0;
    }
  }

  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    if (currentUser == null) return [];

    try {
      final docSnapshot =
          await _firestore
              .collection('partners/${currentUser!.uid}/payment_methods')
              .get();
      final data =
          docSnapshot.docs.map((doc) {
            if (doc.data()['type'] == 'UPI') {
              return PaymentMethodModel(
                type: 'UPI',
                methodId: doc.data()['method_id'],

                upi: UpiModel.fromJson(doc.data()),
              );
            } else {
              return PaymentMethodModel(
                type: 'BANK',
                methodId: doc.data()['method_id'],
                bankDetails: BankDetails.fromMap(doc.data()),
              );
            }
          }).toList();
      return data;
    } catch (e) {
      debugPrint('Error fetching payment methods: $e');
      rethrow;
    }
  }
}
