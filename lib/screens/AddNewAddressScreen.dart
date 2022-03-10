import 'dart:convert';

import 'package:cargo/model/AddressListModel.dart';
import 'package:cargo/model/CountryParishModel.dart';
import 'package:cargo/model/ShipingAddressModel.dart';
import 'package:cargo/model/StateModel.dart';
import 'package:cargo/screens/MyAddressScreen.dart';
import 'package:cargo/screens/SelectDeliveryScreen.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewAddressScreen extends StatefulWidget {
  static String tag = '/AddNewAddressScreen';

  dynamic addressModel = AddressListModel();

  AddNewAddressScreen({this.addressModel});

  @override
  _AddNewAddressScreenState createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  var primaryColor;
  var firstNameCont = TextEditingController();
  var lastNameCont = TextEditingController();
  var pinCodeCont = TextEditingController();
  var cityCont = TextEditingController();
  var stateCont = TextEditingController();
  var addressCont = TextEditingController();
  var addressCont2 = TextEditingController();
  var emailCont = TextEditingController();
  var nicknameCont = TextEditingController();
  var phoneNumberCont = TextEditingController();
  var countryCont = TextEditingController();
  var parishCont = TextEditingController();


  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  Future countrydetail;
  List<CountryParishModel> countryModel;
  CountryParishModel countryNewModel;
  Countries selectedValue;
  var selectedStateValue;
  var statename = "Christ Church";
  var countryname = "Barbados";
  bool _visible_drop = false;
  bool _visible_text = false;
  int parish_size = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.addressModel != null) {
      nicknameCont.text = widget.addressModel.shippingAddressNickname;
      pinCodeCont.text = widget.addressModel.shippingPostcode;
      addressCont.text = widget.addressModel.shippingAddress1;
      addressCont2.text = widget.addressModel.shippingAddress2;
      cityCont.text = widget.addressModel.shippingCity;
      stateCont.text = widget.addressModel.shippingState;
      countryCont.text = widget.addressModel.shippingCountry;
      firstNameCont.text = widget.addressModel.shippingFirstName;
      lastNameCont.text = widget.addressModel.shippingLastName;
      parishCont.text = widget.addressModel.shippingState;

      countryname = widget.addressModel.shippingCountry;
      statename = widget.addressModel.shippingState;
      countrydetail = fetchcountry();
    } else {
      countrydetail = fetchcountry();
    }
  }

  Future<Parishes> SaveAddress() async {
    String email = emailCont.text;
    String first = firstNameCont.text;
    String last = lastNameCont.text;
    String phone = phoneNumberCont.text;
    String city = cityCont.text;
    String pincode = pinCodeCont.text;
    String address1 = addressCont.text;
    String address2 = addressCont2.text;
    String nickname = nicknameCont.text;
    if (!_visible_drop) {
      statename=parishCont.text;
    }

    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      Map data = {
        'shipping_address_nickname': nickname.trim(),
        'shipping_first_name': first.trim(),
        'shipping_last_name': last.trim(),
        'shipping_company': "com",
        'shipping_address_1': address1.trim(),
        'shipping_address_2': address2.trim(),
        'shipping_city': city.trim(),
        'shipping_state': statename,
        'shipping_postcode': pincode.trim(),
        'shipping_country': countryname,
      };

      Map data2 = {
        'shipping': data,
      };

      String body = json.encode(data2);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'CargoAuthToken': token,
        'CargoUserId': UserId
      };

      Response response = await post(
          Uri.parse('https://cargobgi.net/wp-json/v3/add_address'),
        headers: headers,
        body: body,
      );

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
//      saveAddressModel = new SaveAddressModel.fromJson(jsonResponse);

//      toast(saveAddressModel.msg);

      String pages=prefs.getString('pages');
      if(pages=='delivery'){
        Route route = MaterialPageRoute(
            builder: (context) => SelectDeliveryScreen());
        Navigator.pushReplacement(context, route);
      }else {
        Route route = MaterialPageRoute(
            builder: (context) => MyAddressScreen());
        Navigator.pushReplacement(context, route);
      }
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<Parishes> UpdateAddress() async {
    String first = firstNameCont.text;
    String last = lastNameCont.text;
    String phone = phoneNumberCont.text;
    String city = cityCont.text;
    String pincode = pinCodeCont.text;
    String address1 = addressCont.text;
    String address2 = addressCont2.text;
    String nickname = nicknameCont.text;
    String ship_name = widget.addressModel.name;
    if (!_visible_drop) {
      statename=parishCont.text;
    }
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      Map data = {
        'name': ship_name,
        'shipping_address_nickname': nickname.trim(),
        'shipping_first_name': first.trim(),
        'shipping_last_name': last.trim(),
        'shipping_company': "com",
        'shipping_address_1': address1.trim(),
        'shipping_address_2': address2.trim(),
        'shipping_city': city.trim(),
        'shipping_state': statename,
        'shipping_postcode': pincode.trim(),
        'shipping_country': countryname,
      };

      Map data2 = {
        'shipping': data,
      };

      String body = json.encode(data2);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'CargoAuthToken': token,
        'CargoUserId': UserId
      };

      Response response = await post(
          Uri.parse('https://cargobgi.net/wp-json/v3/edit_address'),
        headers: headers,
        body: body,
      );

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      toast('Updated');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
//      saveAddressModel = new SaveAddressModel.fromJson(jsonResponse);

