import 'dart:convert';

import 'package:cargo/dialgoue/cutstom_dialogue.dart';
import 'package:cargo/dialgoue/cutstom_dialogue2.dart';
import 'package:cargo/model/ChangePassModel.dart';
import 'package:cargo/model/ShLoginModel.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String tag = '/ChangePasswordScreen';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var oldpasswordCont = TextEditingController();
  var passwordCont = TextEditingController();
  var confirmPasswordCont = TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool _showOldPassword = false;
  bool _showPassword = false;
  bool _showCnfrmPassword = false;
  ShLoginModel cat_model;
  final _formKey = GlobalKey<FormState>();
  ChangePassModel changePassModel;

  Future<ShLoginModel> getChange() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      String password = passwordCont.text;
      String oldpassword=oldpasswordCont.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoAuthToken': token,
        'cargoUserId': UserId
      };
      final msg = jsonEncode({"password": oldpassword.trim(),"new_password":password.trim()});

      Response response = await post(
          Uri.parse('https://cargobgi.net/wp-json/v3/change_password'),
        headers: headers,
        body: msg,
      );

//      r.raiseForStatus();
//      String body = r.content();
//      print(body);

      final jsonResponse = json.decode(response.body);
      print('change password $jsonResponse');
      changePassModel = new ChangePassModel.fromJson(jsonResponse);
      
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      if (changePassModel.success) {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              CustomDialog(
                title: "Success",
                description: changePassModel.error,
                buttonText: "Okay",
              ),
        );
      }else {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              CustomDialog2(
                title: "Fail",
                description: changePassModel.error,
                buttonText: "Okay",
              ),
        );
      }
//      finish(context);
      print('not json $jsonResponse');
//      cat_model = new ShLoginModel.fromJson(jsonResponse);
//      print("cat dta$cat_model");

      return cat_model;
    } catch (e) {
      print('caught error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    viewOrderDetail() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: spacing_standard_new),
          Center(
              child: Text(
            'Your new password must be different from previous used password',
            style: TextStyle(
                color: sh_app_background,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            autofocus: false,
            obscureText: !this._showOldPassword,
            controller: oldpasswordCont,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
                color: sh_textColorPrimary,
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
                hintText: sh_hint_current_password,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: this._showOldPassword ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => this._showOldPassword = !this._showOldPassword);
                  },
                ),
                hintStyle: TextStyle(
                    color: sh_textColorSecondary,
                    fontFamily: fontRegular,
                    fontSize: textSizeMedium),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5), width: 0.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5), width: 0))),
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
            autofocus: false,
            obscureText: !this._showPassword,
            controller: passwordCont,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
                color: sh_textColorPrimary,
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
                hintText: sh_hint_new_password,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: this._showPassword ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => this._showPassword = !this._showPassword);
                  },
                ),
                hintStyle: TextStyle(
                    color: sh_textColorSecondary,
                    fontFamily: fontRegular,
                    fontSize: textSizeMedium),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5), width: 0.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5), width: 0))),
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
            autofocus: false,
            obscureText: !this._showCnfrmPassword,
            controller: confirmPasswordCont,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
                color: sh_textColorPrimary,
                fontFamily: fontRegular,
                fontSize: textSizeMedium),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Please Enter Confirm Password';
              }
              if (text != passwordCont.text) {
                return 'Password Do Not Match';
              }
              return null;
            },
            decoration: InputDecoration(
                filled: false,
                hintText: sh_hint_confirm_password,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: this._showCnfrmPassword ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() =>
                        this._showCnfrmPassword = !this._showCnfrmPassword);
                  },
                ),
                hintStyle: TextStyle(
                    color: sh_textColorSecondary,
                    fontFamily: fontRegular,
                    fontSize: textSizeMedium),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5), width: 0.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5), width: 0))),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            // height: double.infinity,
            child: MaterialButton(
              padding: EdgeInsets.all(spacing_standard),
              child: text(sh_lbl_update_pswd,
                  fontSize: textSizeNormal,
                  fontFamily: fontMedium,
                  textColor: sh_white),
              textColor: sh_white,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(40.0)),
              color: sh_app_background,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  // TODO submit
                  FocusScope.of(context).requestFocus(FocusNode());
                  getChange();
                }
              },
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text(sh_lbl_change_pswd,
            textColor: sh_textColorPrimary,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(spacing_standard_new),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    viewOrderDetail(),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
