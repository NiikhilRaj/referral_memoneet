import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/providers/auth_provider.dart';
import 'package:referral_memoneet/providers/dynamic_links_provider.dart';
import 'package:referral_memoneet/providers/firestore_provider.dart';
import 'package:referral_memoneet/providers/payments_provider.dart';
import 'package:referral_memoneet/router_refresh.dart';
import 'package:referral_memoneet/views/add_payment_method/view.dart';
import 'package:referral_memoneet/views/leaderboard/view.dart';
import 'package:referral_memoneet/views/my_referrals/my_referrals_view.dart';
import 'package:go_router/go_router.dart';
import 'package:referral_memoneet/views/onboarding/onboarding_view.dart';
import 'package:referral_memoneet/views/redirect_controller.dart';
import 'package:referral_memoneet/views/signup/signup_view.dart';
import 'package:referral_memoneet/views/transaction_history/transaction_view.dart';
import 'package:referral_memoneet/views/withdrawal_request/withdraw_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        ChangeNotifierProxyProvider<FirestoreProvider, RedirectController>(
          create: (context) => RedirectController(
              Provider.of<FirestoreProvider>(context, listen: false)),
          update: (context, firestoreProvider, previous) =>
              previous ?? RedirectController(firestoreProvider),
        ),
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
    initialLocation: '/signup',
    refreshListenable: GoRouterRefreshStream(),
    routes: [
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) {
          final referralCode = state.uri.queryParameters['referral'];
          return SignupScreen(
            referralCode: referralCode,
          );
        },
      ),
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
      ),
      GoRoute(
          path: '/leaderboard',
          builder: (context, state) => const LeaderboardScreen())
      // Add more routes as needed
    ],
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final isLoggedIn = authProvider.currentUser != null;
      final isOnLoginPage = state.uri.path == '/signup';

      // If not logged in, redirect to signup (except if already there)
      if (!isLoggedIn && !isOnLoginPage) {
        final queryParams = state.uri.queryParameters.isNotEmpty
            ? '?' + Uri(queryParameters: state.uri.queryParameters).query
            : '';
        return '/signup$queryParams';
      }

      // If logged in but on login page, go directly to referrals
      if (isLoggedIn && isOnLoginPage) {
        return '/referrals';
      }

      // No redirection needed
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
