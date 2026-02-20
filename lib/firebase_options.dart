// IMPORTANT: This file needs to be generated using FlutterFire CLI
// Run: flutterfire configure
//
// This is a placeholder. After running the FlutterFire CLI command,
// this file will be automatically generated with your Firebase project configuration.

// Temporary dartpadding to prevent errors:
// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'you need to run: flutterfire configure',
        );
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBimXuMUiuY_x94p8kqTHUE81Na2SbfoDs',
    appId: '1:465730932885:web:6de83b063ac910d1204b9c',
    messagingSenderId: '465730932885',
    projectId: 'textsnap-fe3f0',
    authDomain: 'textsnap-fe3f0.firebaseapp.com',
    storageBucket: 'textsnap-fe3f0.firebasestorage.app',
    measurementId: 'G-0H6MVP3C9M',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAp3qtp3asnuty7NLaKmWi7M2WkeWF5-0o',
    appId: '1:465730932885:ios:950a7c9e7fc1c83d204b9c',
    messagingSenderId: '465730932885',
    projectId: 'textsnap-fe3f0',
    storageBucket: 'textsnap-fe3f0.firebasestorage.app',
    iosClientId: '465730932885-mjt6rogd85gq3fksm0vhqcmof89aptuj.apps.googleusercontent.com',
    iosBundleId: 'com.example.textSnap',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAp3qtp3asnuty7NLaKmWi7M2WkeWF5-0o',
    appId: '1:465730932885:ios:950a7c9e7fc1c83d204b9c',
    messagingSenderId: '465730932885',
    projectId: 'textsnap-fe3f0',
    storageBucket: 'textsnap-fe3f0.firebasestorage.app',
    iosClientId: '465730932885-mjt6rogd85gq3fksm0vhqcmof89aptuj.apps.googleusercontent.com',
    iosBundleId: 'com.example.textSnap',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBaLdvR8EnsEKfLZr2-ir9VuVB9MNjaGRI',
    appId: '1:465730932885:android:a8d99cdd1c72926e204b9c',
    messagingSenderId: '465730932885',
    projectId: 'textsnap-fe3f0',
    storageBucket: 'textsnap-fe3f0.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBimXuMUiuY_x94p8kqTHUE81Na2SbfoDs',
    appId: '1:465730932885:web:8f559f3c24f73cce204b9c',
    messagingSenderId: '465730932885',
    projectId: 'textsnap-fe3f0',
    authDomain: 'textsnap-fe3f0.firebaseapp.com',
    storageBucket: 'textsnap-fe3f0.firebasestorage.app',
    measurementId: 'G-23GG8GXML8',
  );

}