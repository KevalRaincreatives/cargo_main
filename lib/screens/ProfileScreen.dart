import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cargo/model/CountryModel.dart';
import 'package:cargo/model/CountryParishModel.dart';
import 'package:cargo/model/ProfileModel.dart';
import 'package:cargo/model/ViewCodeModel.dart';
import 'package:cargo/model/ViewProModel.dart';
import 'package:cargo/model/profile_model.dart';
import 'package:cargo/screens/ChangePasswordScreen.dart';
import 'package:cargo/screens/MyAccountScreen.dart';
import 'package:cargo/screens/NewNumberScreen.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cargo/model/ViewCodeModel.dart';

class ProfileScreen extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var emailCont = TextEditingController();
  var firstNameCont = TextEditingController();
  var lastNameCont = TextEditingController();
  var pinCodeCont = TextEditingController();
  var cityCont = TextEditingController();
  var stateCont = TextEditingController();
  var addressCont = TextEditingController();
  var addressCont2 = TextEditingController();
  var nicknameCont = TextEditingController();
  var phoneNumberCont = TextEditingController();
  var countryCont = TextEditingController();
  var parishCont = TextEditingController();

  ProfileUpdateModel profileUpdateModel;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  ProfileModel profileModel;

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
  int new_car = 0;
  File _image;
  String fnl_img = 'https://secure.gravatar.com/avatar/598b1f668254d0f7097133846aa32daf?s=96&d=mm&r=g';
  final picker = ImagePicker();
  ViewProModel viewProModel;
  ViewCodeModel viewCodeModel;

  @override
  void initState() {
    super.initState();
    fetchDetails();
    // ViewCountryCode();
    countrydetail = fetchcountry();
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

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;

      UploadPic();
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;


      UploadPic();
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future<CountryParishModel> UploadPic() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };

      File fls = _image;
      // String fileName = _image.toString().split('/').last;
      // print(fileName);
      String img = _image.toString().substring(0, _image
          .toString()
          .length - 1);
      String fileName = img
          .toString()
          .split('/')
          .last;
      print(fileName);
      Uint8List bytes = fls.readAsBytesSync();
      String base64Image = base64Encode(bytes);

      final msg = jsonEncode({
        "customer_id": UserId,
        "name": fileName,
        "profile_picture": base64Image,
      });
      print(fileName);


      Response response = await post(
          'https://cargobgi.net/wp-json/v3/update_profile_picture',
          headers: headers,
          body: msg);
      print('Response body: ${response.body}');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');

      toast('Uploaded');
      // order_det_model = new OrderDetailModel.fromJson(jsonResponse);
      return null;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }

  Future<ViewProModel> ViewProfilePic() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };


      final msg = jsonEncode({
        "customer_id": UserId,
      });
      print(msg);

      Response response = await post(
          'https://cargobgi.net/wp-json/v3/view_profile_picture',
          headers: headers,
          body: msg);
      print('Response body: ${response.body}');
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      viewProModel = new ViewProModel.fromJson(jsonResponse);

      fnl_img = viewProModel.profile_picture;



      return viewProModel;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }

  Future<ViewCodeModel> ViewCountryCode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };


      final msg = jsonEncode({
        "customer_id": UserId,
      });
      print(msg);

      Response response = await post(
          'https://cargobgi.net/wp-json/v3/view_country_code',
          headers: headers,
          body: msg);
      print('Response body: ${response.body}');
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      viewCodeModel = new ViewCodeModel.fromJson(jsonResponse);
      // setState(() {
        phoneNumberCont.text =
            viewCodeModel.country_code + profileModel.billing.phone;
      // });


      return viewCodeModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<CountryParishModel> fetchcountry() async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};

      Response response =
      await get('https://cargobgi.net/wp-json/v3/countries');
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

          for (var j = 0;
          j < countryNewModel.countries[i].parishes.length;
          j++) {
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

  Future<ProfileUpdateModel> getUpdate() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      String email = emailCont.text;
      String firstname = firstNameCont.text;
      String lastname = lastNameCont.text;
      String address1 = addressCont.text;
      String address2 = addressCont2.text;
      String city = cityCont.text;
      String postcode = pinCodeCont.text;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoAuthToken': token,
        'cargoUserId': UserId
      };

