import 'dart:convert';
import 'dart:io';

import 'package:cargo/model/CountryModel.dart';
import 'package:cargo/model/CountryParishModel.dart';
import 'package:cargo/model/ErrorModel.dart';
import 'package:cargo/model/MetaDataModel.dart';
import 'package:cargo/model/ShLoginModel.dart';
import 'package:cargo/model/ShProductModel.dart';
import 'package:cargo/model/StateModel.dart';
import 'package:cargo/screens/DashboardScreen.dart';
import 'package:cargo/screens/LoginScreen.dart';
import 'package:cargo/screens/SignUpSuccessScreen.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterProfileScreen extends StatefulWidget {
  static String tag = '/EnterProfileScreen';
  final String country_code,fnlNumber;

  EnterProfileScreen({this.country_code,this.fnlNumber});

  @override
  _EnterProfileScreenState createState() => _EnterProfileScreenState();
}

class _EnterProfileScreenState extends State<EnterProfileScreen> {
  FirebaseMessaging _firebaseMessaging;
  var emailCont = TextEditingController();
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
  var parishCont= TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = true;
  Future countrydetail;
  List<CountryParishModel> countryModel;
  CountryParishModel countryNewModel;
  Countries selectedValue;
  ShLoginModel cat_model;
  var selectedStateValue;

  var statename="Christ Church";
  var countryname="Barbados";
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool _visible_drop = false;
  bool _visible_text = false;
  int parish_size = 0;
  bool _showPassword = false;
  bool _showCnfrmPassword = false;
  final List<MetaDataModel> metaModel = [];
  MetaDataModel itModel;
  ErrorModel err_model;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // firebaseCloudMessaging_Listeners();

    countrydetail = fetchcountry();
  }

  //
  // void firebaseCloudMessaging_Listeners() async {
  //   if (Platform.isIOS) iOS_Permission();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   _firebaseMessaging.getToken().then((token) {
  //     prefs.setString('device_id', token);
  //     print(token);
  //   });
  //
  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print('on message $message');
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print('on resume $message');
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('on launch $message');
  //     },
  //   );
  // }
  //
  // void iOS_Permission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true));
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     print("Settings registered: $settings");
  //   });
  // }

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


  Future<ShProductModel> getSetting() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      String first = firstNameCont.text;
      String last = lastNameCont.text;
      String username = emailCont.text;
      String email = emailCont.text;
      String password = passwordCont.text;
      String address1 = address1Cont.text;
      String address2 = address2Cont.text;
      String city = cityCont.text;
      String postcode = postalCont.text;
      String state = stateCont.text;
      String country = countryCont.text;
      String country_codes='+'+widget.country_code;
      if (!_visible_drop) {
        statename=parishCont.text;
      }

      itModel = MetaDataModel(
          key: 'country_code',
          value: country_codes);
      metaModel.add(itModel);

      Map data = {
        'first_name': first.trim(),
        'last_name': last.trim(),
        'company': "com",
        'address_1': address1.trim(),
        'address_2': address2.trim(),
        'city': city.trim(),
        'state': statename,
        'postcode': postcode.trim(),
        'country': countryname,
        'phone' : widget.fnlNumber,
        'country_code' : country_codes
      };

      Map data3 = {
        'first_name': first.trim(),
        'last_name': last.trim(),
        'company': "com",
        'address_1': address1.trim(),
        'address_2': address2.trim(),
        'city': city.trim(),
        'state': statename,
        'postcode': postcode.trim(),
        'country': countryname,
        'phone' : widget.fnlNumber,
        'country_code' : country_codes
      };



      Map data2 = {
        'email': email.trim(),
        'first_name': first.trim(),
        'last_name': last.trim(),
        'username': username.trim(),
        'password': password.trim(),
        'shipping': data,
        'billing': data3,
        'meta_data':metaModel
      };

      String body = json.encode(data2);

      Map<String, String> headers = {'Content-Type': 'application/json'};

      Response response = await post(
          Uri.parse('https://cargobgi.net/wp-json/wc/v3/customers'),
        headers: headers,
        body: body,
      );
