import 'package:cargo/screens/MyAddressScreen.dart';
import 'package:cargo/screens/ProfileScreen.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/material.dart';

class MyAccountScreen extends StatefulWidget {
  static String tag = '/MyAccountScreen';
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: sh_white,
        title: text('My Account',
            textColor: sh_textColorPrimary,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(spacing_standard_new),
          child: Column(
            children: <Widget>[
              SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                height: 50,
                // height: double.infinity,
                child: MaterialButton(
                  padding: EdgeInsets.all(spacing_standard),
                  child: text(sh_lbl_account,
                      fontSize: textSizeNormal,
                      fontFamily: fontMedium,
                      textColor: sh_white),
                  textColor: sh_white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(40.0)),
                  color: sh_app_background,
                  onPressed: () => {
                    launchScreen(context, ProfileScreen.tag)
//                getUpdate()
                  },
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                height: 50,
                // height: double.infinity,
                child: MaterialButton(
                  padding: EdgeInsets.all(spacing_standard),
                  child: text(sh_lbl_my_address,
                      fontSize: textSizeNormal,
                      fontFamily: fontMedium,
                      textColor: sh_white),
                  textColor: sh_white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(40.0)),
                  color: sh_app_background,
                  onPressed: () => {
                    launchScreen(context, MyAddressScreen.tag)
//                getUpdate()
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
