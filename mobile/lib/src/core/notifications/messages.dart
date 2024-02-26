// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:landvest/firebase_options.dart';

// /// Create a [AndroidNotificationChannel] for heads up notifications
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   description:
//       'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );

// String _userToken = '';
// String _userId = '';
// void setUserToken({required String token}) {
//   _userToken = token;
// }

// String get userToken => _userToken;
// void setUserId({required String id}) {
//   _userId = id;
// }

// String get userId => _userId;

// /// Initialize the [FlutterLocalNotificationsPlugin] package.
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// /// Init Firebase service
// Future<void> initializePushNotification() async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // if (!kIsWeb) {
//   //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   //   /// Create an Android Notification Channel.
//   //   ///
//   //   /// We use this channel in the `AndroidManifest.xml` file to override the
//   //   /// default FCM channel to enable heads up notifications.
//   //   await flutterLocalNotificationsPlugin
//   //       .resolvePlatformSpecificImplementation<
//   //           AndroidFlutterLocalNotificationsPlugin>()
//   //       ?.createNotificationChannel(channel);

//   //   /// Update the iOS foreground notification presentation options to allow
//   //   /// heads up notifications.
//   //   await FirebaseMessaging.instance
//   //       .setForegroundNotificationPresentationOptions(
//   //     alert: true,
//   //     badge: true,
//   //     sound: true,
//   //   );
//   // }
// }

// /// Update token to database
// Future<void> updateTokenToDatabase(AsyncCallback updateUserToken) async {
//   try {
//     await updateUserToken();
//   } on Exception catch (e) {
//     log(e.toString());
//   }
// }

// /// Remove user token database
// Future<void> removeTokenInDatabase(VoidCallback removeToken) async {
//   try {
//     removeToken();
//   } on Exception catch (_) {
//     log('Error from firebase message');
//   }
// }

// /// Get token
// Future<String?> getToken() async => FirebaseMessaging.instance.getToken();

// /// Listening the changes
// mixin MessagingMixin<T extends StatefulWidget> on State<T> {
//   Future<void> subscribe(
//     AsyncCallback updateToken, {
//     Function? navigate,
//   }) async {
//     if (kIsWeb || Platform.isIOS || Platform.isMacOS) {
//       NotificationSettings settings =
//           await FirebaseMessaging.instance.requestPermission();

//       if (settings.authorizationStatus != AuthorizationStatus.authorized &&
//           settings.authorizationStatus != AuthorizationStatus.provisional) {
//         return;
//       }
//     }

//     /// Any time the token refreshes, store this in the database too.
//     FirebaseMessaging.instance.onTokenRefresh.listen((token) {
//       updateTokenToDatabase(updateToken);
//       print('updatetoken: $updateToken');
//     });

//     await FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message?.data != null) {
//         try {
//           Map<String, dynamic> data = {
//             'type': message!.data['type'],
//             'route': message.data['route'],
//             'args': jsonDecode(message.data['args']),
//           };
//           if (navigate != null) {
//             navigate(data);
//           }
//         } on Exception catch (e) {
//           log(e.toString());
//         }
//       }
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       try {
//         Map<String, dynamic> data = {
//           'type': message.data['type'],
//           'route': message.data['route'],
//           'args': jsonDecode(message.data['args']),
//         };
//         if (navigate != null) {
//           navigate(data);
//         }
//       } on Exception catch (e) {
//         log(e.toString());
//       }
//     });

//     FirebaseMessaging.onMessage.listen((message) async {
//       RemoteNotification? notification = message.notification;

//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null && !kIsWeb) {
//         await flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               icon: 'launch_background',
//             ),
//           ),
//         );
//       }
//     });

//     Timer(const Duration(seconds: 5), () async {
//       // Get the token each time the application loads
//       String? token = await getToken();
//       print("Token Firebase: $token");

//       // Save the initial token to the database
//       await updateTokenToDatabase(updateToken);
//     });
//   }
// }

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMesaging = FirebaseMessaging.instance;

  // Future<void> handleBackgroundMessage(RemoteMessage message) async {
  //   print('Title: ${message.notification!.title}');
  //   print('Body: ${message.notification!.body}');
  //   print('PayLoad: ${message.data}');
  // }

  Future<void> initNotification() async {
    await _firebaseMesaging.requestPermission();

    final fcmToken = await _firebaseMesaging.getToken();
    log('fmcToken: $fcmToken');

    await _firebaseMesaging.subscribeToTopic('sample');

    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
