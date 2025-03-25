import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/onboarding/steps/bank_details_step.dart';
import 'package:referral_memoneet/views/onboarding/steps/payment_method_step.dart';
import 'package:referral_memoneet/views/onboarding/steps/personal_information_step.dart';
import 'package:referral_memoneet/views/onboarding/steps/upi_details_step.dart';
import 'package:referral_memoneet/widgets/custom_button.dart';
import 'model.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider(
          create: (_) => OnboardingModel(),
          child: const OnboardingView(),
        ),
      ),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late OnboardingModel model;

  @override
  void initState() {
    super.initState();
    model = Provider.of<OnboardingModel>(context, listen: false);
    // Initialize controllers if null
    model.nameController ??= TextEditingController();
    model.emailController ??= TextEditingController();
    model.phoneController ??= TextEditingController();
    model.accountHolderNameController ??= TextEditingController();
    model.accountNumberController ??= TextEditingController();
    model.confirmAccountNumberController ??= TextEditingController();
    model.ifscCodeController ??= TextEditingController();
    model.bankNameController ??= TextEditingController();
    model.branchController ??= TextEditingController();
    model.upiIdController ??= TextEditingController();
    model.upiAppController ??= TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    model.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Complete Your Profile'),
          elevation: 0,
        ),
        body: Stepper(
          currentStep: viewModel.currentStep,
          onStepContinue: () => viewModel.handleContinue(viewModel, context),
          onStepCancel: () {
            if (viewModel.currentStep > 0) {
              setState(() => viewModel.currentStep--);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  CustomButton(
                    text: viewModel.currentStep == 2 ? 'Submit' : 'Continue',
                    onPressed: details.onStepContinue!,
                    width: 120,
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    text: 'Back',
                    onPressed: details.onStepCancel!,
                    isOutlined: true,
                    width: 120,
                  ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Personal Details'),
              content: PersonalInformationStep(),
              isActive: viewModel.currentStep >= 0,
            ),
            Step(
              title: const Text('Payment Method'),
              content: const PaymentMethodStep(),
              isActive: viewModel.currentStep >= 1,
            ),
            Step(
              title: Text(viewModel.getUseUpi ? 'UPI Details' : 'Bank Details'),
              content: viewModel.getUseUpi
                  ? const UpiDetailsStep()
                  : const BankDetailsStep(),
              isActive: viewModel.currentStep >= 2,
            ),
          ],
        ),
      );
    });
  }
}
