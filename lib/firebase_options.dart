import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
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
          'DefaultFirebaseOptions not configured for Linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions not supported for this platform.',
        );
    }
  }

  // Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBiZRjOSC1LUB9pJiotz9VU3C6MuU0mMEU',
    appId: '1:447468997726:android:6569839117752bc2b6f8cf',
    messagingSenderId: '447468997726',
    projectId: 'my-meal-6a780',
    storageBucket: 'my-meal-6a780.firebasestorage.app',
  );

  // iOS (rellena con tu Bundle ID y datos si vas a usar iOS)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'TU_API_KEY_IOS',
    appId: 'TU_APP_ID_IOS',
    messagingSenderId: '447468997726',
    projectId: 'my-meal-6a780',
    storageBucket: 'my-meal-6a780.firebasestorage.app',
    iosBundleId: 'com.example.mymeal_app',
  );

  // Web (opcional)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'TU_API_KEY_WEB',
    appId: 'TU_APP_ID_WEB',
    messagingSenderId: '447468997726',
    projectId: 'my-meal-6a780',
    authDomain: 'my-meal-6a780.firebaseapp.com',
    storageBucket: 'my-meal-6a780.firebasestorage.app',
  );

  static const FirebaseOptions macos = ios;
  static const FirebaseOptions windows = web;
}