//      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
//      final msg = jsonEncode({"email": email,"first_name":firstname,"last_name":lastname});
      if (!_visible_drop) {
        statename = parishCont.text;
      }

      Map data = {
        'first_name': firstname,
        'last_name': lastname,
        'company': "com",
        'address_1': address1.trim(),
        'address_2': address2,
        'city': city,
        'state': statename,
        'postcode': postcode,
        'country': countryname,
      };

      Map data3 = {
        'first_name': firstname,
        'last_name': lastname,
        'company': "com",
        'address_1': address1,
        'address_2': address2,
        'city': city,
        'state': statename,
        'postcode': postcode,
        'country': countryname,
      };

      Map data2 = {
        'email': email.trim(),
        'first_name': firstname,
        'last_name': lastname,
        'shipping': data,
        'billing': data3,
      };

      String body = json.encode(data2);

      Response response = await post(
          'https://cargobgi.net/wp-json/wc/v3/customers/$UserId',
          headers: headers,
          body: body);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

//
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      toast('Updated');

//      profileUpdateModel = new ProfileUpdateModel.fromJson(jsonResponse);
      Route route = MaterialPageRoute(builder: (context) => MyAccountScreen());
      Navigator.pushReplacement(context, route);
//      if (profileUpdateModel.status == 'y') {
//        SharedPreferences prefs = await SharedPreferences.getInstance();
//        prefs.setString("username", username);
//        prefs.setString('user_email', email);
//        prefs.commit();
//
//        showDialog<void>(
//            context: context,
//            barrierDismissible: true,
//            builder: (context) => AlertDialog(
//                  title: Text('success'),
//                  content: SingleChildScrollView(
//                    child: Text(profileUpdateModel.data.message),
//                  ),
//                  actions: <Widget>[
//                    FlatButton(
//                      child: Text("OK"),
//                      onPressed: () {
//                        Navigator.of(context, rootNavigator: true).pop();
////                    launchScreen(context, ShHomeScreen.tag);
//                      },
//                    ),
//                  ],
//                ));
//        print('sucess');
//      }
      return profileUpdateModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<ProfileModel> fetchDetails() async {
//    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoauthtoken': token,
        'cargouserid': UserId
      };

      Response response = await get(
          'https://cargobgi.net/wp-json/wc/v3/customers/$UserId',
          headers: headers);

      final jsonResponse = json.decode(response.body);
      print('Response body: ${response.body}');
      profileModel = new ProfileModel.fromJson(jsonResponse);
      if (new_car == 0) {
        firstNameCont.text = profileModel.firstName;
        lastNameCont.text = profileModel.lastName;
        emailCont.text = profileModel.email;
        addressCont.text = profileModel.shipping.address1;
        addressCont2.text = profileModel.shipping.address2;
        cityCont.text = profileModel.shipping.city;
        pinCodeCont.text = profileModel.shipping.postcode;
        stateCont.text = profileModel.shipping.state;
        countryCont.text = profileModel.shipping.country;
        parishCont.text = profileModel.shipping.state;
        phoneNumberCont.text=profileModel.billing.phone;

        countryname = profileModel.shipping.country;
        statename = profileModel.shipping.state;


        prefs.setString('pro_first', profileModel.firstName);
        prefs.setString('pro_last', profileModel.lastName);
        prefs.setString('pro_email', profileModel.email);
        prefs.setString('pro_add1', profileModel.shipping.address1);
        prefs.setString('pro_add2', profileModel.shipping.address2);
        prefs.setString('pro_city', profileModel.shipping.city);
        prefs.setString('pro_postcode', profileModel.shipping.postcode);
        prefs.setString('pro_state', profileModel.shipping.state);
        prefs.setString('pro_country', profileModel.shipping.country);

        ViewCountryCode();
        // ViewProfilePic();
      }
      print('sucess');
      print('not json $jsonResponse');

      return profileModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
