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
    apiKey: 'AIzaSyDabFE5CRBuExjMKQuUvxqd3sseIPDU5iw',
    appId: '1:476955649131:web:56cc190883cffa39b17d2e',
    messagingSenderId: '476955649131',
    projectId: 'todo-app-159d0',
    authDomain: 'todo-app-159d0.firebaseapp.com',
    storageBucket: 'todo-app-159d0.appspot.com',
    measurementId: 'G-MKWPXDX02K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2XNOHn7-N8LdQHRYgVXuxjwbxvqMtyNw',
    appId: '1:476955649131:android:ad0b1345dcf8ca35b17d2e',
    messagingSenderId: '476955649131',
    projectId: 'todo-app-159d0',
    storageBucket: 'todo-app-159d0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBYecc4eU9mJ1JSIU-N6Jblmsv_jxO_DiU',
    appId: '1:476955649131:ios:0be05ca1d56f895cb17d2e',
    messagingSenderId: '476955649131',
    projectId: 'todo-app-159d0',
    storageBucket: 'todo-app-159d0.appspot.com',
    iosClientId: '476955649131-8v8r3u1ksafh5rf17j61r8u7ceh8mu8d.apps.googleusercontent.com',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBYecc4eU9mJ1JSIU-N6Jblmsv_jxO_DiU',
    appId: '1:476955649131:ios:0be05ca1d56f895cb17d2e',
    messagingSenderId: '476955649131',
    projectId: 'todo-app-159d0',
    storageBucket: 'todo-app-159d0.appspot.com',
    iosClientId: '476955649131-8v8r3u1ksafh5rf17j61r8u7ceh8mu8d.apps.googleusercontent.com',
    iosBundleId: 'com.example.todoApp',
  );
}