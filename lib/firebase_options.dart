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
    apiKey: 'AIzaSyDVYM6dnhmO73uXNjCS7paLr_-IVv05A98',
    appId: '1:50933881229:web:01baf848863435eb6ac5c4',
    messagingSenderId: '50933881229',
    projectId: 'vbproject-692b8',
    authDomain: 'vbproject-692b8.firebaseapp.com',
    storageBucket: 'vbproject-692b8.firebasestorage.app',
    measurementId: 'G-XXZK4L324M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-Oi_PVGp41f65n5IIVxNPMCktOfaT_AA',
    appId: '1:50933881229:android:31392b33839e26df6ac5c4',
    messagingSenderId: '50933881229',
    projectId: 'vbproject-692b8',
    storageBucket: 'vbproject-692b8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqHa4ar4Lx9LsVIkhtk7YzleUa0hk69B8',
    appId: '1:50933881229:ios:ce45f8e9f1ccfc416ac5c4',
    messagingSenderId: '50933881229',
    projectId: 'vbproject-692b8',
    storageBucket: 'vbproject-692b8.firebasestorage.app',
    iosBundleId: 'com.example.vbfinals',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAqHa4ar4Lx9LsVIkhtk7YzleUa0hk69B8',
    appId: '1:50933881229:ios:ce45f8e9f1ccfc416ac5c4',
    messagingSenderId: '50933881229',
    projectId: 'vbproject-692b8',
    storageBucket: 'vbproject-692b8.firebasestorage.app',
    iosBundleId: 'com.example.vbfinals',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDVYM6dnhmO73uXNjCS7paLr_-IVv05A98',
    appId: '1:50933881229:web:92a43971a86f015a6ac5c4',
    messagingSenderId: '50933881229',
    projectId: 'vbproject-692b8',
    authDomain: 'vbproject-692b8.firebaseapp.com',
    storageBucket: 'vbproject-692b8.firebasestorage.app',
    measurementId: 'G-DG11Z8DX2Q',
  );
}
