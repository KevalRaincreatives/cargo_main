import 'dart:convert';

import 'package:cargo/model/MyQuotesModel.dart';
import 'package:cargo/screens/QuoteDetailsScreen.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyQuoteFragment extends StatefulWidget {
  @override
  _MyQuoteFragmentState createState() => _MyQuoteFragmentState();
}

class _MyQuoteFragmentState extends State<MyQuoteFragment> {
  Future<MyQuotesModel> futurequote;
  MyQuotesModel quote_model;

  @override
  void initState() {
    super.initState();
    futurequote = fetchQuote();
  }

  Future<MyQuotesModel> fetchQuote() async {
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
          Uri.parse('https://cargobgi.net/wp-json/v3/quotes?user_id=$UserId'),
          headers: headers);
      final jsonResponse = json.decode(response.body);

//      var r = await Requests.get(
//          'https://cargobgi.net/wp-json/v3/quotes?user_id=$UserId',
//          headers: headers);
//
//      r.raiseForStatus();
//      String body = r.content();
//      print(body);
//
//
//      final jsonResponse = json.decode(body);

      print('not json $jsonResponse');
      final int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        quote_model = new MyQuotesModel.fromJson(jsonResponse);
      }
      return quote_model;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<String> getDetail(String quoteid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('quote_id', quoteid);
    launchScreen(context, QuoteDetailsScreen.tag);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    FirstColumn() {
      return Row(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: Container(
                child: Text(
                  '#65151',
                  style: TextStyle(
                      fontSize: 15,
                      color: sh_app_background,
                      fontFamily: fontBold,
                      fontWeight: FontWeight.bold),
                ),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '07/08/2020',
                  style: TextStyle(
                      fontSize: 15,
                      color: sh_black,
                      fontFamily: fontBold,
                      fontWeight: FontWeight.bold),
                ),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'Pending',
                  style: TextStyle(
                      fontSize: 15,
                      color: sh_dots_color,
                      fontFamily: fontBold,
                      fontWeight: FontWeight.bold),
                ),
              ))
        ],
      );
    }

    SecondColumn(int index) {
      String q_id=quote_model.response[index].quoteId;
      return GestureDetector(
        onTap: () {
          getDetail(quote_model.response[index].quoteId);
        },
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Container(
                      child: Text(
                        '# $q_id',
                        style: TextStyle(
                            fontSize: 15,
                            color: sh_app_background,
                            fontFamily: fontBold,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        quote_model.response[index].quoteDate,
                        style: TextStyle(
                            fontSize: 15,
                            color: sh_black,
                            fontFamily: fontBold,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        quote_model.response[index].quoteStatus,
                        style: TextStyle(
                            fontSize: 15,
                            color: sh_app_background,
                            fontFamily: fontBold,
                            fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: sh_dots_color,
              height: 1,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }

    listView() {
      return ListView.builder(
          shrinkWrap: true,
          reverse: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: quote_model.response.length,
          itemBuilder: (BuildContext context, int index) {
            return SecondColumn(index);
          });
    }

    ListValidation(){
      if(quote_model.response.length == 0){
        return Container(
          alignment: Alignment.center,
          child: Text(
            'No Quote Found',
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

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: sh_background_color,
        padding: EdgeInsets.fromLTRB(30, 00, 30, 0),
        child: Column(
          children: <Widget>[
            FutureBuilder<MyQuotesModel>(
              future: futurequote,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListValidation();
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
