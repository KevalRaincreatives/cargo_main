import 'dart:convert';

import 'package:cargo/model/NumberCheckModel.dart';
import 'package:cargo/screens/OtpScreen.dart';
import 'package:cargo/screens/TermsConditionScreen.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/services.dart';
class NumberScreen extends StatefulWidget {
  static String tag='/NumberScreen';
  @override
  _NumberScreenState createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  bool _isChecked = true;
//  Country _selected;
  String num;

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  FirebaseUser _firebaseUser;
  String _status;

  AuthCredential _phoneAuthCredential;
  String _verificationId;
  int _code;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  NumberCheckModel numberCheckModel;
  Country _selectedDialogCountry =
  CountryPickerUtils.getCountryByPhoneCode('1-246');
  final _formKey = GlobalKey<FormState>();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  final FocusNode _nodeText6 = FocusNode();

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  ///
  ///
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(focusNode: _nodeText2, toolbarButtons: [
              (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
        KeyboardActionsItem(
          focusNode: _nodeText3,
          onTapAction: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Custom Action"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                });
          },
        ),
        KeyboardActionsItem(
          focusNode: _nodeText4,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText5,
          toolbarButtons: [
            //button 1
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "CLOSE",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
            //button 2
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "DONE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _nodeText6,
          footerBuilder: (_) => PreferredSize(
              child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('Custom Footer'),
                  )),
              preferredSize: Size.fromHeight(40)),
        ),
      ],
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

  Future<String> getCheck() async {
    try {
      String phoneNumber =  _phoneNumberController.text.toString().trim();
      if (phoneNumber == null || phoneNumber.isEmpty|| phoneNumber.length<5) {
       toast('Please Enter Mobile Number');
      }else{
        getUpdate();
      }
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<NumberCheckModel> getUpdate() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      String phoneNumber =  _phoneNumberController.text.toString().trim();
//      String country="+"+num;

      String country="+"+_selectedDialogCountry.phoneCode;

      String ALLOWED_URI_CHARS = "@#&=*+-_.,:!?()/~'%";
      String urlEncoded = Uri.encodeFull(country);
//      String phoneNumber =  _phoneNumberController.text.toString().trim();

//      Map<String, String> headers = {'Content-Type': 'application/json'};
//      final msg = jsonEncode({'phone_number': phoneNumber,'country_code':country});
//
//      Response response = await post(
//        'https://cargobgi.net/wp-json/v3/check_phone',
//        headers: headers,
//        body: msg,
//      );

      Map<String, String> headers = {'Content-Type': 'application/json'};
      final msg = jsonEncode({"country_code": "91", "phone_number": "8200503309"});

      Map data = {
        'country_code': "91",
        'phone_number': phoneNumber.trim(),
      };

      String body = json.encode(data);

      Response response = await get(
        'https://cargobgi.net/wp-json/v3/check_phone_new?phone_number=$phoneNumber&country_code=$urlEncoded',
      );


      final jsonResponse = json.decode(response.body);
      numberCheckModel = new NumberCheckModel.fromJson(jsonResponse);
      if (numberCheckModel.success) {
        _submitPhoneNumber();
      }else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

        showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (context) =>
                AlertDialog(
                  title: Text('Fail'),
                  content: SingleChildScrollView(
                    child: Text('Mobile number already exist'),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop(ConfirmAction.CANCEL);
//                    launchScreen(context, ShHomeScreen.tag);
                      },
                    ),
                  ],
                ));

        print('sucess');
      }
      return numberCheckModel;
    } catch (e) {
      print('caught error $e');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    }
  }

  Future<void> _submitPhoneNumber() async {
//    FirebaseCrashlytics.instance.crash();
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    String phoneNumber = "+"+_selectedDialogCountry.phoneCode+ " "+ _phoneNumberController.text.toString().trim();
    print(phoneNumber);

    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      setState(() {
        _status += 'verificationCompleted\n';
      });
      this._phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    void verificationFailed(FirebaseAuthException error) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('verificationFailed');
      toast(error.code);
      showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Text(error.message),
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
      setState(() {
        _status += '$error\n';
      });
      print(error);
    }

    void codeSent(String verificationId, [int code]) {
      print('codeSent');
      this._verificationId = verificationId;
      print(verificationId);
      this._code = code;
      print(code.toString());
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtpScreen(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
                country_code: _selectedDialogCountry.phoneCode,
                fnlNumber: _phoneNumberController.text.toString().trim()
)),
      );