//    Countrys() {
//      return FutureBuilder<List<CountryModel>>(
//          future: countrydetail,
//          builder: (BuildContext context,
//              AsyncSnapshot<List<CountryModel>> snapshot) {
//            if (!snapshot.hasData)
//              return CupertinoActivityIndicator(
//                animating: true,
//              );
//            return DropdownButton<String>(
//              underline: SizedBox(),
//              isExpanded: true,
//              items: snapshot.data
//                  .map((countyState) => DropdownMenuItem<String>(
//                child: Text(
//                  countyState.name,
//                  style: TextStyle(
//                      color: sh_app_black,
//                      fontFamily: fontRegular,
//                      fontSize: textSizeNormal),
//                ),
//                value: countyState.name,
//              ))
//                  .toList(),
//              hint:Text('Select Country'),
//              value: selectedValue,
//              onChanged: (String newVal) {
//                setState(() {
//                  selectedStateValue=null;
//                  selectedValue = newVal;
//                  selectedcountry=newVal.code;
//                  countryname=newVal.code;
////                  statedetail=fetchstate(newVal.code);
//                });
//              },
//            );
//          });
//    }

    Address1() {
      return TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: addressCont,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(
            color: sh_textColorPrimary,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        decoration: InputDecoration(
            filled: false,
            hintText: sh_hint_address1,
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
                borderSide:
                BorderSide(color: Colors.grey.withOpacity(0.5), width: 0))),
      );
    }

    Address2() {
      return TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: addressCont2,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(
            color: sh_textColorPrimary,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        decoration: InputDecoration(
            filled: false,
            hintText: sh_hint_address2,
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
                borderSide:
                BorderSide(color: Colors.grey.withOpacity(0.5), width: 0))),
      );
    }

    City() {
      return TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: cityCont,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(
            color: sh_textColorPrimary,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        decoration: InputDecoration(
            filled: false,
            hintText: sh_hint_city,
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
                borderSide:
                BorderSide(color: Colors.grey.withOpacity(0.5), width: 0))),
      );
    }

    Pincode() {
      return TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: pinCodeCont,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(
            color: sh_textColorPrimary,
            fontFamily: fontRegular,
            fontSize: textSizeMedium),
        decoration: InputDecoration(
            filled: false,
            hintText: sh_hint_pin_code,
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
                borderSide:
                BorderSide(color: Colors.grey.withOpacity(0.5), width: 0))),
      );
    }

    countryList() {
      return SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
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
                new_car = 1;
                selectedValue = newVal;
                countryname = newVal.country;

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
        ),
      );
    }

    stateList() {
      if (_visible_drop) {
        return SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            decoration: BoxDecoration(
                border:
                Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
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
                  new_car = 1;
                  selectedStateValue = newVal;
                  statename = newVal.name;
                });
              },
            ),
          ),
        );
      } else {
        return TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          controller: parishCont,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
              color: sh_textColorPrimary,
              fontFamily: fontRegular,
              fontSize: textSizeMedium),
          decoration: InputDecoration(
              filled: false,
              hintText: sh_hint_parish,
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
              children: <Widget>[
                countryList(),
                SizedBox(
                  height: 12,
                ),
                stateList()
              ],
            );
          });
    }

    viewOrderDetail() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: FutureBuilder<ViewProModel>(
              future: ViewProfilePic(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(spacing_standard_new),
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: spacing_standard,
                          margin: EdgeInsets.all(spacing_control),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // getImage();
                              _showPicker(context);
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: _image == null
                                    ? CircleAvatar(
                                  // backgroundImage: NetworkImage('https://en.gravatar.com/avatar/491302567ea4eb1e519b54990b8da162'),
                                  backgroundImage: NetworkImage(
                                      fnl_img),
                                  radius: 55,
                                )
                                    : CircleAvatar(
                                  // backgroundImage: NetworkImage('https://en.gravatar.com/avatar/491302567ea4eb1e519b54990b8da162'),
                                  backgroundImage: FileImage(_image),
                                  radius: 55,
                                )),
                          ),
                        ),
                      ),


                      Container(
                        padding: EdgeInsets.all(spacing_control),
                        margin: EdgeInsets.only(bottom: 30, right: 20),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: sh_white,
                            border: Border.all(color: sh_colorPrimary,
                                width: 1)),
                        child: Icon(
                          Icons.camera_alt,
                          color: sh_colorPrimary,
                          size: 16,
                        ),
                      )
                    ],
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(spacing_standard_new),
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: spacing_standard,
                    margin: EdgeInsets.all(spacing_control),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CircleAvatar(
                          // backgroundImage: NetworkImage('https://en.gravatar.com/avatar/491302567ea4eb1e519b54990b8da162'),
                          backgroundImage: NetworkImage(
                              fnl_img),
                          radius: 55,
                        )),
                  ),
                );
              },
            ),

          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller: firstNameCont,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                        color: sh_textColorPrimary,
                        fontFamily: fontRegular,
                        fontSize: textSizeMedium),
                    decoration: InputDecoration(
                        filled: false,
                        hintText: sh_hint_userName,
                        hintStyle: TextStyle(
                            color: sh_textColorSecondary,
                            fontFamily: fontRegular,
                            fontSize: textSizeMedium),
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 0.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 0))),
                  ),
                ),
                SizedBox(
                  width: spacing_standard_new,
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller: lastNameCont,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                        color: sh_textColorPrimary,
                        fontFamily: fontRegular,
                        fontSize: textSizeMedium),
                    decoration: InputDecoration(
                        filled: false,
                        hintText: sh_hint_userName,
                        hintStyle: TextStyle(
                            color: sh_textColorSecondary,
                            fontFamily: fontRegular,
                            fontSize: textSizeMedium),
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 0.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 0))),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing_standard_new),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            controller: emailCont,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
                color: sh_textColorPrimary,
                fontFamily: fontRegular,
                fontSize: textSizeMedium),
            decoration: InputDecoration(
                filled: false,
                hintText: sh_hint_Email,
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
          SizedBox(height: spacing_standard_new),
          Stack(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                readOnly: true,
                maxLines: 1,
                controller: phoneNumberCont,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(
                    color: sh_textColorPrimary,
                    fontFamily: fontRegular,
                    fontSize: textSizeMedium),
                decoration: InputDecoration(
                    filled: false,
                    hintText: sh_hint_mobile_no,
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
              GestureDetector(
                onTap: () {
                  launchScreen(context, NewNumberScreen.tag);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 14, 14, 0),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Change",
                      style: TextStyle(
                          color: sh_app_blue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Regular'),
                    ),
                  ),
                ),
              )
            ],

          ),
          SizedBox(height: spacing_standard_new),
