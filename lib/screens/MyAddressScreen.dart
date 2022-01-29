import 'dart:convert';

import 'package:cargo/model/AddressListModel.dart';
import 'package:cargo/model/CountryModel.dart';
import 'package:cargo/model/ShLoginModel.dart';
import 'package:cargo/screens/AddNewAddressScreen.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAddressScreen extends StatefulWidget {
  static String tag = '/MyAddressScreen';

  @override
  _MyAddressScreenState createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  var selectedAddressIndex = 0;
  var primaryColor;
  var mIsLoading = true;
  var isLoaded = false;
  AddressListModel _addressModel;
  Future<AddressListModel> futureAlbum;
  String cat_id;
  SharedPreferences prefs;
  var scrollController = new ScrollController();
  var errorMsg = '';

//  DeleteAddressModel deleteAddressModel;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
//    fetchData();
    fetchAddress();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future<AddressListModel> fetchAddress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'CargoAuthToken': token,
        'CargoUserId': UserId
      };

      Response response = await get(
          'https://cargobgi.net/wp-json/v3/addresses',
          headers: headers);

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      _addressModel = new AddressListModel.fromJson(jsonResponse);
      print(_addressModel.data);
      return _addressModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<StateModel> deleteAddress(add_id) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'CargoAuthToken': token,
        'CargoUserId': UserId
      };

      final body = jsonEncode({"name": add_id});

      Response response = await post(
          'https://cargobgi.net/wp-json/v3/delete_address',
          headers: headers,
          body: body);

      final jsonResponse = json.decode(response.body);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('deleted json $jsonResponse');
      toast('Deleted');
      setState(() {});
    } catch (e) {
      print('caught error $e');
    }
  }

  editAddress(model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('pages',"normal");
    var bool = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AddNewAddressScreen(
                      addressModel: model,
                    ))) ??
        false;
    if (bool) {
      fetchAddress();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    listView(data) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
            top: spacing_standard_new, bottom: spacing_standard_new),
        itemBuilder: (item, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: spacing_standard_new),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Edit',
                  color: Colors.green,
                  icon: Icons.edit,
                  onTap: () => editAddress(_addressModel.data[index]),
                )
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.redAccent,
                  icon: Icons.delete_outline,
                  onTap: () => deleteAddress(_addressModel.data[index].name),
                ),
              ],
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedAddressIndex = index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(spacing_standard_new),
                  margin: EdgeInsets.only(
                    right: spacing_standard_new,
                    left: spacing_standard_new,
                  ),
                  color: sh_item_background,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            text(
                                _addressModel
                                    .data[index].shippingAddressNickname,
                                textColor: sh_textColorPrimary,
                                fontSize: textSizeMedium),
                            text(
                                _addressModel.data[index].shippingFirstName +
                                    " " +
                                    _addressModel.data[index].shippingLastName,
                                textColor: sh_textColorPrimary,
                                fontFamily: fontMedium,
                                fontSize: textSizeLargeMedium),
                            text(_addressModel.data[index].shippingAddress1,
                                textColor: sh_textColorPrimary,
                                fontSize: textSizeMedium),
                            text(_addressModel.data[index].shippingAddress2,
                                textColor: sh_textColorPrimary,
                                fontSize: textSizeMedium),
                            text(
                                _addressModel.data[index].shippingCity +
                                    "," +
                                    _addressModel.data[index].shippingPostcode,
                                textColor: sh_textColorPrimary,
                                fontSize: textSizeMedium),
                            SizedBox(
                              height: spacing_standard_new,
                            ),
                            text(_addressModel.data[index].shippingState,
                                textColor: sh_textColorPrimary,
                                fontSize: textSizeMedium),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        shrinkWrap: true,
        itemCount: _addressModel.data.length,
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              color: sh_textColorPrimary,
              icon: Icon(Icons.add),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('pages',"normal");
                var bool = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddNewAddressScreen())) ??
                    false;
                if (bool) {
                  fetchAddress();
                }
              })
        ],
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        title: text(sh_lbl_my_address,
            textColor: sh_textColorPrimary,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        backgroundColor: sh_white,
      ),
      body: Container(
        height: height,
        width: width,
        child: Center(
          child: FutureBuilder<AddressListModel>(
            future: fetchAddress(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 70.0),
                            child: Column(
                              children: <Widget>[listView(_addressModel.data)],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                );
                return listView(_addressModel.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
