
import 'dart:convert';
import 'dart:io';

import 'package:cargo/screens/HowToOrderScreen.dart';
import 'package:cargo/screens/OrderDetailScreen.dart';
import 'package:cargo/screens/QuoteDetailsScreen.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Landing extends StatefulWidget {

  @override
  _LandingState createState() => _LandingState();
}



class _LandingState extends State<Landing> {
  final _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
  final _kTestingCrashlytics = true;
  FirebaseMessaging _firebaseMessaging;
  Future<void> _initializeFlutterFireFuture;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      print(list[100]);
    });
  }

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };

    if (_kShouldTestAsyncErrorOnInit) {
      await _testAsyncErrorOnInit();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFlutterFireFuture = _initializeFlutterFire();
    _firebaseMessaging = FirebaseMessaging.instance;
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    firebaseCloudMessaging_Listeners();
    fetchtoken();
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String _message = message.data['notification']['body'];
    print('notimsg $_message');

    String _order = message.data['data']['shipment_id'];
    prefs.setString('order_id', _order);
    launchScreen(context, OrderDetailScreen.tag);


  }



  void firebaseCloudMessaging_Listeners() async{
    // if (Platform.isIOS) iOS_Permission();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _firebaseMessaging.getToken().then((token){
      prefs.setString('device_id',token);
      print(token);
    });


    setupInteractedMessage();


    // Method 2
    Future _showNotificationWithDefaultSound(String body,String title,String order) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('order_id', order);
      AndroidNotificationDetails androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'your channel id', 'your channel name',
          importance: Importance.max, priority: Priority.high);
      IOSNotificationDetails iOSPlatformChannelSpecifics = new IOSNotificationDetails();
      var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        1,
        title,
        body,
        platformChannelSpecifics,
      );
    }

//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print('on message $message');
//         String _message = message['notification']['body'];
//         String _title = message['notification']['title'];
//         String _order = message['data']['shipment_id'];
//         _showNotificationWithDefaultSound(_message,_title,_order);
// //        launchScreen(context, OrderDetailScreen.tag);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print('on resume $message');
//
//         String _message = message['notification']['body'];
//         print('notimsg $_message');
//
//           String _order = message['data']['shipment_id'];
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setString('order_id', _order);
//           launchScreen(context, OrderDetailScreen.tag);
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print('on launch $message');
//
//         String _message = message['notification']['body'];
//         print('notimsg $_message');
//           String _order = message['data']['shipment_id'];
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setString('order_id', _order);
//           launchScreen(context, OrderDetailScreen.tag);
//       },
//     );
  }

  // void iOS_Permission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true)
  //   );
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings)
  //   {
  //     print("Settings registered: $settings");
  //   });
  // }

  fetchtoken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      String user_type=prefs.getString("UserType");
      prefs.commit();
      if(token!= null && token!= '') {
        if(user_type=='Agent'){
          Navigator.pushNamedAndRemoveUntil(
              context, '/AgentOrderListScreen', ModalRoute.withName('/AgentOrderListScreen'));
        }else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/DashboardScreen', ModalRoute.withName('/DashboardScreen'));
        }


      } else {
//        launchScreen(context, ShSignIn.tag);
        Navigator.pushNamedAndRemoveUntil(
            context, '/SplashScreens', ModalRoute.withName('/SplashScreens'));
      }

      print('sucess');
      return null;
    } catch (e) {
      print('caught error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
  Future onSelectNotification(String payload) async {
    launchScreen(context, OrderDetailScreen.tag);
  }
}
