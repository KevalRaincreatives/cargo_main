import 'dart:convert';

import 'package:cargo/model/ForgotModel.dart';
import 'package:cargo/model/NumberCheckModel.dart';
import 'package:cargo/screens/LoginScreen.dart';
import 'package:cargo/screens/SplashScreens.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

class ForgotResetPassScreen extends StatefulWidget {
  static String tag = '/ForgotResetPassScreen';
  final String emails;

  ForgotResetPassScreen({this.emails});

  @override
  _ForgotResetPassScreenState createState() => _ForgotResetPassScreenState();
}

class _ForgotResetPassScreenState extends State<ForgotResetPassScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  ForgotModel numberCheckModel;
  var passwordCont = TextEditingController();
  bool _showPassword = false;

  Future<ForgotModel> getUpdate() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      String code = _phoneNumberController.text;
      String password = passwordCont.text;
      String email = widget.emails;
      Map<String, String> headers = {'Content-Type': 'application/json'};
      final msg =
          jsonEncode({"email": email.trim(), "code": code.trim(), "password": password.trim()});

      Response response = await post(
          Uri.parse('https://cargobgi.net/wp-json/bdpwr/v1/set-password'),
        headers: headers,
        body: msg
      );

      final jsonResponse = json.decode(response.body);
      print('forgot reset password $jsonResponse');
      numberCheckModel = new ForgotModel.fromJson(jsonResponse);

      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      if (numberCheckModel.data.status == 200) {
        showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
              title: Text('Sent'),
              content: SingleChildScrollView(
                child: Text(numberCheckModel.message),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(ConfirmAction.CANCEL);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                        builder: (context) => SplashScreens()
                        ),
                    );
//                    launchScreen(context, ForgotResetPassScreen.tag);
                  },
                ),
              ],
            ));
      } else {
        showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
              title: Text('Fail'),
              content: SingleChildScrollView(
                child: Text(numberCheckModel.message),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(ConfirmAction.CANCEL);

//                    launchScreen(context, ForgotResetPassScreen.tag);
                  },
                ),
              ],
            ));
      }

      print('sucess');
      return numberCheckModel;
    } catch (e) {
      print('caught error $e');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final node = FocusScope.of(context);
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.phone_android,
                        color: sh_yellow,
                        size: 60,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'We have sent a reset code to your email.',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Enter it below to continue.',
                        style: TextStyle(fontSize: 20, color: sh_yellow),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: TextFormField(
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              controller: _phoneNumberController,
                              onEditingComplete: () => node.nextFocus(),
                              textCapitalization: TextCapitalization.words,
                              style: TextStyle(
                                  color: sh_yellow,
                                  fontFamily: fontRegular,
                                  fontSize: textSizeMedium),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Please Enter Code';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: sh_transparent,
                                  focusColor: sh_colorPrimary,
                                  hintText: sh_hint_code,
                                  hintStyle: TextStyle(
                                      color: sh_textColorSecondary,
                                      fontFamily: fontRegular,
                                      fontSize: textSizeMedium),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: sh_yellow, width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: sh_yellow, width: 0.5))),
                            ),
                          ),
                          Expanded(flex: 4, child: Container())
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
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
                            hintText: sh_hint_new_password,
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: this._showPassword
                                    ? sh_yellow
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() =>
                                    this._showPassword = !this._showPassword);
                              },
                            ),
                            hintStyle: TextStyle(
                                color: sh_textColorSecondary,
                                fontFamily: fontRegular,
                                fontSize: textSizeMedium),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    BorderSide(color: sh_yellow, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    BorderSide(color: sh_yellow, width: 0.5))),
                      )
                    ],
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
                              getUpdate();
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
                                    'Reset',
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
