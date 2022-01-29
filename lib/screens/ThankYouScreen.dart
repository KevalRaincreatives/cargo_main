import 'package:cargo/fragments/HomeFragment.dart';
import 'package:cargo/fragments/OrderFragment.dart';
import 'package:cargo/fragments/QuoteFragment.dart';
import 'package:cargo/fragments/ThankYouFragment.dart';
import 'package:cargo/screens/MyAccountScreen.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ThankYouScreen extends StatefulWidget {
  static String tag="/ThankYouScreen";

  @override
  _ThankYouScreenState createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  var homeFragment = HomeFragment();
  var cartFragment = ThankYouFragment();
  var wishlistFragment = OrderFragment();
  var fragments;
  var selectedTab = 1;
  var title = "Home";
  var name = '';

  @override
  void initState() {
    super.initState();
    getName();
    fragments = [homeFragment, cartFragment, wishlistFragment];
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('UserName');
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: sh_app_background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: GestureDetector(
            onTap: () {
              launchScreen(context, MyAccountScreen.tag);
            },
            child: Image.asset(
              cargo_profile,
              color: sh_white,
              height: 16,
              width: 16,
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(color: sh_white),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          fragments[selectedTab],
          Container(
            height: 78,
            width: width * 0.62,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0)),
                shape: BoxShape.rectangle, color: sh_app_background),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      tabItem(0, cargo_ic_home, 'Home'),
                      tabItem(1, cargo_mobile_quote, 'Quotes'),
                      tabItem(2, cargo_mobile_order, 'Orders'),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget tabItem(var pos, var icon, var title) {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () {
          selectedTab = pos;
          setState(() {});
        },
        child: Container(
          height: 78,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(icon,
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                  color: sh_white),
              SizedBox(
                height: 6.0,
              ),
              Text(
                title,
                style: TextStyle(
                    color: selectedTab == pos ? sh_colorPrimary : sh_white,
                    fontSize: 11.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
