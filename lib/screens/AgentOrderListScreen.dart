import 'dart:convert';
import 'dart:io';

import 'package:cargo/model/OrderDetailModel.dart';
import 'package:cargo/model/OrderModel.dart';
import 'package:cargo/screens/AgentOrderDetailScreen.dart';
import 'package:cargo/screens/SplashScreens.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AgentOrderListScreen extends StatefulWidget {
  static String tag='/AgentOrderListScreen';
  @override
  _AgentOrderListScreenState createState() => _AgentOrderListScreenState();
}

class _AgentOrderListScreenState extends State<AgentOrderListScreen> {
  Future<OrderModel> futureorder;
  OrderModel order_model;
  OrderModel order_search_model;
  var name = '';
  List<String> status_type = [
    "All",
    "Imported",
    "On the way",
    "Delivered",
    "Cancelled"
  ];
  var selectedValue="All";
  final GlobalKey<State> _keyLoader=new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    getName();
    futureorder = fetchOrder();
  }

  Future<OrderModel> fetchOrder() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoAuthToken': token,
        'cargoUserId': UserId
      };

      Response response = await get(
          'https://cargobgi.net/wp-json/v3/shipments_delivery',
          headers: headers);
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      order_model = new OrderModel.fromJson(jsonResponse);
      order_search_model = new OrderModel.fromJson(jsonResponse);
      return order_model;
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

  Future<String> getDetail(String quoteid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('order_id', quoteid);
    launchScreen(context, AgentOrderDetailScreen.tag);
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => exit(0),
            /*Navigator.of(context).pop(true)*/
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;

    onSearchTextChanged(String text) async {
      order_search_model.response.clear();
      if (text.isEmpty) {
        setState(() {});
        return;
      }

      order_model.response.forEach((userDetail) {
        if (userDetail.quoteStatus.contains(text))
          order_search_model.response.add(userDetail);
      });

      setState(() {});
    }


    StatusList() {
      return Container(
        margin: EdgeInsets.fromLTRB(30, 12, 30, 12),
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        child: DropdownButton<String>(
          underline: SizedBox(),
          isExpanded: true,
          items: status_type.map((item) {
            return new DropdownMenuItem(
              child: Text(
                item,
                style: TextStyle(
                    fontSize: 15,
                    color: sh_app_black,
                    fontWeight: FontWeight.bold),
              ),
              value: item,
            );
          }).toList(),
          value: selectedValue,
          onChanged: (newVal) {
            selectedValue = newVal;

            onSearchTextChanged(newVal);
          },
        ),
      );
    }

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

    Order(int index){
      String sts=order_model.response[index].quoteStatus;
      return GestureDetector(
        onTap: (){
//          launchScreen(context, OrderDetailScreen.tag);
          getDetail(order_model.response[index].quoteId);
        },
        child: Container(
          width: width,
          child: Column(

            children: <Widget>[
              Card(
                elevation: 2,
                child: Padding(
                  padding:
                  const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.date_range,
                                color: sh_app_background,
                                size: 24,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                order_model.response[index].quoteStatus,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.chevron_right,
                                color: sh_app_background,
                                size: 30,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        height: 1,
                        color: sh_dots_color,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Package ',
                            style: TextStyle(
                                fontSize: 16,
                                color: sh_app_black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            order_model.response[index].shipment_order_id,
                            style: TextStyle(
                                fontSize: 16,
                                color: sh_app_background,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' is $sts.',
                            style: TextStyle(
                                fontSize: 16,
                                color: sh_app_black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            order_model.response[index].deliveryDate,
                            style: TextStyle(
                                fontSize: 14, color: sh_dots_color),
                          )),
                    ],
                  ),
                ),
                color: sh_white,
                margin: EdgeInsets.fromLTRB(26, 4, 26, 0),
              )
            ],
          ),
        ),
      );
    }

    listView() {
      return new Container(
        child: order_search_model.response.length != 0 || selectedValue != "All"
            ? new ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: order_search_model.response.length,
            itemBuilder: (BuildContext context, int index) {
              return Order(index);
            })
            : new ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: order_model.response.length,
            itemBuilder: (BuildContext context, int index) {
              return Order(index);
            }),
      );
    }

//    listView(){
//      return ListView.builder(
//          shrinkWrap: true,
//          physics: NeverScrollableScrollPhysics(),
//          itemCount: order_model.response.length,
//          itemBuilder: (BuildContext context, int index) {
//            return Order(index);
//          });
//    }

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
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          children: <Widget>[
            Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    StatusList(),
                    FutureBuilder<OrderModel>(
                      future: futureorder,
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
                    SizedBox(
                      width: 12,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
