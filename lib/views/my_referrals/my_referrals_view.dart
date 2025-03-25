import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/views/my_referrals/widgets/build_withdraw_button.dart';
import 'package:referral_memoneet/views/my_referrals/widgets/link_widget.dart';
import 'package:referral_memoneet/views/my_referrals/widgets/referral_stats_widget.dart';
import 'package:referral_memoneet/views/my_referrals/widgets/user_header_widget.dart';

import 'my_referrals_model.dart';

class MyReferralsScreen extends StatelessWidget {
  const MyReferralsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyReferralsModel(),
      child: MyReferralsView(),
    );
  }
}

class MyReferralsView extends StatefulWidget {
  const MyReferralsView({super.key});

  @override
  State<MyReferralsView> createState() => _MyReferralsViewState();
}

class _MyReferralsViewState extends State<MyReferralsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MyReferralsModel>(context, listen: false).initialize('12');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Referrals'),
        elevation: 0,
      ),
      body: Consumer<MyReferralsModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserHeaderWidget(viewModel: viewModel),
                  const SizedBox(height: 24),
                  ReferralStatsWidget(viewModel: viewModel),
                  const SizedBox(height: 24),
                  const ReferralLinkWidget(),
                  const SizedBox(height: 24),
                  BuildWithdrawButton(
                    viewModel: viewModel,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

