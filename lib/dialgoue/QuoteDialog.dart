import 'package:cargo/screens/DashboardScreen.dart';
import 'package:cargo/screens/ShBackScreen.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/material.dart';

class QuoteDialog extends StatelessWidget {
  static String tag='/QuoteDialog';
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(),
      );
    });
    return ShBackScreen();
  }
}

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

dialogContent(BuildContext context) {
  return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          text("Success!",
              textColor: Colors.green,
              fontFamily: fontBold,
              fontSize: textSizeLarge),
          SizedBox(height: 24),
          Image.asset(
            t1_ic_dialog,
            color: Colors.green,
            width: 95,
            height: 95,
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: text("Your Query has been Submitted",
                fontSize: textSizeMedium, maxLine: 2, isCentered: true),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(selectedTab: 0),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: new BoxDecoration(
                color: sh_app_blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: text("Ok",
                  textColor: sh_white,
                  fontFamily: fontMedium,
                  fontSize: textSizeNormal),
            ),
          )
        ],
      ));
}

