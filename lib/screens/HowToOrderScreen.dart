import 'dart:convert';

import 'package:cargo/model/TermsModel.dart';
import 'package:cargo/screens/DashboardScreen.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart';
class HowToOrderScreen extends StatefulWidget {
  static String tag='/HowToOrderScreen';
  @override
  _HowToOrderScreenState createState() => _HowToOrderScreenState();
}

class _HowToOrderScreenState extends State<HowToOrderScreen> {
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
          'https://cargobgi.net/wp-json/v3/how-to-order',
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

    saveButton() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 4, 20, 4),
        child: MaterialButton(
          height: 50,
          minWidth: double.infinity,
          padding: EdgeInsets.all(spacing_standard),
          child: text("Request a quote",
              fontSize: textSizeNormal,
              fontFamily: fontMedium,
              textColor: sh_white),
          textColor: sh_white,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(40.0)),
          color: sh_app_background,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DashboardScreen(
                        selectedTab: 1),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text('How to order',
            textColor: sh_app_black,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_app_black),
        actionsIconTheme: IconThemeData(color: sh_app_black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(spacing_standard_new),
        child: FutureBuilder<TermsModel>(
            future: fetchDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Expanded(
                      flex: 9,
                      child: SingleChildScrollView(
                          child: HtmlText()
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: saveButton(),
                      ),
                    ),
                  ],
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
    );
  }
}
