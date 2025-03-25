import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:referral_memoneet/providers/firestore_provider.dart';

class RedirectController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreProvider _firestoreProvider;
  
  bool _isLoading = true;
  bool _needsOnboarding = false;
  
  RedirectController(this._firestoreProvider) {
    _init();
  }
  
  bool get isLoading => _isLoading;
  bool get needsOnboarding => _needsOnboarding;
  
  Future<void> _init() async {
    _auth.authStateChanges().listen((user) async {
      _isLoading = true;
      notifyListeners();
      
      if (user != null) {
        await _checkOnboardingStatus(user.uid);
      } else {
        _needsOnboarding = false;
      }
      
      _isLoading = false;
      notifyListeners();
    });
  }
  
  Future<void> _checkOnboardingStatus(String userId) async {
    try {
      final userData = await _firestoreProvider.getPartnerDetails(userId);
      _needsOnboarding = userData == null || userData['isOnboardingComplete'] != true;
    } catch (e) {
      // Default to requiring onboarding if there's an error
      _needsOnboarding = true;
    }
  }
  
  Future<void> refreshOnboardingStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      _isLoading = true;
      notifyListeners();
      
      await _checkOnboardingStatus(user.uid);
      
      _isLoading = false;
      notifyListeners();
    }
  }
}