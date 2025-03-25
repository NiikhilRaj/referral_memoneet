import 'package:flutter/material.dart';

class MyReferralsModel extends ChangeNotifier {
  late String _userName = "ABC";
  String _profilePictureUrl =
      "https://img.freepik.com/free-photo/beautiful-domestic-cat-laying-fence_181624-43207.jpg";
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
  Future<void> initialize(String userId) async {
    try {
      _setLoading(true);

      // Here you would fetch data from your backend service
      // Example: await _fetchUserData(userId);
      // Example: await _fetchReferralData(userId);

      // Mock data for demonstration
      _userName = "John Doe";
      _profilePictureUrl = "https://example.com/profile.jpg";
      _referralLink = "https://yourdomain.page.link/refer?code=ABC123";
      _referralCount = 5;
      _referralEarnings = 25.0;

      _setLoading(false);
    } catch (e) {
      _setError("Failed to load referral data: ${e.toString()}");
    }
  }

  // Copy referral link to clipboard
  Future<bool> copyReferralLink() async {
    try {
      // Here you would implement the clipboard functionality
      // For example: await Clipboard.setData(ClipboardData(text: _referralLink));
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

      // Here you would call your dynamic links service
      // Example: _referralLink = await DynamicLinkService.createReferralLink(userId);

      // Mock response
      _referralLink =
          "https://yourdomain.page.link/refer?code=${userId}_${DateTime.now().millisecondsSinceEpoch}";

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
}
