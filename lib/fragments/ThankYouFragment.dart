import 'package:cargo/screens/DashboardScreen.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThankYouFragment extends StatefulWidget {

  @override
  _ThankYouFragmentState createState() => _ThankYouFragmentState();
}

class _ThankYouFragmentState extends State<ThankYouFragment> {
  String suc_id='';

  @override
  void initState() {
    super.initState();
    getName();
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      suc_id = prefs.getString('success_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: sh_background_color,
        height: height - 74,
        width: width,
        child: Stack(
          children: <Widget>[
            Container(
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24)),
                  shape: BoxShape.rectangle,
                  color: sh_app_background),
            ),
            GestureDetector(
              onTap: () {
//                launchScreen(context, OrderDetailScreen.tag);
              },
              child: Container(
                width: width,
                padding: EdgeInsets.fromLTRB(20, 30, 20, 84),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      cargo_thank_you,
                      color: sh_app_background,
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Text(
                      'Thank You!',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Text(
                      'Your request for a quote has been received!',
                      style: TextStyle(
                          color: sh_app_black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Your request ID is #',
                          style: TextStyle(
                              color: sh_app_black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          suc_id,
                          style: TextStyle(
                              color: sh_app_background,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Text(
                      'Please allow us 2 working days',
                      style: TextStyle(
                          color: sh_app_black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'to get back to you',
                      style: TextStyle(
                          color: sh_app_black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40,),
                    Row(
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
                                    TextStyle(color: sh_app_background, fontSize: 18,fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                      iconSize: 20,
                                      icon: new Image.asset(
                                        cargo_right_arrow,
                                        color: sh_app_background,
                                        height: 24,
                                        width: 24,
                                      ),
                                      onPressed: () {}),
                                ],
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
