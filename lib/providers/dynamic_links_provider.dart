import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'dart:async';

class DynamicLinksProvider extends ChangeNotifier {
  final String _domain =
      'YOUR_DOMAIN_URI_PREFIX.page.link'; // Replace with your domain from Firebase console

  /// Creates a dynamic link for a specific partner
  Future<Uri> createPartnerReferralLink({
    required String partnerId,
    String? partnerName,
    String? imageUrl,
  }) async {
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: _domain,
      link: Uri.parse('https://referralmemoneet.page.link/referral?partnerId=$partnerId'),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.referralmemoneet',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.referral_memoneet',
        minimumVersion: '1.0.0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Join through ${partnerName ?? "partner"} referral',
        description: 'Use this link to sign up with a referral bonus!',
        imageUrl: imageUrl != null ? Uri.parse(imageUrl) : null,
      ),
    );

    final shortLink = await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );

    return shortLink.shortUrl;
  }

  /// Handles incoming dynamic links when app is opened
  Future<String?> handleDynamicLinks() async {
    // Handle links when app is opened from a link
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      return _extractPartnerId(initialLink.link);
    }

    // Listen to incoming dynamic links when the app is already running
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final partnerId = _extractPartnerId(dynamicLinkData.link);
      // You can call a method to process this partnerId
      if (partnerId != null) {
        processReferral(partnerId);
      }
    }).onError((error) {
      // Handle errors
      debugPrint('Dynamic link error: $error');
    });

    return null;
  }

  /// Extracts partner ID from the dynamic link
  String? _extractPartnerId(Uri uri) {
    final queryParams = uri.queryParameters;
    return queryParams['partnerId'];
  }

  /// Process the referral with the partner ID
  void processReferral(String partnerId) {
    // Implement your referral processing logic here
    debugPrint('Processing referral from partner: $partnerId');

    // Notify listeners so UI can update if needed
    notifyListeners();
  }
}
