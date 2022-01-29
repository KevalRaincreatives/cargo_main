import 'dart:convert';

import 'package:cargo/model/OrderDetailModel.dart';
import 'package:cargo/model/QuoteDetailModel.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OrderDetailFragment extends StatefulWidget {
  @override
  _OrderDetailFragmentState createState() => _OrderDetailFragmentState();
}

class _OrderDetailFragmentState extends State<OrderDetailFragment> {
  Future<OrderDetailModel> futureorder;
  OrderDetailModel order_model;

  @override
  void initState() {
    super.initState();
    futureorder = fetchOrder();
  }

  Future<OrderDetailModel> fetchOrder() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String order_id = prefs.getString('order_id');
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'CargoAuthToken': token,
        'CargoUserId': UserId
      };

      Response response = await get(
          'https://cargobgi.net/wp-json/v3/shipment_details?shipment_id=$order_id',
          headers: headers);
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      order_model = new OrderDetailModel.fromJson(jsonResponse);
      return order_model;
    } catch (e) {
      print('caught error $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    listView(){
      return Card(
        elevation: 4,
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
                        size: 30,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Details',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.chevron_left,
                        color: sh_app_background,
                        size: 36,
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
                    'Package #',
                    style: TextStyle(
                        fontSize: 15,
                        color: sh_app_black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                      order_model.details.shipmentId,
                    style: TextStyle(
                        fontSize: 15,
                        color: sh_app_background,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' is on the way.',
                    style: TextStyle(
                        fontSize: 15,
                        color: sh_app_black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 12,),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Text(
                      'Order Date: ',
                      style: TextStyle(
                          fontSize: 15,
                          color: sh_app_black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      order_model.details.date,
                      style: TextStyle(
                          fontSize: 15,
                          color: sh_app_black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12,),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Text(
                      'Est. Arrival: ',
                      style: TextStyle(
                          fontSize: 15,
                          color: sh_app_black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      order_model.details.estimatedDate,
                      style: TextStyle(
                          fontSize: 15,
                          color: sh_app_black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12,),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Delivery Mode : Pick Up/Home Delivery',
                  style: TextStyle(
                      fontSize: 15,
                      color: sh_app_black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(height: 1,color: sh_dots_color,),
              SizedBox(
                height: 16,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.pin_drop,
                              color: sh_dots_color,
                              size: 15,
                            ),
                            Text(
                              ' Tracking',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: sh_app_background,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                      flex: 5,
                      child: Center(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.file_upload,
                                color: sh_dots_color,
                                size: 15,
                              ),
                              Text(
                                ' Upload Invoice',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: sh_app_background,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )),
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                      flex: 3,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.description,
                              color: sh_dots_color,
                              size: 15,
                            ),
                            Text(
                              ' Delivery',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: sh_app_background,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(height: 1,color: sh_dots_color,),
              SizedBox(
                height: 18,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Invoices',
                  style: TextStyle(
                      fontSize: 16,
                      color: sh_app_background,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 6,),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No Invoice Uploaded',
                  style: TextStyle(
                      fontSize: 15,
                      color: sh_app_black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 18,),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Package Details',
                  style: TextStyle(
                      fontSize: 16,
                      color: sh_app_background,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 12,),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Item 1: Tablets/Mobile/Electronics',
                  style: TextStyle(
                      fontSize: 15,
                      color: sh_app_black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 12,),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Item 2: Apparel/Shoes',
                  style: TextStyle(
                      fontSize: 15,
                      color: sh_app_black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 12,),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Item 3: Machine Parts',
                  style: TextStyle(
                      fontSize: 15,
                      color: sh_app_black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        color: sh_white,
        margin: EdgeInsets.fromLTRB(26, 4, 26, 0),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    FutureBuilder<OrderDetailModel>(
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
