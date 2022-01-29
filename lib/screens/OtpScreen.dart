import 'package:cargo/screens/EnterProfileScreen.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nb_utils/nb_utils.dart';

class OtpScreen extends StatefulWidget {
  static String tag='/OtpScreen';
  final String verificationId,phoneNumber,country_code,fnlNumber;

  OtpScreen({this.verificationId,this.phoneNumber,this.country_code,this.fnlNumber});
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var emailCont = TextEditingController();
//  String _verificationId;
  FirebaseUser _firebaseUser;
  String _status;
  String _verificationId='';
  int _code;

  AuthCredential _phoneAuthCredential;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EnterProfileScreen(
                country_code: widget.country_code,
                fnlNumber: widget.fnlNumber
            )),
      );
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
    /// get the `smsCode` from the user
//    String smsCode = _otpController.text.toString().trim();

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
//    this._phoneAuthCredential = PhoneAuthProvider.getCredential(
//        verificationId: widget.verificationId, smsCode: pin);

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
      this._code = code;
      print(code.toString());
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

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    String phone=widget.phoneNumber;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.phone_android,color: sh_yellow,size: 60,),
                      SizedBox(height: 30,),
                      Text('We have sent you a',style: TextStyle(fontSize: 20,color: Colors.white),),
                      SizedBox(height: 2,),
                      Text('one time password',style: TextStyle(fontSize: 20,color: sh_yellow),),
                      SizedBox(height: 30,),
                      Text('Enter the  6 digit we have sent to $phone to proceed',style: TextStyle(fontSize: 12,color: Colors.white),),
                      SizedBox(height: 40,),
                      PinEntryTextField(
                        onSubmit: (String pin){
                          _submitOTP(pin);
                        },
                        fields: 6,
                        fontSize: textSizeLargeMedium,
                      ),

                      SizedBox(height: 30,),
                      Row(children: [
                        Text("Didn't get a code?",style: TextStyle(color: Colors.white,fontSize: 12),),
                        SizedBox(width: 8,),
                        GestureDetector(
                            onTap: () {
                              _submitPhoneNumber();
                            },
                            child: Text("Send again",style: TextStyle(color: sh_yellow,fontSize: 13,fontWeight: FontWeight.bold),)),
                      ],),

                    ],)),
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
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        height: 44,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: sh_yellow, width: 1.0)),
                        child: GestureDetector(
                            onTap: () {

                            },
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