//      toast(saveAddressModel.msg);
      String pages=prefs.getString('pages');
      if(pages=='delivery'){
        Route route = MaterialPageRoute(
            builder: (context) => SelectDeliveryScreen());
        Navigator.pushReplacement(context, route);
      }else {
        Route route = MaterialPageRoute(
            builder: (context) => MyAddressScreen());
        Navigator.pushReplacement(context, route);
      }
    } catch (e) {
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
//      return jsonResponse.map((job) => new CountryModel.fromJson(job)).toList();
    } catch (e) {
      print('Caught error $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    void onSaveClicked() async {
      if (widget.addressModel != null) {
        UpdateAddress();
      } else {
        SaveAddress();
      }
    }

    final firstName = TextFormField(
      controller: firstNameCont,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      autofocus: false,
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      decoration: formFieldDecoration(sh_hint_first_name),
    );

    final lastName = TextFormField(
      controller: lastNameCont,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      autofocus: false,
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      decoration: formFieldDecoration(sh_hint_last_name),
    );

    final pinCode = TextFormField(
      controller: pinCodeCont,
      // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      // keyboardType: TextInputType.numberWithOptions(
      //     signed: true, decimal: true),
      // maxLength: 6,
      autofocus: false,
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      textInputAction: TextInputAction.next,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      decoration: formFieldDecoration(sh_hint_pin_code),
    );

    final city = TextFormField(
      controller: cityCont,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      textInputAction: TextInputAction.next,
      autofocus: false,
      decoration: formFieldDecoration(sh_hint_city),
    );

    countryList() {
      return DropdownButton<Countries>(
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
      );
    }

    stateList() {
      if (_visible_drop) {
        return DropdownButton<Parishes>(
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
        );
      } else {
        return TextFormField(
          controller: parishCont,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
              fontFamily: fontRegular, fontSize: textSizeMedium),
          onFieldSubmitted: (term) {
            FocusScope.of(context).nextFocus();
          },
          textInputAction: TextInputAction.next,
          autofocus: false,
          decoration: formFieldDecoration(sh_hint_parish),
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
              children: <Widget>[countryList(),
                SizedBox(height: 12,),
                stateList()],
            );
          });
    }

    final address = TextFormField(
      controller: addressCont,
      keyboardType: TextInputType.text,
      maxLines: 1,
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      autofocus: false,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      decoration: formFieldDecoration(sh_hint_address1),
    );

    final address2 = TextFormField(
      controller: addressCont2,
      keyboardType: TextInputType.text,
      maxLines: 1,
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      autofocus: false,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      decoration: formFieldDecoration(sh_hint_address2),
    );

    final email = TextFormField(
      controller: emailCont,
      keyboardType: TextInputType.text,
      maxLines: 1,
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      autofocus: false,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      decoration: formFieldDecoration(sh_hint_email),
    );

    final nickname = TextFormField(
      controller: nicknameCont,
      keyboardType: TextInputType.text,
      maxLines: 1,
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      autofocus: false,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      decoration: formFieldDecoration(sh_hint_nickname_address),
    );

    final phoneNumber = TextFormField(
      controller: phoneNumberCont,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      maxLength: 10,
      autofocus: false,
      decoration: formFieldDecoration(sh_hint_contact),
    );

    final saveButton = MaterialButton(
      height: 50,
      minWidth: double.infinity,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
      onPressed: () {
        if (firstNameCont.text.isEmpty) {
          toast("First name required");
        } else if (lastNameCont.text.isEmpty) {
          toast("Last name required");
        } else if (addressCont.text.isEmpty) {
          toast("Address required");
        } else if (cityCont.text.isEmpty) {
          toast("City name required");
        } else if (pinCodeCont.text.isEmpty) {
          toast("Pincode required");
        } else {
          onSaveClicked();
        }
      },
      color: sh_app_background,
      child: text(sh_lbl_save_address,
          fontFamily: fontMedium,
          fontSize: textSizeLargeMedium,
          textColor: sh_white),
    );

    body() {
      return Wrap(runSpacing: spacing_standard_new, children: <Widget>[
        nickname,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child: firstName),
            SizedBox(
              width: spacing_standard_new,
            ),
            Expanded(child: lastName),
          ],
        ),
        address,
        address2,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child: city),
            SizedBox(
              width: spacing_standard_new,
            ),
            Expanded(child: pinCode),
          ],
        ),
        mainList(),
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
          child: saveButton,
        ),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text(
            widget.addressModel == null
                ? sh_lbl_add_new_address
                : sh_lbl_edit_address,
            textColor: sh_textColorPrimary,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actionsIconTheme: IconThemeData(color: sh_textColorPrimary),
      ),
      body: Container(
          width: double.infinity,
          child: SingleChildScrollView(child: body()),
          margin: EdgeInsets.all(16)),
    );
  }
}
