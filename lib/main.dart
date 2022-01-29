import 'dart:async';

import 'package:cargo/dialgoue/QuoteDialog.dart';
import 'package:cargo/fragments/TestFragment.dart';
import 'package:cargo/screens/AddNewAddressScreen.dart';
import 'package:cargo/screens/AgentLoginScreen.dart';
import 'package:cargo/screens/AgentOrderDetailScreen.dart';
import 'package:cargo/screens/AgentOrderListScreen.dart';
import 'package:cargo/screens/ChangePasswordScreen.dart';
import 'package:cargo/screens/ContactUsScreen.dart';
import 'package:cargo/screens/CovidScreen.dart';
import 'package:cargo/screens/DashboardScreen.dart';
import 'package:cargo/screens/EnterProfileScreen.dart';
import 'package:cargo/screens/ForgotPasswordScreen.dart';
import 'package:cargo/screens/ForgotResetPassScreen.dart';
import 'package:cargo/screens/HowToOrderScreen.dart';
import 'package:cargo/screens/Landing.dart';
import 'package:cargo/screens/LocationScreen.dart';
import 'package:cargo/screens/LoginScreen.dart';
import 'package:cargo/screens/MyAccountScreen.dart';
import 'package:cargo/screens/MyAddressScreen.dart';
import 'package:cargo/screens/NewNumberScreen.dart';
import 'package:cargo/screens/NumberScreen.dart';
import 'package:cargo/screens/OrderDetailNewScreen.dart';
import 'package:cargo/screens/OrderDetailScreen.dart';
import 'package:cargo/screens/OtpNewScreen.dart';
import 'package:cargo/screens/OtpScreen.dart';
import 'package:cargo/screens/ProfileScreen.dart';
import 'package:cargo/screens/QuoteDetailsScreen.dart';
import 'package:cargo/screens/SelectDeliveryScreen.dart';
import 'package:cargo/screens/ShBackScreen.dart';
import 'package:cargo/screens/SignUpSuccessScreen.dart';
import 'package:cargo/screens/SignaturePad.dart';
import 'package:cargo/screens/SplashScreens.dart';
import 'package:cargo/screens/TermsConditionScreen.dart';
import 'package:cargo/screens/ThankYouScreen.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';


const debug = true;
const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

void main() async{
  bool isInDebugMode = false;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: debug);
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
//  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors to Crashlytics.
//  FlutterError.onError = Crashlytics.instance.recordFlutterError;
//  WidgetsFlutterBinding.ensureInitialized();
//  runZoned(() {
    runApp(MyApp());
//  }, onError: Crashlytics.instance.recordError);

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // return toast("value");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
      initialRoute: '/',
            routes: {
              '/': (context) => Landing(),
              SplashScreens.tag: (BuildContext contex) => SplashScreens(),
              NumberScreen.tag: (BuildContext contex) => NumberScreen(),
              OtpScreen.tag: (BuildContext contex) => OtpScreen(),
              EnterProfileScreen.tag: (BuildContext contex) => EnterProfileScreen(),
              SignUpSuccessScreen.tag: (BuildContext contex) => SignUpSuccessScreen(),
              DashboardScreen.tag: (BuildContext contex) => DashboardScreen(selectedTab: 0,),
              OrderDetailScreen.tag: (BuildContext contex) => OrderDetailScreen(),
              QuoteDetailsScreen.tag: (BuildContext contex) => QuoteDetailsScreen(),
              ThankYouScreen.tag: (BuildContext contex) => ThankYouScreen(),
              LoginScreen.tag: (BuildContext contex) => LoginScreen(),
              ProfileScreen.tag: (BuildContext contex) => ProfileScreen(),
              ChangePasswordScreen.tag:(BuildContext contex) => ChangePasswordScreen(),
              MyAddressScreen.tag:(BuildContext contex) => MyAddressScreen(),
              MyAccountScreen.tag:(BuildContext contex) => MyAccountScreen(),
              AddNewAddressScreen.tag:(BuildContext contex) => AddNewAddressScreen(),
              ForgotPasswordScreen.tag:(BuildContext contex) => ForgotPasswordScreen(),
              ForgotResetPassScreen.tag:(BuildContext contex) => ForgotResetPassScreen(),
              AgentLoginScreen.tag:(BuildContext contex) => AgentLoginScreen(),
              AgentOrderListScreen.tag:(BuildContext contex) => AgentOrderListScreen(),
              AgentOrderDetailScreen.tag:(BuildContext contex) => AgentOrderDetailScreen(),
              SignaturePad.tag:(BuildContext contex) => SignaturePad(),
              SelectDeliveryScreen.tag:(BuildContext contex) => SelectDeliveryScreen(),
              LocationScreen.tag:(BuildContext contex) => LocationScreen(),
              ContactUsScreen.tag:(BuildContext contex) => ContactUsScreen(),
              TermsConditionScreen.tag:(BuildContext contex) => TermsConditionScreen(),
              HowToOrderScreen.tag:(BuildContext contex) => HowToOrderScreen(),
              ShBackScreen.tag: (BuildContext context) => ShBackScreen(),
              QuoteDialog.tag: (BuildContext context) => QuoteDialog(),
              TestFragment.tag: (BuildContext context) => TestFragment(),
              OrderDetailNewScreen.tag: (BuildContext contex) => OrderDetailNewScreen(),
              CovidScreen.tag: (BuildContext contex) => CovidScreen(),
              NewNumberScreen.tag: (BuildContext contex) => NewNumberScreen(),
              OtpNewScreen.tag: (BuildContext contex) => OtpNewScreen(),

            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
      
      
  }
}

//    runApp(MaterialApp(
//      initialRoute: SplashScreens.tag,
//      routes: {
//        SplashScreens.tag: (BuildContext contex) => SplashScreens(),
//        NumberScreen.tag: (BuildContext contex) => NumberScreen(),
//        OtpScreen.tag: (BuildContext contex) => OtpScreen(),
//        EnterProfileScreen.tag: (BuildContext contex) => EnterProfileScreen(),
//        SignUpSuccessScreen.tag: (BuildContext contex) => SignUpSuccessScreen(),
//        DashboardScreen.tag: (BuildContext contex) => DashboardScreen(),
//        OrderDetailScreen.tag: (BuildContext contex) => OrderDetailScreen(),
//        ThankYouScreen.tag: (BuildContext contex) => ThankYouScreen(),
//        LoginScreen.tag: (BuildContext contex) => LoginScreen(),
//        ProfileScreen.tag: (BuildContext contex) => ProfileScreen()
//      },
//    ));
