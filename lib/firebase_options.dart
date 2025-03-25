// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBsso18vKElgYXaq2yCT2mX1GAe7sBNcvc',
    appId: '1:868936636119:web:41edbd3ee28024995c4292',
    messagingSenderId: '868936636119',
    projectId: 'referral-memoneet',
    authDomain: 'referral-memoneet.firebaseapp.com',
    storageBucket: 'referral-memoneet.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcPQ8RGiX3K6rVqjNUgUJLnxBfLxvNWy4',
    appId: '1:868936636119:android:72025668d24af4585c4292',
    messagingSenderId: '868936636119',
    projectId: 'referral-memoneet',
    storageBucket: 'referral-memoneet.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQmDZykeQ-LmDQSSljp4DPOCSFxxB9A1k',
    appId: '1:868936636119:ios:c1bdb3223f8606bc5c4292',
    messagingSenderId: '868936636119',
    projectId: 'referral-memoneet',
    storageBucket: 'referral-memoneet.firebasestorage.app',
    iosBundleId: 'com.example.referralMemoneet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQmDZykeQ-LmDQSSljp4DPOCSFxxB9A1k',
    appId: '1:868936636119:ios:c1bdb3223f8606bc5c4292',
    messagingSenderId: '868936636119',
    projectId: 'referral-memoneet',
    storageBucket: 'referral-memoneet.firebasestorage.app',
    iosBundleId: 'com.example.referralMemoneet',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBsso18vKElgYXaq2yCT2mX1GAe7sBNcvc',
    appId: '1:868936636119:web:3f573e873531010e5c4292',
    messagingSenderId: '868936636119',
    projectId: 'referral-memoneet',
    authDomain: 'referral-memoneet.firebaseapp.com',
    storageBucket: 'referral-memoneet.firebasestorage.app',
  );
}
