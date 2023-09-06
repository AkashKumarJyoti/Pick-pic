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
    apiKey: 'AIzaSyD4cf2u67nYsTrk8Ctx5JhJ9w4edqYgNTA',
    appId: '1:198823659551:web:dc54a7c4e33243b84b2d2a',
    messagingSenderId: '198823659551',
    projectId: 'gallery-301e0',
    authDomain: 'gallery-301e0.firebaseapp.com',
    storageBucket: 'gallery-301e0.appspot.com',
    measurementId: 'G-2B7PE3KZHG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBF6mxsY8Znpf85UroNgc1P0K0FfT5V7Xk',
    appId: '1:198823659551:android:8795042c6d93477e4b2d2a',
    messagingSenderId: '198823659551',
    projectId: 'gallery-301e0',
    storageBucket: 'gallery-301e0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAp5bIr-Ew7PWqNRq3wsk-J_gobo1YoJdE',
    appId: '1:198823659551:ios:c366b19653dcbf104b2d2a',
    messagingSenderId: '198823659551',
    projectId: 'gallery-301e0',
    storageBucket: 'gallery-301e0.appspot.com',
    androidClientId: '198823659551-vpba0cipou7dj9riq5p7847kem4stb39.apps.googleusercontent.com',
    iosClientId: '198823659551-ntoaol33ufqn492ho1t2pqoi44vkakk7.apps.googleusercontent.com',
    iosBundleId: 'com.example.gallery',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAp5bIr-Ew7PWqNRq3wsk-J_gobo1YoJdE',
    appId: '1:198823659551:ios:126bb960249d03534b2d2a',
    messagingSenderId: '198823659551',
    projectId: 'gallery-301e0',
    storageBucket: 'gallery-301e0.appspot.com',
    androidClientId: '198823659551-vpba0cipou7dj9riq5p7847kem4stb39.apps.googleusercontent.com',
    iosClientId: '198823659551-2oakrukfqcnmaahf6dpu78r30iml2el9.apps.googleusercontent.com',
    iosBundleId: 'com.example.gallery.RunnerTests',
  );
}
