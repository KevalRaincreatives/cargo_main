import 'dart:convert';

import 'package:cargo/fragments/HomeFragment.dart';
import 'package:cargo/fragments/OrderDetailFragment.dart';
import 'package:cargo/fragments/OrderFragment.dart';
import 'package:cargo/fragments/QuoteDetailFragment.dart';
import 'package:cargo/fragments/QuoteFragment.dart';
import 'package:cargo/model/QuoteDetailModel.dart';
import 'package:cargo/screens/MyAccountScreen.dart';
import 'package:cargo/screens/SplashScreens.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
class QuoteDetailsScreen extends StatefulWidget {
  static String tag='/QuoteDetailsScreen';

  @override
  _QuoteDetailsScreenState createState() => _QuoteDetailsScreenState();
}

class _QuoteDetailsScreenState extends State<QuoteDetailsScreen> {

  var name = '';
  var lengh = '';
  var height = '';
  var weight = '';
  var width = '';
  var price = '';
  Future<QuoteDetailModel> futurequote;
  QuoteDetailModel quote_model;
  final GlobalKey<State> _keyLoader=new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
//    fragments = [homeFragment, cartFragment, wishlistFragment];
    getName();
    futurequote = fetchQuote();
  }
  Future<QuoteDetailModel> fetchQuote() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String quote_id = prefs.getString('quote_id');
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'CargoAuthToken': token,
        'CargoUserId': UserId
      };

      Response response = await get(
          'https://cargobgi.net/wp-json/v3/quote_details?quote_id=$quote_id',
          headers: headers);
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      quote_model = new QuoteDetailModel.fromJson(jsonResponse);
      return quote_model;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('UserName');
    });
  }

  Future<String> getLogout() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');
      String device_id = prefs.getString('device_id');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoAuthToken': token,
        'cargoUserId': UserId
      };
      final msg = jsonEncode({"device_id": device_id});

      Response response = await get(
        'https://cargobgi.net/wp-json/v3/logout?device_id=$device_id',
        headers: headers,
      );
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      prefs.setString('token', '');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreens(),
        ),
      );

      return null;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }


  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;

    Logout() async{
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Are You sure you want to logout?'),
            actions: [
              TextButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
//                  setState(() {
//                    futureAlbum = fetchAlbum();
//                    cartdetail=fetchCart();
//                  });
                },
              ),
              TextButton(
                child: const Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                  getLogout();
                },
              )
            ],
          );
        },
      );
    }

    HeightBox(int index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
        Text(
          'Height : ',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Text(
          quote_model.details.items[index].height,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ],);
//      return Container(
//        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
//        child: Container(
//          padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
//          decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(4.0),
//            border: Border.all(color: sh_app_background, width: 1.5),
//          ),
//          child: Center(child: text(quote_model.details.items[index].height, textColor: sh_app_black)),
//        ),
//      );
    }

    WidthBox(int index) {
      return Row(children: <Widget>[
        Text(
          'Width : ',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Text(
        quote_model.details.items[index].width,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ],);
//      return Container(
//        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
//        child: Container(
//          padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
//          decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(4.0),
//            border: Border.all(color: sh_app_background, width: 1.5),
//          ),
//          child: Center(child: text(quote_model.details.items[index].width, textColor: sh_app_black)),
//        ),
//      );
    }

    LengthBox(int index) {
      return Row(
        children: <Widget>[
        Text(
          'Length : ',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Text(
          quote_model.details.items[index].length,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ],);
//      return Container(
//        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
//        child: Container(
//          padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
//          decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(4.0),
//            border: Border.all(color: sh_app_background, width: 1.5),
//          ),
//          child: Center(child: text(quote_model.details.items[index].length, textColor: sh_app_black)),
//        ),
//      );
    }

    LbsBox(int index) {
      String lb=quote_model.details.items[index].weight;
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
        Text(
          'Weight : ',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Text(
          '$lb lbs',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ],);
//      return Container(
//        margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
//        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(4.0),
//          border: Border.all(color: sh_app_background, width: 1.5),
//        ),
//        child: Row(
//          children: <Widget>[
//            Expanded(
//                flex: 6,
//                child: Container(
//                  padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
//                  child:  Center(child: text(quote_model.details.items[index].weight, textColor: sh_app_black)),
//
//                )),
//            Expanded(
//                flex: 4,
//                child: Container(
//                    alignment: Alignment.centerRight,
//                    padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
//                    child: Text(
//                      'lbs',
//                      style: TextStyle(color: sh_app_background, fontSize: 16),
//                    )))
//          ],
//        ),
//      );
    }

    PriceBox(int index) {
      return Row(children: <Widget>[
        Text(
          'Price : \$',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Text(
          quote_model.details.items[index].price,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ],);
//      return Container(
//        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(4.0),
//          border: Border.all(color: sh_app_background, width: 1.5),
//        ),
//        child: Row(
//          children: <Widget>[
//            Expanded(
//                flex: 2,
//                child: Container(
//                    alignment: Alignment.centerLeft,
//                    padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
//                    child: Text(
//                      "\$",
//                      style: TextStyle(color: sh_app_background, fontSize: 16),
//                    ))),
//            Expanded(
//                flex: 8,
//                child: Container(
//                  padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
//                  child:  Center(child: text(quote_model.details.items[index].price, textColor: sh_app_black)),
//
//                )),
//          ],
//        ),
//      );
    }

    PackageType(int index) {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: sh_app_background, width: 1.5),
          ),
          child: Center(child: text(quote_model.details.items[index].packageType, textColor: sh_app_black)),
        ),
      );
    }

    ItemType(int index) {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: sh_app_background, width: 1.5),
          ),
          child: Center(child: text(quote_model.details.items[index].itemType, textColor: sh_app_black)),
        ),
      );
    }

