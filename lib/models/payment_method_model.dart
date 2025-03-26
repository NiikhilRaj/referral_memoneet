import 'package:referral_memoneet/models/upi_model.dart';
import 'package:referral_memoneet/views/onboarding/onboarding_model.dart';

class PaymentMethodModel {
  String type;
  UpiModel? upi;
  BankDetails? bankDetails;
  String methodId;

  PaymentMethodModel({
    required this.type,
    this.upi,
    this.bankDetails,
    required this.methodId,
  });
}
