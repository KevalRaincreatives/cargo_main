import 'package:cargo/screens/DashboardScreen.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:flutter/material.dart';

class SignUpSuccessScreen extends StatefulWidget {
  static String tag = '/SignUpSuccessScreen';

  @override
  _SignUpSuccessScreenState createState() => _SignUpSuccessScreenState();
}

class _SignUpSuccessScreenState extends State<SignUpSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        width: width,
        color: sh_app_blue,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          iconSize: 100,
                          icon: new Image.asset(
                            cargo_verified,
                            color: sh_yellow,
                            height: 120,
                            width: 120,
                          ),
                          onPressed: () {}),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Thank You!',
                        style: TextStyle(fontSize: 24, color: Colors.white,fontFamily: fontBold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Sign up Complete',
                        style: TextStyle(fontSize: 24, color: sh_yellow,fontFamily: fontBold),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Go ahead and get started',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 5, child: Container()),
                      Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: () {
                            launchScreen(context, DashboardScreen.tag);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Continue',
                                  style:
                                      TextStyle(color: sh_yellow, fontSize: 16),
                                ),
                                IconButton(
                                    iconSize: 20,
                                    icon: new Image.asset(
                                      cargo_right_arrow,
                                      color: sh_yellow,
                                      height: 24,
                                      width: 24,
                                    ),
                                    onPressed: () {}),
                              ],
                            ),
                          )),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
