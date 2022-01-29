import 'dart:convert';
import 'dart:io';

import 'package:cargo/model/ErrorModel.dart';
import 'package:cargo/model/ShLoginModel.dart';
import 'package:cargo/screens/AgentOrderListScreen.dart';
import 'package:cargo/screens/DashboardScreen.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AgentLoginScreen extends StatefulWidget {
  static String  tag='/AgentLoginScreen';
  @override
  _AgentLoginScreenState createState() => _AgentLoginScreenState();
}

class _AgentLoginScreenState extends State<AgentLoginScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var emailCont = TextEditingController();
  var cardCont = TextEditingController();
  var userNameCont = TextEditingController();
  var firstNameCont = TextEditingController();
  var lastNameCont = TextEditingController();
  var passwordCont = TextEditingController();
  var confirmPasswordCont = TextEditingController();
  var address1Cont = TextEditingController();
  var address2Cont = TextEditingController();
  var cityCont = TextEditingController();
  var postalCont = TextEditingController();
  var stateCont = TextEditingController();
  var countryCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = true;
  ShLoginModel cat_model;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool _showPassword = false;
  ErrorModel err_model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() async {
    if (Platform.isIOS) iOS_Permission();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _firebaseMessaging.getToken().then((token) {
      prefs.setString('device_id', token);
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }
  Future<bool> CheckInternet() async {
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
      print('YAY! Free cute dog pics!');
      return true;
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      return false;
    }

  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  Future<ShLoginModel> SaveToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String device_id = prefs.getString('device_id');
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoAuthToken': token,
        'cargoUserId': UserId
      };
      final msg = jsonEncode({"device_id": device_id});

      Response response = await post(
        'https://cargobgi.net/wp-json/v3/add_device',
        headers: headers,
        body: msg,
      );


      final jsonResponse = json.decode(response.body);
      print('device json $jsonResponse');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      launchScreen(context, AgentOrderListScreen.tag);
      print('sucess');
      return cat_model;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }


  Future<ShLoginModel> getSetting() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      String username = userNameCont.text;
      String password = passwordCont.text;

      Map data = {
        'username': username,
        'password': password,
      };
      Map<String,String> headers = {'Content-Type':'application/json'};
      final msg = jsonEncode({"username":username,"password":password,"role":'deliveryagent'});


      Response response = await post(
        'https://cargobgi.net/wp-json/jwt-auth/v1/token',
        headers: headers,
        body: msg,
      );

//      r.raiseForStatus();
//      String body = r.content();
//      print(body);

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      if(response.statusCode==200) {
        cat_model = new ShLoginModel.fromJson(jsonResponse);
        print("cat dta$cat_model");
      if (cat_model.token.length>10) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', cat_model.token);
        prefs.setString('UserId', cat_model.userId.toString());
        prefs.setString('UserName', cat_model.userDisplayName);
        prefs.setString('UserType', 'Agent');
        prefs.commit();
        SaveToken();
//        launchScreen(context, AgentOrderListScreen.tag);
        print('sucess');
      }else{
        toast('Something Went Wrong');
      }
      }else{
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        err_model = new ErrorModel.fromJson(jsonResponse);
        toast(err_model.code);
//        print("cat dta$cat_model");

      }
      return cat_model;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final node = FocusScope.of(context);

    Username() {
      return TextFormField(
        keyboardType: TextInputType.text,
        controller: userNameCont,
        onEditingComplete: () => node.nextFocus(),
        textCapitalization: TextCapitalization.words,
        style: TextStyle(
            color: sh_yellow,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please Enter Username';
          }
          return null;
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: sh_transparent,
            focusColor: sh_colorPrimary,
            hintText: sh_hint_userName,
            hintStyle: TextStyle(
                color: sh_textColorSecondary,
                fontFamily: fontRegular,
                fontSize: textSizeMedium),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: sh_yellow, width: 1)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: sh_yellow, width: 0.5))),
      );
    }

    Password() {
      return TextFormField(
        autofocus: false,
        obscureText: !this._showPassword,
        keyboardType: TextInputType.text,
        controller: passwordCont,
        onEditingComplete: () => FocusScope.of(context).unfocus(),
        textCapitalization: TextCapitalization.words,
        style: TextStyle(
            color: sh_yellow,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please Enter Password';
          }
          return null;
        },
        decoration: InputDecoration(
            filled: false,
            fillColor: sh_transparent,
            focusColor: sh_colorPrimary,
            hintText: sh_hint_password,
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: this._showPassword ? sh_yellow : Colors.grey,
              ),
              onPressed: () {
                setState(() => this._showPassword = !this._showPassword);
              },
            ),
            hintStyle: TextStyle(
                color: sh_textColorSecondary,
                fontFamily: fontRegular,
                fontSize: textSizeMedium),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: sh_yellow, width: 1)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: sh_yellow, width: 0.5))),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        width: width,
        color: sh_app_blue,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 1, child: Container()),
              Expanded(
                  flex: 11,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.menu,
                            color: sh_yellow,
                            size: 60,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Delivery Agent Login',
                            style: TextStyle(
                                fontSize: 20, color: sh_yellow),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Username(),
                          SizedBox(
                            height: 20,
                          ),
                          Password(),
                        ],
                      ),
                    ),
                  )),
              Expanded(flex: 2,
                  child: Row(children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: sh_white, width: 1.0)),
                        child: Center(
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.chevron_left,
                                    color: sh_white,
                                    size: 24.0,
                                  ),
                                  Text(
                                    'Back',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: sh_white,
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        onTap: () {
                          CheckInternet().then((intenet) {
                            if (intenet) {
                              if (_formKey.currentState.validate()) {
                                // TODO submit
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                getSetting();
                              }
                            }else {
                              toast("No Internet Connection");
                            }
                            // No-Internet Case
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          height: 44,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: sh_yellow, width: 1.0)),
                          child: GestureDetector(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(width: 4,),
                                  Text(
                                    'Continue',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: sh_yellow,
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: sh_yellow,
                                    size: 24.0,
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],))
            ],
          ),
        ),
      ),
    );
  }
}
