import 'dart:convert';


import 'package:cargo/model/ViewCodeModel.dart';
import 'package:cargo/model/profile_model.dart';
import 'package:cargo/screens/MyAccountScreen.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

class OtpNewScreen extends StatefulWidget {
  static String tag='/OtpNewScreen';
  final String verificationId,phoneNumber,country_code,fnlNumber;

  OtpNewScreen({this.verificationId,this.phoneNumber,this.country_code,this.fnlNumber});

  @override
  _OtpNewScreenState createState() => _OtpNewScreenState();
}

class _OtpNewScreenState extends State<OtpNewScreen> {
  ProfileUpdateModel profileUpdateModel;
  FirebaseUser _firebaseUser;
  String _status;
  String _verificationId='';
  AuthCredential _phoneAuthCredential;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  ViewCodeModel viewCodeModel;

  Future<void> _login(String pin) async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)

    String veri_id;
    if(_verificationId==''){
      veri_id=widget.verificationId;
    }else{
      veri_id=_verificationId;
    }
    try {

      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: veri_id, smsCode: pin);
      FirebaseAuth auth = FirebaseAuth.instance;
      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(phoneAuthCredential);

      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
 getUpdate();
//      launchScreen(context, EnterProfileScreen.tag);
//      setState(() {
//        _status += 'Signed In\n';
//      });
    } catch (e) {
      setState(() {
        _status = e.toString() + '\n';
      });
      print(e.toString());
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.yellow
      );
    }
  }

  void _submitOTP(String pin) {
    Dialogs.showLoadingDialog(context, _keyLoader);

    _login(pin);
  }

  Future<void> _submitPhoneNumber() async {
//    FirebaseCrashlytics.instance.crash();
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    Dialogs.showLoadingDialog(context, _keyLoader);
    String phoneNumber = "+"+widget.country_code+ " "+ widget.fnlNumber.trim();
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
      // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
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
//      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

//      launchScreen(context, OtpScreen.tag);
      setState(() {
        _verificationId = verificationId;
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      setState(() {
        _status += 'codeAutoRetrievalTimeout\n';
      });
      print(verificationId);
    }

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
    ); // All the callbacks are above
  }

  Future<ViewCodeModel> UpdateCountryCode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');
      String country_codes='+'+widget.country_code;
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };


      final msg = jsonEncode({
        "customer_id": UserId,
        "country_code": country_codes,
        "billing_phone":widget.fnlNumber
      });
      print(msg);

      Response response = await post(
          'https://cargobgi.net/wp-json/v3/update_country_code',
          headers: headers,
          body: msg);
      print('Response body: ${response.body}');
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      viewCodeModel = new ViewCodeModel.fromJson(jsonResponse);

      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      toast('Updated');

//      profileUpdateModel = new ProfileUpdateModel.fromJson(jsonResponse);
      Route route = MaterialPageRoute(builder: (context) => MyAccountScreen());
      Navigator.pushReplacement(context, route);

      return viewCodeModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<ProfileUpdateModel> getUpdate() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String pro_first = prefs.getString('pro_first');
      String pro_last = prefs.getString('pro_last');
      String pro_email = prefs.getString('pro_email');
      String pro_add1 = prefs.getString('pro_add1');
      String pro_add2 = prefs.getString('pro_add2');
      String pro_city = prefs.getString('pro_city');
      String pro_postcode = prefs.getString('pro_postcode');
      String pro_state = prefs.getString('pro_state');
      String pro_country = prefs.getString('pro_country');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoAuthToken': token,
        'cargoUserId': UserId
      };

      Map data = {
        'first_name': pro_first,
        'last_name': pro_last,
        'company': "com",
        'address_1': pro_add1,
        'address_2': pro_add2,
        'city': pro_city,
        'state': pro_state,
        'postcode': pro_postcode,
        'country': pro_country,
      };

      Map data3 = {
        'first_name': pro_first,
        'last_name': pro_last,
        'company': "com",
        'address_1': pro_add1,
        'address_2': pro_add2,
        'city': pro_city,
        'state': pro_state,
        'postcode': pro_postcode,
        'country': pro_country,
      };

      Map data2 = {
        'email': pro_email.trim(),
        'first_name': pro_first,
        'last_name': pro_last,
        'shipping': data,
        'billing': data3,
      };

      String body = json.encode(data2);

      Response response = await post(
          'https://cargobgi.net/wp-json/wc/v3/customers/$UserId',
          headers: headers,
          body: body);

//
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');

UpdateCountryCode();


      return profileUpdateModel;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String phone=widget.phoneNumber;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text("Enter OTP",
            textColor: sh_textColorPrimary,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
      ),
      body: Container(
        width: width,
        height: height,
        color: sh_white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Container(
                padding: EdgeInsets.fromLTRB(20,0,20,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height*0.08,),
                    Row(children: [
                      Text("Confirm",style: TextStyle(color: sh_textColorPrimary,fontSize: 28,fontWeight: FontWeight.bold),),
                      SizedBox(width: 8,),
                      Text("your number",style: TextStyle(color: sh_textColorPrimary,fontSize: 28,fontWeight: FontWeight.bold),),
                    ],),
                    SizedBox(height: 12,),
                    Text("Enter the code we sent via SMS to "+phone,style: TextStyle(color: sh_textColorPrimary,fontSize: 13,fontWeight: FontWeight.normal),maxLines: 2,),
                    SizedBox(height: 20,),
                    PinEntryTextField2(
                      onSubmit: (String pin){
                        _submitOTP(pin);
                      },
                      fields: 6,
                      fontSize: textSizeLargeMedium,
                    ),

                    SizedBox(height: 30,),
                    Row(children: [
                      Text("Didn't get a code?",style: TextStyle(color: sh_textColorPrimary,fontSize: 12),),
                      SizedBox(width: 8,),
                      GestureDetector(
                          onTap: () {
                            _submitPhoneNumber();
                          },
                          child: Text("Send again",style: TextStyle(color: sh_app_background,fontSize: 13,fontWeight: FontWeight.bold),)),
                    ],),

                    SizedBox(height: 50,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      // height: double.infinity,
                      child: MaterialButton(
                        padding: EdgeInsets.all(spacing_standard),
                        child: text("Save Profile",
                            fontSize: textSizeNormal,
                            fontFamily: fontMedium,
                            textColor: sh_white),
                        textColor: sh_white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(40.0)),
                        color: sh_app_background,
                        onPressed: () {
                          // getCheck();
                        },
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
