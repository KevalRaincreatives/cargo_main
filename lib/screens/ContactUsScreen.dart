import 'dart:convert';

import 'package:cargo/dialgoue/QuoteDialog.dart';
import 'package:cargo/model/ShLoginModel.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class ContactUsScreen extends StatefulWidget {
  static String tag='/ContactUsScreen';
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  var emailCont = TextEditingController();
  var phoneCont = TextEditingController();
  var messageCont = TextEditingController();
  var firstNameCont = TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final _formKey = GlobalKey<FormState>();

  Future<ShLoginModel> AddCart() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {

      String name = firstNameCont.text;
      String phone = phoneCont.text;
      String email = emailCont.text;
      String message = messageCont.text;


      var response2;

      response2 = await http
          .post('https://cargobgi.net/wp-json/v3/contact_submit', body: {
        "name": name,
        "phone": phone,
        "email": email,
        "message": message
      });
      print('Response status: ${response2.statusCode}');
      print('Response body: ${response2.body}');

      final jsonResponse = json.decode(response2.body);
      print('not json $jsonResponse');
      if (response2.statusCode == 200) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
//        cat_model = new QuoteSuccessModel.fromJson(jsonResponse);
//        if (cat_model.success) {
          launchScreen(context, QuoteDialog.tag);
//        }else{
//          toast("Something Went Wrong");
//        }
        toast("Success");
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      }
      return null;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);

    ContactForm() {
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        onEditingComplete: () => node.nextFocus(),
                        controller: firstNameCont,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        style: TextStyle(
                            color: sh_textColorPrimary,
                            fontFamily: fontRegular,
                            fontSize: textSizeMedium),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please Enter Name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: sh_editText_background,
                            focusColor: sh_editText_background_active,
                            hintText: sh_hint_name,
                            hintStyle: TextStyle(
                                color: sh_textColorSecondary,
                                fontFamily: fontRegular,
                                fontSize: textSizeMedium),
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0),
                                borderSide: BorderSide(
                                    color: sh_app_background, width: 0.5)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0),
                                borderSide: BorderSide(
                                    color: Colors.transparent,
                                    style: BorderStyle.none,
                                    width: 0))),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: spacing_standard_new,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                onEditingComplete: () => node.nextFocus(),
                textInputAction: TextInputAction.next,
                controller: emailCont,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(
                    color: sh_textColorPrimary,
                    fontFamily: fontRegular,
                    fontSize: textSizeMedium),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please Enter Email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: sh_editText_background,
                    focusColor: sh_editText_background_active,
                    hintText: sh_hint_Email,
                    hintStyle: TextStyle(
                        color: sh_textColorSecondary,
                        fontFamily: fontRegular,
                        fontSize: textSizeMedium),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide:
                        BorderSide(color: sh_app_background, width: 0.5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(
                            color: Colors.transparent,
                            style: BorderStyle.none,
                            width: 0))),
              ),
              SizedBox(
                height: spacing_standard_new,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                onEditingComplete: () => node.nextFocus(),
                textInputAction: TextInputAction.next,
                controller: phoneCont,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(
                    color: sh_textColorPrimary,
                    fontFamily: fontRegular,
                    fontSize: textSizeMedium),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please Enter Phone Number';
                  }

                  return null;
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: sh_editText_background,
                    focusColor: sh_editText_background_active,
                    hintText: sh_hint_mobile_no,
                    hintStyle: TextStyle(
                        color: sh_textColorSecondary,
                        fontFamily: fontRegular,
                        fontSize: textSizeMedium),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide:
                        BorderSide(color: sh_app_background, width: 0.5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(
                            color: Colors.transparent,
                            style: BorderStyle.none,
                            width: 0))),
              ),
              SizedBox(
                height: spacing_standard_new,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                onEditingComplete: () => node.nextFocus(),
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    color: sh_textColorPrimary,
                    fontFamily: fontRegular,
                    fontSize: textSizeMedium),
                controller: messageCont,
                textCapitalization: TextCapitalization.words,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please Enter Message';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: sh_editText_background,
                    focusColor: sh_editText_background_active,
                    hintStyle: TextStyle(
                        color: sh_textColorSecondary,
                        fontFamily: fontRegular,
                        fontSize: textSizeMedium),
                    hintText: sh_hint_message,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide:
                        BorderSide(color: sh_app_background, width: 0.5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(
                            color: Colors.transparent,
                            style: BorderStyle.none,
                            width: 0))),
              ),
              SizedBox(
                height: spacing_xlarge,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                // height: double.infinity,
                child: MaterialButton(
                  padding: EdgeInsets.all(spacing_standard),
                  child: text(sh_lbl_submit,
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
                      FocusScope.of(context)
                          .requestFocus(FocusNode());
                      AddCart();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text(sh_lbl_contact_us,
            textColor: sh_app_black,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_app_black),
        actionsIconTheme: IconThemeData(color: sh_app_black),
      ),
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: <Widget>[
                Center(
                  child:  ContactForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _initCall() async {
//    await new CallNumber().callNumber(sh_contact_phone);
  }
}
