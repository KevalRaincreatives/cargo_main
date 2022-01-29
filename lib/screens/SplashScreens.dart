import 'package:cargo/screens/AgentLoginScreen.dart';
import 'package:cargo/screens/AgentOrderListScreen.dart';
import 'package:cargo/screens/DashboardScreen.dart';
import 'package:cargo/screens/ForgotPasswordScreen.dart';
import 'package:cargo/screens/LoginScreen.dart';
import 'package:cargo/screens/NumberScreen.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreens extends StatefulWidget {
  static String tag = "/SplashScreens";

  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchtoken();
  }

  Future<String> fetchtoken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      String user_type=prefs.getString("UserType");
      prefs.commit();
      if(token!= null && token!= '') {
        if(user_type=='Agent'){
          launchScreen(context, AgentOrderListScreen.tag);
        }else {
          launchScreen(context, DashboardScreen.tag);
        }
      } else {
//        launchScreen(context, ShSignIn.tag);
      }

      print('sucess');
      return null;
    } catch (e) {
      print('caught error $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(cargo_splash), fit: BoxFit.cover)),
        child: Column(
          children: <Widget>[
            Expanded(flex: 9, child: Container()),
            Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      Row(children: <Widget>[
                        Expanded(
                          flex: 1,
                            child: Container()),
                        Expanded(
                          flex: 5,
                          child: MaterialButton(
                          onPressed: () {
                            launchScreen(context, LoginScreen.tag);
                          },
                          color: sh_app_blue,
                          padding: EdgeInsets.fromLTRB(40,10,40,10),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: fontBold,
                                color: Colors.white),
                          ),
                        ),),
                        Expanded(
                            flex: 1,
                            child: Container()),
                      ],),
                      SizedBox(height: 12,),
                      Row(children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Container()),
                        Expanded(
                          flex: 5,
                          child: MaterialButton(
                            onPressed: () {
                              launchScreen(context, NumberScreen.tag);
                            },
                            color: sh_app_blue,
                            padding: EdgeInsets.fromLTRB(40,10,40,10),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: fontBold,
                                  color: Colors.white),
                            ),
                          ),),
                        Expanded(
                            flex: 1,
                            child: Container()),
                      ],),
                      SizedBox(height: 8,),
                      Center(child: GestureDetector(
                        onTap: (){
                          launchScreen(context, ForgotPasswordScreen.tag);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Forgot Password?',style: TextStyle(color: sh_app_black,fontSize: 14,fontWeight: FontWeight.bold),),
                        ),
                      )),
                      SizedBox(height: 12,),

                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
