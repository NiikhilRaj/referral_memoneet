import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/providers/auth_provider.dart';
import 'package:referral_memoneet/providers/dynamic_links_provider.dart';
import 'package:referral_memoneet/providers/firestore_provider.dart';
import 'package:referral_memoneet/providers/payments_provider.dart';
import 'package:referral_memoneet/views/add_payment_method/view.dart';
import 'package:referral_memoneet/views/my_referrals/view.dart';
import 'package:referral_memoneet/views/onboarding/view.dart';
import 'package:go_router/go_router.dart';
import 'package:referral_memoneet/views/transaction_history/view.dart';
import 'package:referral_memoneet/views/withdrawal_request/view.dart';

void main() {
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DynamicLinksProvider()),
        ChangeNotifierProvider(create: (_) => FirestoreProvider()),
        ChangeNotifierProvider(create: (_) => PaymentsProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/transaction-history',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/referrals',
        builder: (context, state) => const MyReferralsScreen(),
      ),
      GoRoute(
        path: '/withdraw',
        builder: (context, state) => const WithdrawalRequestScreen(),
      ),
      GoRoute(
        path: '/add_payment_method',
        builder: (context, state) => const AddPaymentMethodWidget(),
      ),
      GoRoute(
        path: '/transaction-history',
        builder: (context, state) => const TransactionHistoryScreen(),
      )
      // Add more routes as needed
    ],
    // Redirect logic based on authentication state
    // redirect: (context, state) {
    //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //   final isLoggedIn = authProvider.isLoggedIn;

    //   final isOnLoginPage = state.location == '/';

    //   if (!isLoggedIn && !isOnLoginPage) {
    //     return '/';
    //   } else if (isLoggedIn && isOnLoginPage) {
    //     return '/referrals';
    //   }

    //   return null;
    // },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
