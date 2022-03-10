import 'dart:convert';

import 'package:cargo/model/CovidModel.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart' as dom;

class CovidScreen extends StatefulWidget {
  static String tag='/CovidScreen';
  @override
  _CovidScreenState createState() => _CovidScreenState();
}

class _CovidScreenState extends State<CovidScreen> {
  CovidModel termsModel;

  Future<CovidModel> fetchDetails() async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      Response response = await get(
          Uri.parse('https://cargobgi.net/wp-json/v3/covid_safety'));

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');

      termsModel = new CovidModel.fromJson(jsonResponse);
      print('sucess');

      return termsModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    HtmlText() {
      return Html(
        data: termsModel.content,
        //Optional parameters:
        backgroundColor: Colors.white70,
        onLinkTap: (url) {
          // open url in a webview
        },

      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text('COVID Safety',
            textColor: sh_app_black,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_app_black),
        actionsIconTheme: IconThemeData(color: sh_app_black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(spacing_standard_new),
          child: FutureBuilder<CovidModel>(
              future: fetchDetails(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: width,
                    height: height,
                    color: sh_white,
                    padding: EdgeInsets.fromLTRB(16,1,16,0),

                    child: SingleChildScrollView(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          HtmlText()
                        ],
                      ),
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
