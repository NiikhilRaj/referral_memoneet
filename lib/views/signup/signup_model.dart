import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/providers/firestore_provider.dart';

enum UserType { student, partner }

class SignupViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserType _userType = UserType.student;
  bool _isLogin = true;
  bool _isPasswordVisible = false;
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _name = ''; // Added name field
  String? _errorMessage;
  bool _isLoading = false;

  // Controllers
  final TextEditingController nameController =
      TextEditingController(); // Added name controller
  final TextEditingController referralCodeController = TextEditingController();

  // Constructor
  SignupViewModel({String? referralCode}) {
    if (referralCode != null && referralCode.isNotEmpty) {
      referralCodeController.text = referralCode;
      _isLogin = false;
    }
  }

  // Getters
  UserType get userType => _userType;
  bool get isLogin => _isLogin;
  bool get isPasswordVisible => _isPasswordVisible;
  String get name => _name; // Added name getter
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Setters
  void setUserType(UserType type) {
    _userType = type;
    _errorMessage = null;
    notifyListeners();
  }

  void toggleAuthMode() {
    _isLogin = !_isLogin;
    _errorMessage = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email.trim();
  }

  void setPassword(String password) {
    _password = password;
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
  }

  void setName(String name) {
    // Added name setter
    _name = name.trim();
  }

  Future<void> submitForm(UserType type, BuildContext context) async {
    // Reset error message
    _errorMessage = null;

    try {
      // Validate inputs
      if (_email.isEmpty || _password.isEmpty) {
        _errorMessage = 'Please enter email and password';
        notifyListeners();
        return;
      }

      // For signup, validate name as well
      if (!_isLogin && _name.isEmpty) {
        _errorMessage = 'Please enter your name';
        notifyListeners();
        return;
      }

      if (!_isLogin && _password != _confirmPassword) {
        _errorMessage = 'Passwords do not match';
        notifyListeners();
        return;
      }

      _isLoading = true;
      notifyListeners();

      if (_isLogin) {
        // Handle login
        debugPrint('Logging in user with email: $_email');
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        debugPrint('User logged in with UID: ${userCredential.user!.uid}');

        _isLoading = false;
        notifyListeners();
        if (context.mounted) context.go('/referrals');
      } else {
        // Handle signup
        debugPrint('Creating new user with email: $_email');
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        debugPrint('User created with UID: ${userCredential.user!.uid}');

        // Create initial user entry in Firestore
        final firestoreProvider = Provider.of<FirestoreProvider>(
          context,
          listen: false,
        );

        // Create complete partner profile with onboarding flag set to true
        if (type == UserType.partner) {
          await firestoreProvider.createPartnerProfile(
            context,
            userId: userCredential.user!.uid,
            name: _name, // Use the name collected at signup
            email: _email,
            referralCode:
                referralCodeController.text.isNotEmpty
                    ? referralCodeController.text
                    : null,
            isOnboardingComplete: true, // Set onboarding as complete
          );
        } else if (type == UserType.student) {
          await firestoreProvider.createStudentProfile(
            context,
            userId: userCredential.user!.uid,
            name: _name, // Use the name collected at signup
            email: _email,
            referralCode:
                referralCodeController.text.isNotEmpty
                    ? referralCodeController.text
                    : null,
            isOnboardingComplete: true, // Set onboarding as complete
          );
        }

        debugPrint(
          'Partner profile created for ${userCredential.user!.uid} with name: $_name',
        );

        // Set display name in Firebase Auth
        await userCredential.user!.updateDisplayName(_name);

        _isLoading = false;
        notifyListeners();

        // Navigate directly to referrals screen
        if (context.mounted) {
          context.go('/referrals');
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'FirebaseAuthException in submitForm: ${e.code} - ${e.message}',
      );
      _errorMessage = e.message ?? 'An authentication error occurred';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error in submitForm: $e');
      _errorMessage = 'An error occurred: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword() async {
    if (_email.isEmpty) {
      _errorMessage = 'Please enter your email address';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      await _auth.sendPasswordResetEmail(email: _email);
      _errorMessage = 'Password reset email sent. Please check your inbox.';
    } catch (e) {
      _errorMessage = 'Failed to send password reset email: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
