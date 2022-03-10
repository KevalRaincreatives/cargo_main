import 'dart:convert';

import 'package:cargo/model/TermsModel.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart';
class TermsConditionScreen extends StatefulWidget {
  static String tag='/TermsConditionScreen';
  @override
  _TermsConditionScreenState createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  TermsModel termsModel;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<TermsModel> fetchDetails() async {
//    Dialogs.showLoadingDialog(context, _keyLoader);
    try {

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',

      };

      Response response = await get(
          Uri.parse('https://cargobgi.net/wp-json/v3/terms-and-conditions'),
          headers: headers);

//      r.raiseForStatus();
//      String body = r.content();
//      print(body);

      final jsonResponse = json.decode(response.body);
      termsModel = new TermsModel.fromJson(jsonResponse);


      print('sucess');
      print('not json $jsonResponse');

      return termsModel;
    } catch (e) {
      print('caught error $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

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
        title: text('Terms & Conditions',
            textColor: sh_app_black,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_app_black),
        actionsIconTheme: IconThemeData(color: sh_app_black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(spacing_standard_new),
          child: FutureBuilder<TermsModel>(
              future: fetchDetails(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: HtmlText()
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
