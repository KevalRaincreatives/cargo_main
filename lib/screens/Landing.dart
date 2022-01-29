
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
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
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
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    firebaseCloudMessaging_Listeners();
    fetchtoken();
  }





  void firebaseCloudMessaging_Listeners() async{
    if (Platform.isIOS) iOS_Permission();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _firebaseMessaging.getToken().then((token){
      prefs.setString('device_id',token);
      print(token);
    });

//    void showNotification(Map<String, dynamic> msg) async{
//      print(msg);
//      var android = new AndroidNotificationDetails(
//          'my_package', 'my_organization', 'notification_channel', importance: Importance.Max, priority: Priority.High);
//      var iOS = new IOSNotificationDetails();
//      var platform=new NotificationDetails(android: android, iOS: iOS);
//      await flutterLocalNotificationsPlugin.show(
//        0,'My title', 'This is my custom Notification', platform,);
//    }

    Future<void> _showNotification() async {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0, 'plain title', 'plain body', platformChannelSpecifics,
          payload: 'item x');
    }
    // Method 2
    Future _showNotificationWithDefaultSound(String body,String title,String order) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('order_id', order);
      AndroidNotificationDetails androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
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

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        String _message = message['notification']['body'];
        String _title = message['notification']['title'];
        String _order = message['data']['shipment_id'];
//        String _message = message['notification']['body'];
//        if(_message.contains('shipping')) {
//          String _order = message['data']['shipment_id'];
//          SharedPreferences prefs = await SharedPreferences.getInstance();
//          prefs.setString('order_id', _order);
//          print('notimsg $_message');
//        }else{
//          String _order = message['data']['quote_id'];
//          SharedPreferences prefs = await SharedPreferences.getInstance();
//          prefs.setString('quote_id', _order);
//          print('notimsg $_message');
//        }
        _showNotificationWithDefaultSound(_message,_title,_order);
//        launchScreen(context, OrderDetailScreen.tag);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');

        String _message = message['notification']['body'];
        print('notimsg $_message');

//        if(_message.contains('shipping')) {
          String _order = message['data']['shipment_id'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('order_id', _order);
          launchScreen(context, OrderDetailScreen.tag);
//        }else {
//          String _order = message['data']['quote_id'];
//          SharedPreferences prefs = await SharedPreferences.getInstance();
//          prefs.setString('quote_id', _order);
//          print('notimsg $_message');
//          launchScreen(context, QuoteDetailsScreen.tag);
//
//        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');

        String _message = message['notification']['body'];
        print('notimsg $_message');
//        if(_message.contains('shipping')) {
          String _order = message['data']['shipment_id'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('order_id', _order);
          launchScreen(context, OrderDetailScreen.tag);
//        }else {
//          String _order = message['data']['quote_id'];
//          SharedPreferences prefs = await SharedPreferences.getInstance();
//          prefs.setString('quote_id', _order);
//          print('notimsg $_message');
//          launchScreen(context, QuoteDetailsScreen.tag);
//
//        }
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

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
