import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:referral_memoneet/providers/auth_provider.dart';
import 'package:referral_memoneet/providers/firestore_provider.dart';
import 'package:referral_memoneet/views/my_referrals/widgets/build_withdraw_button.dart';
import 'package:referral_memoneet/views/my_referrals/widgets/link_widget.dart';
import 'package:referral_memoneet/views/my_referrals/widgets/referral_stats_widget.dart';
import 'package:referral_memoneet/views/my_referrals/widgets/user_header_widget.dart';
import 'package:referral_memoneet/widgets/custom_button.dart';
import 'my_referrals_model.dart';

class MyReferralsScreen extends StatefulWidget {
  const MyReferralsScreen({super.key});

  @override
  State<MyReferralsScreen> createState() => _MyReferralsScreenState();
}

class _MyReferralsScreenState extends State<MyReferralsScreen> {
  bool _isInitializing = true;
  bool _hasError = false;
  String _errorMessage = '';
  late MyReferralsModel _model;

  @override
  void initState() {
    super.initState();
    _model = MyReferralsModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

Future<void> _initializeData() async {
  final firestoreProvider = Provider.of<FirestoreProvider>(context, listen: false);
  final firebaseAuth = firestoreProvider.currentUser;

  if (firebaseAuth != null) {
    try {
      setState(() {
        _isInitializing = true;
        _hasError = false;
      });

      final userId = firebaseAuth.uid;
      
      // Use null safety operators when checking document existence
      final documentExists = await firestoreProvider.checkPartnerDocumentExists(userId);
      debugPrint('Partner document exists check: $documentExists');
      
      if (documentExists != true) { // Change this line to handle null safely
        // If document doesn't exist, create a basic one with onboarding complete
        await firestoreProvider.createPartnerProfile(
          userId: userId,
          name: firebaseAuth.displayName ?? firebaseAuth.email?.split('@')[0] ?? "User",
          email: firebaseAuth.email ?? "",
          isOnboardingComplete: true // Set as complete
        );
        debugPrint('Created missing partner document');
      }

      await _model.initialize(context, userId);
      
    } catch (e) {
      debugPrint('Error in _initializeData: $e');
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  } else {
    // No user, redirect to login
    debugPrint('No user found, redirecting to signup');
    if (context.mounted) {
      context.go('/signup');
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model, // Use the existing model instance
      child: Builder(builder: (context) {
        if (_isInitializing) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Referrals')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (_hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Referrals')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: $_errorMessage',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _initializeData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return const MyReferralsView();
      }),
    );
  }
}

class MyReferralsView extends StatelessWidget {
  const MyReferralsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the existing model from Provider
    final viewModel = Provider.of<MyReferralsModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Referrals'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).signOut();
              if (context.mounted) {
                context.go('/signup');
              }
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${viewModel.errorMessage}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          final firebaseAuth = Provider.of<FirestoreProvider>(
                                  context,
                                  listen: false)
                              .currentUser;
                          if (firebaseAuth != null) {
                            viewModel.initialize(context, firebaseAuth.uid);
                          }
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _buildContent(context, viewModel),
    );
  }

  Widget _buildContent(BuildContext context, MyReferralsModel viewModel) {
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
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Leaderboard',
                    onPressed: () {
                      context.push('/leaderboard');
                    },
                    prefixIcon: Icons.leaderboard,
                    backgroundColor: Colors.deepPurpleAccent[100],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: 'Transactions',
                    onPressed: () {
                      context.push('/transaction-history');
                    },
                    prefixIcon: Icons.history,
                    backgroundColor: Colors.deepPurpleAccent[100],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
