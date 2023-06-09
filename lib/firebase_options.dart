// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBgMP8tqfDtvzviN59hmjt8dYR2I7y1Z1c',
    appId: '1:900494688911:web:829d4aa6a4cadbcdae66fa',
    messagingSenderId: '900494688911',
    projectId: 'calc-d5fdd',
    authDomain: 'calc-d5fdd.firebaseapp.com',
    storageBucket: 'calc-d5fdd.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDt3euASquil4qBfUu6ozWDLpGloJKdrjI',
    appId: '1:900494688911:android:acfb40a77180d1ffae66fa',
    messagingSenderId: '900494688911',
    projectId: 'calc-d5fdd',
    storageBucket: 'calc-d5fdd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFDWnsN9Lg0HDCn4MauojcSQoJFN_sCRQ',
    appId: '1:900494688911:ios:59cf599a15a20c7dae66fa',
    messagingSenderId: '900494688911',
    projectId: 'calc-d5fdd',
    storageBucket: 'calc-d5fdd.appspot.com',
    iosClientId: '900494688911-9s44s0hu3coeik2d1duc7j860u6cu6bo.apps.googleusercontent.com',
    iosBundleId: 'com.blog.cal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCFDWnsN9Lg0HDCn4MauojcSQoJFN_sCRQ',
    appId: '1:900494688911:ios:7b50d07bba18f688ae66fa',
    messagingSenderId: '900494688911',
    projectId: 'calc-d5fdd',
    storageBucket: 'calc-d5fdd.appspot.com',
    iosClientId: '900494688911-285vf4hg2qqpqq3l7tkfbsv6novc1vj9.apps.googleusercontent.com',
    iosBundleId: 'com.blog.cal.RunnerTests',
  );
}
