import 'package:cargo/utils/ShColors.dart';
import 'package:flutter/material.dart';
class ShBackScreen extends StatelessWidget {
  static String tag='/ShBackScreen';
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        color: sh_editText_background,
      ),
    );
  }
}
