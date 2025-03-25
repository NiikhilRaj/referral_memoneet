import 'dart:convert';

import 'package:flutter/material.dart';

class OnboardingModel extends ChangeNotifier {
  //value Fields

  String? name;
  String? email;
  String? phoneNumber;
  BankDetails? bankDetails;
  UpiDetails? upiDetails;
  bool isOnboardingComplete;

  //controllers

  final formKey = GlobalKey<FormState>();
  final personalFormKey = GlobalKey<FormState>();
  final bankFormKey = GlobalKey<FormState>();
  final upiFormKey = GlobalKey<FormState>();

  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? phoneController;
  TextEditingController? accountHolderNameController;
  TextEditingController? accountNumberController;
  TextEditingController? confirmAccountNumberController;
  TextEditingController? ifscCodeController;
  TextEditingController? bankNameController;
  TextEditingController? branchController;
  TextEditingController? upiIdController;
  TextEditingController? upiAppController;

  int currentStep = 0;
  bool _useUpi = false;

  set setUseUpi(bool val) {
    _useUpi = val;
    notifyListeners();
  }

  bool get getUseUpi => _useUpi;

  @override
  void dispose() {
    nameController?.dispose();
    emailController?.dispose();
    phoneController?.dispose();
    accountHolderNameController?.dispose();
    accountNumberController?.dispose();
    confirmAccountNumberController?.dispose();
    ifscCodeController?.dispose();
    bankNameController?.dispose();
    upiIdController?.dispose();
    branchController?.dispose();
    upiAppController?.dispose();
    super.dispose();
  }

  OnboardingModel({
    this.name,
    this.email,
    this.phoneNumber,
    this.bankDetails,
    this.upiDetails,
    this.isOnboardingComplete = false,
  });

  OnboardingModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    BankDetails? bankDetails,
    UpiDetails? upiDetails,
    bool? isOnboardingComplete,
  }) {
    return OnboardingModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bankDetails: bankDetails ?? this.bankDetails,
      upiDetails: upiDetails ?? this.upiDetails,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }

  Future<bool> saveOnboardingDetails(OnboardingModel model) async {
    // Implement saving logic here (e.g., to local storage or API)
    // For now, we'll just update the current model and return success
    name = model.name;
    email = model.email;
    phoneNumber = model.phoneNumber;
    bankDetails = model.bankDetails;
    upiDetails = model.upiDetails;
    isOnboardingComplete = model.isOnboardingComplete;
    return true;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'bankDetails': bankDetails?.toMap(),
      'upiDetails': upiDetails?.toMap(),
      'isOnboardingComplete': isOnboardingComplete,
    };
  }

  factory OnboardingModel.fromMap(Map<String, dynamic> map) {
    return OnboardingModel(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      bankDetails: map['bankDetails'] != null
          ? BankDetails.fromMap(map['bankDetails'])
          : null,
      upiDetails: map['upiDetails'] != null
          ? UpiDetails.fromMap(map['upiDetails'])
          : null,
      isOnboardingComplete: map['isOnboardingComplete'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnboardingModel.fromJson(String source) =>
      OnboardingModel.fromMap(json.decode(source));

  void handleContinue(OnboardingModel viewModel, BuildContext context) async {
    switch (currentStep) {
      case 0:
        if (personalFormKey.currentState?.validate() ?? false) {
          currentStep++;
          notifyListeners();
        }
        break;
      case 1:
        currentStep++;
        notifyListeners();
        break;
      case 2:
        if (getUseUpi) {
          if (upiFormKey.currentState?.validate() ?? false) {
            submitForm(viewModel, context);
          }
        } else {
          if (bankFormKey.currentState?.validate() ?? false) {
            submitForm(viewModel, context);
          }
        }
        break;
    }
  }

  void submitForm(OnboardingModel viewModel, BuildContext context) async {
    final onboardingModel = OnboardingModel(
      name: nameController!.text,
      email: emailController!.text,
      phoneNumber: phoneController!.text,
      bankDetails: getUseUpi
          ? null
          : BankDetails(
              accountHolderName: accountHolderNameController!.text,
              accountNumber: accountNumberController!.text,
              ifscCode: ifscCodeController!.text,
              bankName: bankNameController!.text,
              branch: branchController?.text,
            ),
      upiDetails: getUseUpi
          ? UpiDetails(
              upiId: upiIdController!.text,
              upiApp: upiAppController?.text,
            )
          : null,
      isOnboardingComplete: true,
    );

    final success = await viewModel.saveOnboardingDetails(onboardingModel);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile completed successfully!')),
      );
      // Navigate to the next screen or home
      // Navigator.of(context).pushReplacement(...);
    }
  }
}

class BankDetails {
  String _accountHolderName;
  String _accountNumber;
  String _ifscCode;
  String _bankName;
  String? _branch;

  // Properties with setters
  String get accountHolderName => _accountHolderName;
  set accountHolderName(String value) => _accountHolderName = value;

  String get accountNumber => _accountNumber;
  set accountNumber(String value) => _accountNumber = value;

  String get ifscCode => _ifscCode;
  set ifscCode(String value) => _ifscCode = value;

  String get bankName => _bankName;
  set bankName(String value) => _bankName = value;

  String? get branch => _branch;
  set branch(String? value) => _branch = value;

  BankDetails({
    String accountHolderName = '',
    String accountNumber = '',
    String ifscCode = '',
    String bankName = '',
    String? branch,
  })  : _accountHolderName = accountHolderName,
        _accountNumber = accountNumber,
        _ifscCode = ifscCode,
        _bankName = bankName,
        _branch = branch;

  BankDetails copyWith({
    String? accountHolderName,
    String? accountNumber,
    String? ifscCode,
    String? bankName,
    String? branch,
  }) {
    return BankDetails(
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      bankName: bankName ?? this.bankName,
      branch: branch ?? this.branch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'bankName': bankName,
      'branch': branch,
    };
  }

  factory BankDetails.fromMap(Map<String, dynamic> map) {
    return BankDetails(
      accountHolderName: map['accountHolderName'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      ifscCode: map['ifscCode'] ?? '',
      bankName: map['bankName'] ?? '',
      branch: map['branch'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BankDetails.fromJson(String source) =>
      BankDetails.fromMap(json.decode(source));
}

class UpiDetails {
  final String upiId;
  final String? upiApp;

  UpiDetails({
    required this.upiId,
    this.upiApp,
  });

  UpiDetails copyWith({
    String? upiId,
    String? upiApp,
  }) {
    return UpiDetails(
      upiId: upiId ?? this.upiId,
      upiApp: upiApp ?? this.upiApp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'upiId': upiId,
      'upiApp': upiApp,
    };
  }

  factory UpiDetails.fromMap(Map<String, dynamic> map) {
    return UpiDetails(
      upiId: map['upiId'] ?? '',
      upiApp: map['upiApp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpiDetails.fromJson(String source) =>
      UpiDetails.fromMap(json.decode(source));
}
