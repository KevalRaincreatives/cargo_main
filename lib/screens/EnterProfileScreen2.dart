import 'dart:convert';

import 'package:cargo/model/CountryModel.dart';
import 'package:cargo/model/ShProductModel.dart';
import 'package:cargo/model/StateModel.dart';
import 'package:cargo/screens/LoginScreen.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
class EnterProfileScreen2 extends StatefulWidget {
  static String tag = '/EnterProfileScreen2';
  final String country_code,fnlNumber;

  EnterProfileScreen2({this.country_code,this.fnlNumber});

  @override
  _EnterProfileScreen2State createState() => _EnterProfileScreen2State();
}

class _EnterProfileScreen2State extends State<EnterProfileScreen2> {
  var emailCont = TextEditingController();
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
  Future countrydetail;
  List<CountryModel> countryModel;
  var selectedValue;
  var selectedcountry="us";

  Future statedetail;
  StateHModel stateModel;
  var selectedStateValue;

  var statename="us";
  var countryname="us";
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var codi='US';

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    countrydetail = fetchcountry();
    statedetail=fetchstate(codi);
  }

  Future<ShProductModel> getSetting() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      String first = firstNameCont.text;
      String last = lastNameCont.text;
      String username = userNameCont.text;
      String email = emailCont.text;
      String password = passwordCont.text;
      String address1 = address1Cont.text;
      String address2 = address2Cont.text;
      String city = cityCont.text;
      String postcode = postalCont.text;
      String state = stateCont.text;
      String country = countryCont.text;
      String country_codes='+'+widget.country_code;

      Map data = {
        'first_name': first,
        'last_name': last,
        'company': "com",
        'address_1': address1,
        'address_2': address2,
        'city': city,
        'state': statename,
        'postcode': postcode,
        'country': countryname,
        'phone' : widget.fnlNumber,
        'country_code' : country_codes
      };

      Map data3 = {
        'first_name': first,
        'last_name': last,
        'company': "com",
        'address_1': address1,
        'address_2': address2,
        'city': city,
        'state': statename,
        'postcode': postcode,
        'country': countryname,
        'phone' : widget.fnlNumber,
        'country_code' : country_codes
      };

      Map data2 = {
        'email': email,
        'first_name': first,
        'last_name': last,
        'username': username,
        'password': password,
        'shipping': data,
        'billing': data3
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
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      toast('Registration Success');
      launchScreen(context, LoginScreen.tag);
      return null;
    } catch (e) {
//      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }

  Future<List<CountryModel>> fetchcountry() async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};
//      var r = await Requests.get(
//          'https://cargobgi.net/wp-json/wc/v3/data/countries/');
//
//      r.raiseForStatus();
//      String body = r.content();
//      print(body);
//
//
//      final jsonResponse = json.decode(body).;

      Response response = await get(
          Uri.parse('https://cargobgi.net/wp-json/wc/v3/data/countries/'));
      final jsonResponse =
      json.decode(response.body).cast<Map<String, dynamic>>();

      countryModel = jsonResponse.map<CountryModel>((json) {
        return CountryModel.fromJson(json);
      }).toList();

//      countryModel = new CountryModel.fromJson(jsonResponse[0]);
      return countryModel;