//
//
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      if(response.statusCode==200 ||response.statusCode==201 ||response.statusCode==202) {
        getLogin();
      }else{
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        err_model = new ErrorModel.fromJson(jsonResponse);
        toast(err_model.code);
      }
      return null;
    } catch (e) {
//      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
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
          Uri.parse('https://cargobgi.net/wp-json/v3/add_device'),
        headers: headers,
        body: msg,
      );

      final jsonResponse = json.decode(response.body);
      print('device json $jsonResponse');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      launchScreen(context, DashboardScreen.tag);
      print('sucess');
      return cat_model;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }


  Future<ShLoginModel> getLogin() async {
    try {
      String username = emailCont.text;
      String password = passwordCont.text;

      Map data = {
        'username': username,
        'password': password,
      };
      Map<String,String> headers = {'Content-Type':'application/json'};
      final msg = jsonEncode({"username":username,"password":password});


      Response response = await post(
          Uri.parse('https://cargobgi.net/wp-json/jwt-auth/v1/token'),
        headers: headers,
        body: msg,
      );

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      cat_model = new ShLoginModel.fromJson(jsonResponse);
      print("cat dta$cat_model");
//      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      if (cat_model.token.length>10) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', cat_model.token);
        prefs.setString('UserId', cat_model.userId.toString());
        prefs.setString('UserName', cat_model.userDisplayName);
        prefs.setString('UserType', 'Normal');
        prefs.commit();
        SaveToken();
//        launchScreen(context, DashboardScreen.tag);
        print('sucess');
      }else{
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        toast('Something Went Wrong');
      }
      return cat_model;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }

  Future<CountryParishModel> fetchcountry() async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};

      Response response =
      await get(Uri.parse('https://cargobgi.net/wp-json/v3/countries'));
      final jsonResponse = json.decode(response.body);

      countryNewModel = new CountryParishModel.fromJson(jsonResponse);
      for (var i = 0; i < countryNewModel.countries.length; i++) {
        if (countryNewModel.countries[i].country == countryname) {
          selectedValue = countryNewModel.countries[i];

          if (countryNewModel.countries[i].parishes.length > 0) {
            _visible_drop = true;
            _visible_text = false;
          } else {
            _visible_drop = false;
            _visible_text = true;
          }

          for (var j = 0; j < countryNewModel.countries[i].parishes.length; j++) {
            if (countryNewModel.countries[i].parishes[j].name == statename) {
              selectedStateValue = countryNewModel.countries[i].parishes[j];
            }
          }
        }
      }
      print('Caught error ');

      return countryNewModel;
    } catch (e) {
      print('Caught error $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final node = FocusScope.of(context);

    FirstName() {
      return TextFormField(
        keyboardType: TextInputType.text,
        controller: firstNameCont,
        onEditingComplete: () => node.nextFocus(),
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        style: TextStyle(
            color: sh_yellow,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please Enter First Name';
          }
          return null;
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: sh_transparent,
            focusColor: sh_colorPrimary,
            hintText: sh_hint_first_name,
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

    LastName() {
      return TextFormField(
        keyboardType: TextInputType.text,
        controller: lastNameCont,
        onEditingComplete: () => node.nextFocus(),
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        style: TextStyle(
            color: sh_yellow,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please Enter Last Name';
          }
          return null;
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: sh_transparent,
            focusColor: sh_colorPrimary,
            hintText: sh_hint_last_name,
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


    Email() {
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: emailCont,
        onEditingComplete: () => node.nextFocus(),
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        style: TextStyle(
            color: sh_yellow,
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
            fillColor: sh_transparent,
            focusColor: sh_colorPrimary,
            hintText: sh_hint_enter_your_email_id,
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
        onEditingComplete: () => node.nextFocus(),
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
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
            filled: true,
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

    ConfirmPassword() {
      return TextFormField(
        autofocus: false,
        obscureText: !this._showCnfrmPassword,
        keyboardType: TextInputType.text,
        controller: confirmPasswordCont,
        onEditingComplete: () => node.nextFocus(),
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        style: TextStyle(
            color: sh_yellow,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please Enter Confirm Password';
          }
          if(text != passwordCont.text) {
            return 'Password Do Not Match';
          }
          return null;
        },
        decoration: InputDecoration(
            filled: false,
            fillColor: sh_transparent,
            focusColor: sh_colorPrimary,
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
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: sh_yellow, width: 1)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: sh_yellow, width: 0.5))),
      );
    }


    Address1() {
      return TextFormField(
        keyboardType: TextInputType.text,
        controller: address1Cont,
        onEditingComplete: () => node.nextFocus(),
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        style: TextStyle(
            color: sh_yellow,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please Enter Address';
          }
          return null;
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: sh_transparent,
            focusColor: sh_colorPrimary,
            hintText: sh_hint_address1,
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

    Address2() {
      return TextFormField(
        keyboardType: TextInputType.text,
        controller: address2Cont,
        onEditingComplete: () => node.nextFocus(),
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        style: TextStyle(
            color: sh_yellow,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please Enter Address';
          }
          return null;
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: sh_transparent,
            focusColor: sh_colorPrimary,
            hintText: sh_hint_address2,
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

    City() {
      return TextFormField(
        keyboardType: TextInputType.text,
        controller: cityCont,
        onEditingComplete: () => node.nextFocus(),
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        style: TextStyle(
            color: sh_yellow,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please Enter City';
          }
          return null;
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: sh_transparent,
            focusColor: sh_colorPrimary,
            hintText: sh_hint_city,
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

    PostalCode() {
      return TextFormField(
        // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        // keyboardType: TextInputType.numberWithOptions(
        //     signed: true, decimal: true),
        controller: postalCont,
        onEditingComplete: () => node.nextFocus(),
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        style: TextStyle(
            color: sh_yellow,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please Enter Postal';
          }
          return null;
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: sh_transparent,
            focusColor: sh_colorPrimary,
            hintText: sh_hint_pin_code,
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

    Countrys() {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: sh_yellow, width: 0.5),
        ),
        child: DropdownButton<Countries>(
          underline: SizedBox(),
          isExpanded: true,
          items: countryNewModel.countries.map((item) {
            return new DropdownMenuItem(
              child: Text(
                item.country,
                style: TextStyle(
                    color: sh_app_black,
                    fontFamily: fontRegular,
                    fontSize: textSizeNormal),
              ),
              value: item,
            );
          }).toList(),
          hint: Text('Select Country'),
          value: selectedValue,
          onChanged: (Countries newVal) {
            setState(() {

              selectedValue = newVal;
              countryname=newVal.country;

              parish_size = newVal.parishes.length;
              if (newVal.parishes.length > 0) {
                selectedStateValue = newVal.parishes[0];
                _visible_drop = true;
                _visible_text = false;
              } else {
                _visible_drop = false;
                _visible_text = true;
              }
            });
          },
        ),
      );
    }

    State() {
      if (_visible_drop) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: sh_yellow, width: 0.5),
          ),
          child: DropdownButton<Parishes>(
            underline: SizedBox(),
            isExpanded: true,
            items: selectedValue.parishes.map((item) {
              return new DropdownMenuItem(
                child: Text(
                  item.name,
                  style: TextStyle(
                      color: sh_app_black,
                      fontFamily: fontRegular,
                      fontSize: textSizeNormal),
                ),
                value: item,
              );
            }).toList(),
            hint: Text('Select Parish'),
            value: selectedStateValue,
            onChanged: (Parishes newVal) {
              setState(() {
                selectedStateValue = newVal;
                statename=newVal.name;
              });
            },
          ),
        );
      } else {
        return TextFormField(
          keyboardType: TextInputType.text,
          controller: parishCont,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
              color: sh_yellow,
              fontFamily: fontRegular,
              fontSize: textSizeMedium),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Please Enter Parish';
            }
            return null;
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: sh_transparent,
              focusColor: sh_colorPrimary,
              hintText: sh_hint_parish,
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
    }


    mainList() {
      return FutureBuilder<CountryParishModel>(
          future: countrydetail,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return CupertinoActivityIndicator(
                animating: true,
              );
            return Column(
              children: <Widget>[Countrys(),
                SizedBox(height: 20,),
                State(),
                SizedBox(height: 20,),],
            );
          });
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
                            'Please enter your',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'profile information',
                            style: TextStyle(fontSize: 20, color: sh_yellow),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FirstName(),
                          SizedBox(
                            height: 20,
                          ),
                          LastName(),
                          SizedBox(
                            height: 20,
                          ),
                          Email(),
                          SizedBox(
                            height: 20,
                          ),
                          Password(),
                          SizedBox(
                            height: 20,
                          ),
                          ConfirmPassword(),
                          SizedBox(
                            height: 20,
                          ),

                          Address1(),
                          SizedBox(
                            height: 20,
                          ),
                          Address2(),
                          SizedBox(
                            height: 20,
                          ),
                          City(),
                          SizedBox(
                            height: 20,
                          ),
                          PostalCode(),
                          SizedBox(
                            height: 20,
                          ),
                          mainList(),
                          SizedBox(height: 130,)


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