//    Quote(int index) {
//      return Card(
//        elevation: 4,
//        child: Padding(
//          padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Text(
//                'Package Type',
//                style: TextStyle(
//                    fontSize: 14,
//                    fontWeight: FontWeight.bold,
//                    color: Colors.black),
//              ),
//              SizedBox(
//                height: 6,
//              ),
//              Row(
//                children: <Widget>[
//                  Expanded(flex: 8, child: PackageType(index)),
//                  Expanded(flex: 2, child: Container()),
//                ],
//              ),
//
//              SizedBox(
//                height: 18,
//              ),
//              Text(
//                'Dimensions & Weight',
//                style: TextStyle(
//                    fontSize: 14,
//                    fontWeight: FontWeight.bold,
//                    color: Colors.black),
//              ),
//              SizedBox(
//                height: 8,
//              ),
//              Row(
//                children: <Widget>[
//                  Expanded(flex: 2, child: WidthBox(index)),
//                  Expanded(flex: 2, child: HeightBox(index)),
//                  Expanded(flex: 2, child: LengthBox(index)),
//                  Expanded(flex: 4, child: LbsBox(index))
//                ],
//              ),
//              SizedBox(
//                height: 18,
//              ),
//              Row(
//                children: <Widget>[
//                  Expanded(flex: 4, child: PriceBox(index)),
//                  Expanded(flex: 2, child: Container()),
//                  Expanded(flex: 2, child: Container()),
//                  Expanded(flex: 2, child: Container())
//                ],
//              ),
//              SizedBox(
//                height: 18,
//              ),
//              Text(
//                'Item Type',
//                style: TextStyle(
//                    fontSize: 14,
//                    fontWeight: FontWeight.bold,
//                    color: Colors.black),
//              ),
//              SizedBox(
//                height: 6,
//              ),
//              Row(
//                children: <Widget>[
//                  Expanded(flex: 8, child: ItemType(index)),
//                  Expanded(flex: 2, child: Container()),
//                ],
//              ),
//
//
//            ],
//          ),
//        ),
//        color: sh_white,
//        margin: EdgeInsets.fromLTRB(26, 4, 26, 0),
//      );
//    }

    Quote2(int index) {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[

                Expanded(
                  flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      Text(
                        'Package Type :',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        quote_model.details.items[index].packageType,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],)),
                Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                      Text(
                        'Total :',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        quote_model.details.items[index].total!=null?quote_model.details.items[index].total:'',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],))
              ],),

              SizedBox(
                height: 8,
              ),
              Container(
                height: 1,
                color: Colors.grey[400],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Dimensions & Weight',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: <Widget>[
                  Expanded(flex: 5, child: WidthBox(index)),
                  Expanded(flex: 1, child: Container()),
                  Expanded(flex: 5, child: HeightBox(index)),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Expanded(flex: 5, child: LengthBox(index)),
                  Expanded(flex: 1, child: Container()),
                  Expanded(flex: 5, child: LbsBox(index))
                ],
              ),
              SizedBox(
                height: 18,
              ),
              PriceBox(index),
              SizedBox(
                height: 8,
              ),

              Container(
                height: 1,
                color: Colors.grey[400],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Item Type :',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                quote_model.details.items[index].itemType,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
               ),
            ],
          ),
        ),
        color: sh_white,
        margin: EdgeInsets.fromLTRB(26, 4, 26, 0),
      );
    }

    QuoteDet() {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 2,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Quote Id : #',
                    style: TextStyle(
                        fontSize: 15,
                        color: sh_app_black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    quote_model.details.quoteId,
                    style: TextStyle(
                        fontSize: 15,
                        color: sh_app_background,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Quote Status : ',
                    style: TextStyle(
                        fontSize: 15,
                        color: sh_app_black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    quote_model.details.status,
                    style: TextStyle(
                        fontSize: 15,
                        color: sh_app_background,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Quote Date : ',
                    style: TextStyle(
                        fontSize: 15,
                        color: sh_app_black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    quote_model.details.date,
                    style: TextStyle(
                        fontSize: 15,
                        color: sh_app_background,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Grand Total : ',
                    style: TextStyle(
                        fontSize: 17,
                        color: sh_app_black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    quote_model.details.grandTotal!=null?quote_model.details.grandTotal:'',
                    style: TextStyle(
                        fontSize: 17,
                        color: sh_app_background,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        color: sh_white,
        margin: EdgeInsets.fromLTRB(26, 4, 26, 0),
      );
    }

    listView() {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            QuoteDet(),
            SizedBox(height: 4,),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: quote_model.details.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Quote2(index);
                }),
            SizedBox(height: 10,),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: sh_app_background,
        elevation: 0,
        iconTheme: IconThemeData(color: sh_white),
        actions: <Widget>[
          IconButton(
            icon: new Image.asset(
              cargo_logout,
              color: Colors.white,
              height: 24,
              width: 24,
            ),
            onPressed: () {
              Logout();
            },
          )
        ],
        title: Text(
          name,
          style: TextStyle(color: sh_white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24)),
                shape: BoxShape.rectangle,
                color: sh_app_background),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  FutureBuilder<QuoteDetailModel>(
                    future: futurequote,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return listView();
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default, show a loading spinner.
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}
