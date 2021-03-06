import 'dart:convert';

import 'package:cargo/model/OrderModel.dart';
import 'package:cargo/screens/OrderDetailNewScreen.dart';
import 'package:cargo/screens/OrderDetailScreen.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderFragment extends StatefulWidget {
  @override
  _OrderFragmentState createState() => _OrderFragmentState();
}

class _OrderFragmentState extends State<OrderFragment> {
  Future<OrderModel> futureorder;
  OrderModel order_model;
  OrderModel order_search_model;
  List<String> status_type = [
    "All",
    "Imported",
    "On the way",
    "Delivered",
    "Cancelled"
  ];
  var selectedValue = "All";
  final ScrollController _homeController = ScrollController();

  @override
  void initState() {
    super.initState();
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
        'CargoAuthToken': token,
        'CargoUserId': UserId
      };

      Response response = await get(
          Uri.parse('https://cargobgi.net/wp-json/v3/shipments?user_id=$UserId'),
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

  Future<String> getDetail(String quoteid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('order_id', quoteid);
    final platform = Theme.of(context).platform;
    launchScreen(context, OrderDetailNewScreen.tag);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

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
            color: Colors.white,
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
          hint: Text('Select Status'),
          value: selectedValue,
          onChanged: (newVal) {
            selectedValue = newVal;

            onSearchTextChanged(newVal);

          },
        ),
      );
    }

    Order(int index) {
      String sts = order_model.response[index].quoteStatus;
      return GestureDetector(
        onTap: () {
//          launchScreen(context, OrderDetailScreen.tag);
          getDetail(order_model.response[index].quoteId);
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
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
                                fontSize: 13,
                                color: sh_app_black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            order_model.response[index].shipment_order_id,
                            style: TextStyle(
                                fontSize: 13,
                                color: sh_app_background,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' is $sts.',
                            style: TextStyle(
                                fontSize: 13,
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
                            style:
                                TextStyle(fontSize: 14, color: sh_dots_color),
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


    ListValidation(){
      if(order_model.response.length == 0){
        return Container(
          alignment: Alignment.center,
          child: Text(
            'No Order Found',
            style: TextStyle(
                fontSize: 16,
                color: sh_app_black,
                fontWeight: FontWeight.bold),
          ),
        );
      }else{
        return listView();
      }
    }

//    listView() {
//      return ListView.builder(
//          shrinkWrap: true,
//          physics: NeverScrollableScrollPhysics(),
//          itemCount: order_model.response.length,
//          itemBuilder: (BuildContext context, int index) {
//            return Order(index);
//          });
//    }

    return Scaffold(
      body: Container(
        color: sh_background_color,
        height: height - 74,
        width: width,
        child: Stack(
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
              padding: EdgeInsets.fromLTRB(0, 30, 0, 84),
              child: SingleChildScrollView(
                controller: _homeController,
                child: Column(
                  children: <Widget>[
                    StatusList(),
                    FutureBuilder<OrderModel>(
                      future: futureorder,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListValidation();
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
      ),
    );
  }
}
