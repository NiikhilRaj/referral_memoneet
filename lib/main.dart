import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/providers/auth_provider.dart';
import 'package:referral_memoneet/providers/dynamic_links_provider.dart';
import 'package:referral_memoneet/providers/firestore_provider.dart';
import 'package:referral_memoneet/providers/payments_provider.dart';
import 'package:referral_memoneet/views/my_referrals/view.dart';
import 'package:referral_memoneet/views/onboarding/view.dart';

void main() {
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DynamicLinksProvider()),
        ChangeNotifierProvider(create: (_) => FirestoreProvider()),
        ChangeNotifierProvider(create: (_) => PaymentsProvider()),
      ],
      child: MaterialApp(
        builder: (context, child) => MyReferralsScreen(),
      ),
    );
  }
}
