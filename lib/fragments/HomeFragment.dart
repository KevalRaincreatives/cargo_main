import 'package:cargo/screens/CovidScreen.dart';
import 'package:cargo/screens/DashboardScreen.dart';
import 'package:cargo/screens/HowToOrderScreen.dart';
import 'package:cargo/screens/LocationScreen.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: sh_background_color,
        height: height - 74,
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
            Container(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 84),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Row(
                      children: <Widget>[
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                            flex: 16,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                      flex: 7,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DashboardScreen(
                                                      selectedTab: 2),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DashboardScreen(
                                                            selectedTab: 2),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: height,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    child: Image.asset(
                                                      cargo_get_order,
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                            ),
                                            Positioned(
                                              child: groceryButton(
                                                  textContent: "Check Order",
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DashboardScreen(
                                                                selectedTab: 2),
                                                      ),
                                                    );
                                                  }),
                                              right: 0,
                                              left: 0,
                                              bottom: -18,
                                            ),
                                          ],
                                        ),
                                      )),
                                  Expanded(flex: 1, child: Container()),
                                  Expanded(
                                      flex: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          launchScreen(context,
                                              HowToOrderScreen.tag);
                                        },
                                        child: Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            Container(
                                              height: height,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12.0),
                                                  child: Image.asset(
                                                    cargo_how_order,
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                            Positioned(
                                              child: groceryButton(
                                                  textContent: "How To Order",
                                                  onPressed: () {
                                                    launchScreen(context,
                                                        HowToOrderScreen.tag);
                                                  }),
                                              right: 0,
                                              left: 0,
                                              bottom: -18,
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            )),
                        Expanded(flex: 1, child: Container()),
                        Expanded(
                            flex: 16,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                      flex: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DashboardScreen(
                                                      selectedTab: 1),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            Container(
                                              height: height,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12.0),
                                                  child: Image.asset(
                                                    cargo_quote,
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                            Positioned(
                                              child: groceryButton(
                                                  textContent: "Get A Quote",
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DashboardScreen(
                                                                selectedTab: 1),
                                                      ),
                                                    );
                                                  }),
                                              right: 0,
                                              left: 0,
                                              bottom: -18,
                                            ),
                                          ],
                                        ),
                                      )),
                                  Expanded(flex: 1, child: Container()),
                                  Expanded(
                                      flex: 7,
                                      child: GestureDetector(
                                        onTap: () {
                                          launchScreen(context,
                                              LocationScreen.tag);
                                        },
                                        child: Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            Container(
                                              height: height,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12.0),
                                                  child: Image.asset(
                                                    cargo_map_location,
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                            Positioned(
                                              child: groceryButton(
                                                  textContent: "Our Location",
                                                  onPressed: () {
                                                    launchScreen(context,
                                                        LocationScreen.tag);
                                                  }),
                                              right: 0,
                                              left: 0,
                                              bottom: -18,
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            )),
                        Expanded(flex: 2, child: Container()),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              launchScreen(context, CovidScreen.tag);
                            },

                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.settings,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Our COVID-19 steps for Safety',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: fontBold),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