//      launchScreen(context, OtpScreen.tag);
//      setState(() {
//        _status += 'Code Sent\n';
//      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      setState(() {
        _status += 'codeAutoRetrievalTimeout\n';
      });
      print(verificationId);
    }

    try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); //
    } catch (e) {
      toast("Failed to Verify Phone Number: ${e}");
    }// All the callbacks are above
  }




  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    final node = FocusScope.of(context);

    Widget _buildDialogItem(Country country) => Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8.0),
        Text("+${country.phoneCode}"),
        SizedBox(width: 8.0),
        Flexible(child: Text(country.name))
      ],
    );

    void _openCountryPickerDialog() => showDialog(
      context: context,
      builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
              titlePadding: EdgeInsets.all(8.0),
              searchCursorColor: Colors.pinkAccent,
              searchInputDecoration: InputDecoration(hintText: 'Search...'),
              isSearchable: true,
              title: Text('Select your phone code'),
              onValuePicked: (Country country) =>

                  setState(() =>
                  _selectedDialogCountry = country),
              priorityList: [
                CountryPickerUtils.getCountryByIsoCode('BB'),
                CountryPickerUtils.getCountryByIsoCode('US'),
              ],
              itemBuilder: _buildDialogItem)),
    );

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
              Expanded(
                flex: 1,
                  child: Container()),
              Expanded(
                flex: 11,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      Icon(Icons.phone_android,color: sh_yellow,size: 60,),
                      SizedBox(height: 30,),
                      Text('Please provide your',style: TextStyle(fontSize: 20,color: Colors.white),),
                        SizedBox(height: 2,),
                        Text('mobile number',style: TextStyle(fontSize: 20,color: sh_yellow),),
                        SizedBox(height: 30,),
                        Text('to login securely we will link your mobile number to your account',style: TextStyle(fontSize: 12,color: Colors.white),),
                        SizedBox(height: 10,),
                        Text("*Please don't re-enter country code again in phone number box, once you have selected the country",style: TextStyle(color: sh_yellow,fontSize: 13),),
                        SizedBox(height: 40,),
                        ListTile(
                          onTap: _openCountryPickerDialog,
                          title: _buildDialogItem(_selectedDialogCountry),
                        ),

//                      CountryPicker(
//                        showDialingCode: true,
//                        showName: false,
//                        onChanged: (Country country) {
//                          setState(() {
//                            _selected = country;
//                            num= country.dialingCode;
//                            print('check code $num');
//                          });
//                        },
//                        selectedCountry: _selected,
//                      ),
                        SizedBox(height: 8,),
                        TextFormField(
                          controller: _phoneNumberController,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          onEditingComplete: () => FocusScope.of(context).unfocus(),
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              color: sh_yellow,
                              fontFamily: fontRegular,
                              fontSize: textSizeMedium),
                          validator: (text) {
                            if (text == null || text.isEmpty|| text.length<5) {
                              return 'Please Enter Mobile Number';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: sh_transparent,
                              focusColor: sh_colorPrimary,
                              hintText: sh_hint_mobile_number,
                              hintStyle: TextStyle(
                                  color: sh_textColorSecondary,
                                  fontFamily: fontRegular,
                                  fontSize: textSizeMedium),
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: sh_yellow, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: sh_yellow,
                                      width: 0.5))),
                        ),

                        SizedBox(height: 20,),
                        ListTileTheme(
                          contentPadding: EdgeInsets.all(0),
                          iconColor: sh_white,
                          child: CheckboxListTile(
                            checkColor: sh_white,
                            title: GestureDetector(
                              onTap: () {
                                launchScreen(context, TermsConditionScreen.tag);
                              },
                                child: Text("I agree to the terms and conditions",style: TextStyle(color: sh_yellow,fontSize: 13),)),
                            value: _isChecked,
                            onChanged: (newValue) {
                              setState(() {
                                _isChecked = newValue;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          ),
                        ),
                        SizedBox(height: 300,),

                    ],),
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
                          getCheck();
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
//                           GestureDetector(
//                             onTap: () {
//                               if (_formKey.currentState.validate()) {
//                                 // TODO submit
//                                 FocusScope.of(context)
//                                     .requestFocus(FocusNode());
//                                 getSetting();
//                               }
// //                              launchScreen(context, SignUpSuccessScreen.tag);
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 8),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: <Widget>[
//                                   Text(
//                                     'Login',
//                                     style: TextStyle(
//                                         color: sh_yellow, fontSize: 16),
//                                   ),
//                                   IconButton(
//                                       iconSize: 20,
//                                       icon: new Image.asset(
//                                         cargo_right_arrow,
//                                         color: sh_yellow,
//                                         height: 24,
//                                         width: 24,
//                                       ),
//                                       onPressed: () {
//                                         if (_formKey.currentState.validate()) {
//                                           // TODO submit
//                                           FocusScope.of(context)
//                                               .requestFocus(FocusNode());
//                                           getSetting();
//                                         }
// //                                      launchScreen(
// //                                          context, SignUpSuccessScreen.tag);
//                                       }),
//                                 ],
//                               ),
//                             ),
//                           )
                ),
              ],))
            ],
          ),
        ),

      ),
    );

  }


}
