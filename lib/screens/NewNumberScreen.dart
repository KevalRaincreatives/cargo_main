import 'dart:convert';

import 'package:cargo/model/NumberCheckModel.dart';
import 'package:cargo/screens/OtpNewScreen.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

class NewNumberScreen extends StatefulWidget {
  static String tag='/NewNumberScreen';
  @override
  _NewNumberScreenState createState() => _NewNumberScreenState();
}

class _NewNumberScreenState extends State<NewNumberScreen> {
  Country _selectedDialogCountry =
  CountryPickerUtils.getCountryByPhoneCode('1-246');
  TextEditingController _phoneNumberController = TextEditingController();
  String _status;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  AuthCredential _phoneAuthCredential;
  String _verificationId;
  int _code;
  NumberCheckModel numberCheckModel;

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

      String country="+"+_selectedDialogCountry.phoneCode;

      String urlEncoded = Uri.encodeFull(country);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      Response response = await get(
        'https://cargobgi.net/wp-json/v3/check_phone_new?phone_number=$phoneNumber&country_code=$urlEncoded',
      );

      // Response response = await get(
      //   'https://moco.bb/wp-json/v3/check_phone?phone_number=$phoneNumber&country_code=$urlEncoded',
      // );


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
      // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('verificationFailed');
      toast('verification Failed');
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
//      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtpNewScreen(
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


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text("Enter New Number",
            textColor: sh_textColorPrimary,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
      ),
      body: Container(
        width: width,
        height: height,
        color: sh_white,
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Container(
                decoration: boxDecoration(bgColor: sh_white, color: sh_textColorSecondary, showShadow: true, radius: 10),
                child: Column(

                  children: <Widget>[
                    ListTile(
                      onTap: _openCountryPickerDialog,
                      title: _buildDialogItem(_selectedDialogCountry),
                    ),
                    quizDivider(),
                    TextFormField(
                      style: TextStyle(fontSize: textSizeMedium, fontFamily: fontRegular),
                      obscureText: false,
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(16, 22, 16, 22),
                        hintText: "Phone Number",

                        border: InputBorder.none,
                        hintStyle: TextStyle(color: sh_textColorSecondary),
                      ),
                    )
                    // quizEditTextStyle("Phone Number"),
                  ],
                ),
              ),
              SizedBox(height: 12,),
              Text("we'll send you a message to confirm your number.",style: TextStyle(color: sh_textColorPrimary,fontSize: 13,fontWeight: FontWeight.bold,fontFamily: 'Regular'),),
              SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                height: 50,
                // height: double.infinity,
                child: MaterialButton(
                  padding: EdgeInsets.all(spacing_standard),
                  child: text("SEND",
                      fontSize: textSizeNormal,
                      fontFamily: fontMedium,
                      textColor: sh_white),
                  textColor: sh_white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(40.0)),
                  color: sh_app_background,
                  onPressed: () {
                    getCheck();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Divider quizDivider() {
  return Divider(
    height: 1,
    color: sh_textColorSecondary,
    thickness: 1,
  );
}