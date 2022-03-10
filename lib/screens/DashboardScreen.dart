import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cargo/fragments/HomeFragment.dart';
import 'package:cargo/fragments/OrderFragment.dart';
import 'package:cargo/fragments/QuoteFragment.dart';
import 'package:cargo/fragments/TestFragment.dart';
import 'package:cargo/model/ProfileModel.dart';
import 'package:cargo/model/ViewProModel.dart';
import 'package:cargo/screens/MyAccountScreen.dart';
import 'package:cargo/screens/SplashScreens.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';
  var selectedTab = 0;

  DashboardScreen({Key key, @required this.selectedTab}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var homeFragment = HomeFragment();
  var cartFragment = QuoteFragment();
  var wishlistFragment = OrderFragment();
  var fragments;
  var selectedTab = 0;
  var title = "Home";
  var name = '';
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  ProfileModel profileModel;
  ViewProModel viewProModel;
  String fnl_img='https://secure.gravatar.com/avatar/598b1f668254d0f7097133846aa32daf?s=96&d=mm&r=g';

  @override
  void initState() {
    super.initState();
    fragments = [homeFragment, cartFragment, wishlistFragment];
//    getName();
    fetchDetails();
  }

  Future<ProfileModel> fetchDetails() async {
//    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'CargoAuthToken': token,
        'CargoUserId': UserId
      };

      Response response = await get(
          Uri.parse('https://cargobgi.net/wp-json/wc/v3/customers/$UserId'),
          headers: headers);

//      r.raiseForStatus();
//      String body = r.content();
//      print(body);

      final jsonResponse = json.decode(response.body);
      profileModel = new ProfileModel.fromJson(jsonResponse);
      prefs.setString('UserName', profileModel.firstName);
      setState(() {
        name = profileModel.firstName;
      });

      print('sucess');
      print('not json $jsonResponse');

      return profileModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<ViewProModel> ViewProfilePic() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };

      final msg = jsonEncode({
        "customer_id": UserId,
      });
      print(msg);

      Response response = await post(
          Uri.parse('https://cargobgi.net/wp-json/v3/view_profile_picture'),
          headers: headers,
          body: msg);
      print('Response body: ${response.body}');
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      viewProModel = new ViewProModel.fromJson(jsonResponse);

      fnl_img=viewProModel.profile_picture;



      return viewProModel;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('UserName');
    });
  }

  Future<String> getLogout() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');
      String device_id = prefs.getString('device_id');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoAuthToken': token,
        'cargoUserId': UserId
      };
      final msg = jsonEncode({"device_id": device_id});

      Response response = await get(
          Uri.parse('https://cargobgi.net/wp-json/v3/logout?device_id=$device_id'),
        headers: headers,
      );
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      prefs.setString('token', '');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreens(),
        ),
      );

      return null;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  FutureOr onGoBack(dynamic value) {
    ViewProfilePic();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    Logout() async {
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Are You sure you want to logout?'),
            actions: [
              TextButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
//                  setState(() {
//                    futureAlbum = fetchAlbum();
//                    cartdetail=fetchCart();
//                  });
                },
              ),
              TextButton(
                child: const Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                  getLogout();
                },
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_app_background,
        elevation: 0,
        leading: FutureBuilder<ViewProModel>(
          future: ViewProfilePic(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    // launchScreen(context, MyAccountScreen.tag);
                    Route route = MaterialPageRoute(builder: (context) => MyAccountScreen());
                    Navigator.push(context, route).then(onGoBack);
                  },
                  child: CircleAvatar(
                    // backgroundImage: NetworkImage('https://en.gravatar.com/avatar/491302567ea4eb1e519b54990b8da162'),
                    backgroundImage: NetworkImage(
                        viewProModel.profile_picture),
                    radius: 25,
                  ),
                ),
              );
            }
            return Center(child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: GestureDetector(
                onTap: () {
                  launchScreen(context, MyAccountScreen.tag);
                },
                child: CircleAvatar(
                  // backgroundImage: NetworkImage('https://en.gravatar.com/avatar/491302567ea4eb1e519b54990b8da162'),
                  backgroundImage: NetworkImage(
                      'https://secure.gravatar.com/avatar/598b1f668254d0f7097133846aa32daf?s=96&d=mm&r=g'),
                  radius: 25,
                ),
              ),
            ));
          },
        ),

        iconTheme: IconThemeData(color: sh_white),
        actions: <Widget>[
          IconButton(
            icon: new Image.asset(
              cargo_logout,
              color: Colors.white,
              height: 24,
              width: 24,
            ),
            onPressed: () {
              Logout();
            },
          )
        ],
        title: Text(
          name,
          style: TextStyle(color: sh_white),
        ),
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            fragments[widget.selectedTab],
            Container(
              height: 78,
              width: width * 0.62,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  shape: BoxShape.rectangle,
                  color: sh_app_background),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Listener(
                              onPointerUp: (PointerUpEvent event) {
                                widget.selectedTab = 0;
                                setState(() {});
                              },
                              onPointerDown: (PointerDownEvent event) {
                                widget.selectedTab = 0;
                                setState(() {});
                              },
                              child: tabItem(0, cargo_ic_home, 'Home')),
                        ),
                        Expanded(
                          flex: 3,
                          child: Listener(
                              onPointerUp: (PointerUpEvent event) {
                                widget.selectedTab = 1;
                                setState(() {});
                              },
                              onPointerDown: (PointerDownEvent event) {
                                widget.selectedTab = 1;
                                setState(() {});
                              },
                              child: tabItem(1, cargo_mobile_quote, 'Quotes')),
                        ),
                        Expanded(
                          flex: 3,
                          child: Listener(
                              onPointerUp: (PointerUpEvent event) {
                                widget.selectedTab = 2;
                                setState(() {});
                              },
                              onPointerDown: (PointerDownEvent event) {
                                widget.selectedTab = 2;
                                setState(() {});
                              },
                              child: tabItem(2, cargo_mobile_order, 'Orders')),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tabItem(var pos, var icon, var title) {
    return Container(
      height: 78,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(icon,
              width: 28, height: 28, fit: BoxFit.cover, color: sh_white),
          SizedBox(
            height: 6.0,
          ),
          Text(
            title,
            style: TextStyle(
                color: widget.selectedTab == pos
                    ? sh_colorPrimary
                    : sh_white,
                fontSize: 11.0),
          ),
//            Visibility(
//              visible: true,
//                child: Image.network("http://54.245.123.190/prop/api/input/prop.png1")
//            )
        ],
      ),
    );
  }
}