//          Countrys(),
          Address1(),
          SizedBox(height: spacing_standard_new),
          Address2(),
          SizedBox(height: spacing_standard_new),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: City(),
                ),
                SizedBox(
                  width: spacing_standard_new,
                ),
                Expanded(
                  child: Pincode(),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing_standard_new),
          mainList(),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            // height: double.infinity,
            child: MaterialButton(
              padding: EdgeInsets.all(spacing_standard),
              child: text(sh_lbl_save_profile,
                  fontSize: textSizeNormal,
                  fontFamily: fontMedium,
                  textColor: sh_white),
              textColor: sh_white,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(40.0)),
              color: sh_app_background,
              onPressed: () {
                CheckInternet().then((intenet) {
                  if (intenet) {
                    getUpdate();
                  } else {
                    toast("No Internet Connection");
                  }
                  // No-Internet Case
                });
              },
            ),
          ),
          SizedBox(
            height: spacing_standard_new,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            // height: double.infinity,
            child: MaterialButton(
              padding: EdgeInsets.all(spacing_standard),
              child: text(sh_lbl_change_pswd,
                  fontSize: textSizeNormal,
                  fontFamily: fontMedium,
                  textColor: sh_app_background),
              textColor: sh_white,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(40.0),
                  side: BorderSide(color: sh_app_background, width: 1)),
              color: sh_white,
              onPressed: () =>
              {launchScreen(context, ChangePasswordScreen.tag)},
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text(sh_lbl_account,
            textColor: sh_textColorPrimary,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(spacing_standard_new),
          child: FutureBuilder<ProfileModel>(
              future: fetchDetails(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        viewOrderDetail(),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        height: 50.0,
                        width: 50.0,
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