//      return jsonResponse.map((job) => new CountryModel.fromJson(job)).toList();
    } catch (e) {
      print('Caught error $e');
    }
  }

  Future<StateHModel> fetchstate(String codes) async {
    try {
      Response response = await get(
          Uri.parse('https://cargobgi.net/wp-json/wc/v3/data/countries/$codes'));

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      stateModel = new StateHModel.fromJson(jsonResponse);
      return stateModel;
    } catch (e) {
      print('Caught error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    FirstName() {
      return TextFormField(
        keyboardType: TextInputType.text,
        controller: firstNameCont,
        textCapitalization: TextCapitalization.words,
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
        textCapitalization: TextCapitalization.words,
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

    Username() {
      return TextFormField(
        keyboardType: TextInputType.text,
        controller: userNameCont,
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

    Email() {
      return TextFormField(
        keyboardType: TextInputType.text,
        controller: emailCont,
        textCapitalization: TextCapitalization.words,
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
        keyboardType: TextInputType.text,
        controller: passwordCont,
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
            filled: true,
            fillColor: sh_transparent,
            focusColor: sh_colorPrimary,
            hintText: sh_hint_password,
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
        keyboardType: TextInputType.text,
        controller: confirmPasswordCont,
        textCapitalization: TextCapitalization.words,
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
            filled: true,
            fillColor: sh_transparent,
            focusColor: sh_colorPrimary,
            hintText: sh_hint_confirm_password,
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
        textCapitalization: TextCapitalization.words,
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
        textCapitalization: TextCapitalization.words,
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
        textCapitalization: TextCapitalization.words,
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
        keyboardType: TextInputType.text,
        controller: postalCont,
        textCapitalization: TextCapitalization.words,
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
      return FutureBuilder<List<CountryModel>>(
          future: countrydetail,
          builder: (BuildContext context,
              AsyncSnapshot<List<CountryModel>> snapshot) {
            if (!snapshot.hasData)
              return CupertinoActivityIndicator(
                animating: true,
              );
            return DropdownButton<CountryModel>(
              underline: SizedBox(),
              isExpanded: true,
              items: snapshot.data
                  .map((countyState) => DropdownMenuItem<CountryModel>(
                child: Text(
                  countyState.name,
                  style: TextStyle(
                      color: sh_app_black,
                      fontFamily: fontRegular,
                      fontSize: textSizeNormal),
                ),
                value: countyState,
              ))
                  .toList(),
              hint:Text('Select Country'),
              value: selectedValue,
              onChanged: (CountryModel newVal) {
                setState(() {
                  selectedStateValue=null;
                  selectedValue = newVal;
                  selectedcountry=newVal.code;
                  countryname=newVal.code;
                  statedetail=fetchstate(newVal.code);
                });
              },
            );
          });
    }

    State() {
      return FutureBuilder<StateHModel>(
          future: statedetail,
          builder: (BuildContext context,
              AsyncSnapshot<StateHModel> snapshot) {
            if (!snapshot.hasData)
              return CupertinoActivityIndicator(
                animating: true,
              );
            return DropdownButton<States>(
              underline: SizedBox(),
              isExpanded: true,
              items: snapshot.data.states
                  .map((countyState) => DropdownMenuItem<States>(
                child: Text(
                  countyState.name,
                  style: TextStyle(
                      color: sh_app_black,
                      fontFamily: fontRegular,
                      fontSize: textSizeNormal),
                ),
                value: countyState,
              ))
                  .toList(),
              hint:Text('Select State'),
              value: selectedStateValue,
              onChanged: (States newVal) {
                setState(() {
                  selectedStateValue = newVal;
                  statename=newVal.name;
                });
              },
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
                          Username(),
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
                          State(),
                          SizedBox(
                            height: 20,
                          ),
                          Countrys(),
//                          Row(
//                            children: <Widget>[
//                              Expanded(
//                                child: ListTileTheme(
//                                  contentPadding: EdgeInsets.all(0),
//                                  iconColor: sh_white,
//                                  child: CheckboxListTile(
//                                    checkColor: sh_white,
//                                    title: Text(
//                                      "Male",
//                                      style: TextStyle(
//                                          color: sh_white, fontSize: 13),
//                                    ),
//                                    value: _isChecked,
//                                    onChanged: (newValue) {
//                                      setState(() {
//                                        _isChecked = newValue;
//                                      });
//                                    },
//                                    controlAffinity: ListTileControlAffinity
//                                        .leading, //  <-- leading Checkbox
//                                  ),
//                                ),
//                              ),
//                              Expanded(
//                                child: ListTileTheme(
//                                  contentPadding: EdgeInsets.all(0),
//                                  iconColor: sh_white,
//                                  child: CheckboxListTile(
//                                    checkColor: sh_white,
//                                    title: Text(
//                                      "Female",
//                                      style: TextStyle(
//                                          color: sh_white, fontSize: 13),
//                                    ),
//                                    value: _isChecked,
//                                    onChanged: (newValue) {
//                                      setState(() {
//                                        _isChecked = newValue;
//                                      });
//                                    },
//                                    controlAffinity: ListTileControlAffinity
//                                        .leading, //  <-- leading Checkbox
//                                  ),
//                                ),
//                              ),
//                            ],
//                          )
                        ],
                      ),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0,8.0,8,8),
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                      iconSize: 20,
                                      icon: new Image.asset(
                                        cargo_back_arrow,
                                        color: Colors.white,
                                        height: 24,
                                        width: 24,
                                      ),
                                      onPressed: () {}),
                                  Text(
                                    'Back',
                                    style:
                                    TextStyle(color: sh_white, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                // TODO submit
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                getSetting();
                              }
//                              launchScreen(context, SignUpSuccessScreen.tag);
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0,8,0,8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'Continue',
                                    style:
                                    TextStyle(color: sh_yellow, fontSize: 16),
                                  ),
                                  IconButton(
                                      iconSize: 20,
                                      icon: new Image.asset(
                                        cargo_right_arrow,
                                        color: sh_yellow,
                                        height: 24,
                                        width: 24,
                                      ),
                                      onPressed: () {
//                                      launchScreen(
//                                          context, SignUpSuccessScreen.tag);
                                      }),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
