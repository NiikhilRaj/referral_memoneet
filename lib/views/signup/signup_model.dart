import 'package:flutter/foundation.dart';

enum UserType {
  student,
  partner,
}

class SignupViewModel extends ChangeNotifier {
  UserType _userType = UserType.student;
  bool _isLogin = true;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _error;
  
  // Form fields
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  // Getters
  UserType get userType => _userType;
  bool get isLogin => _isLogin;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  void setUserType(UserType type) {
    _userType = type;
    notifyListeners();
  }

  void toggleAuthMode() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement actual Google sign-in logic
      await Future.delayed(const Duration(seconds: 1));
      // Handle successful sign-in
    } catch (e) {
      _error = "Failed to sign in with Google: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitForm() async {
    if (_email.isEmpty || _password.isEmpty) {
      _error = "Email and password are required";
      notifyListeners();
      return;
    }

    if (!_isLogin && _password != _confirmPassword) {
      _error = "Passwords do not match";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual auth implementation
      await Future.delayed(const Duration(seconds: 1));
      // Handle successful login/signup
    } catch (e) {
      _error = "Authentication failed: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword() async {
    if (_email.isEmpty) {
      _error = "Please enter your email first";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement password reset logic
      await Future.delayed(const Duration(seconds: 1));
      // Handle password reset confirmation
    } catch (e) {
      _error = "Failed to send password reset email: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}