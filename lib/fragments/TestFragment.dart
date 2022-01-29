import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/material.dart';

class TestFragment extends StatefulWidget {
  static String tag = '/TestFragment';

  @override
  _TestFragmentState createState() => _TestFragmentState();
}

class _TestFragmentState extends State<TestFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text('My Test',
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
              Container(
                width: 375,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 99,
                      height: 99,
                      child: Container(
                        width: 99,
                        height: 99,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(96),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 25,
                        ),
                        child: Opacity(
                          opacity: 0.50,
                          child: Container(
                            width: 47,
                            height: 49,
                            color: Color(0xff008b61),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 48),
                    Container(
                      width: 375,
                      child: Container(
                        width: 375,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.only(
                          top: 35,
                          bottom: 53,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 301,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Log in to your account",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  SizedBox(
                                    width: 301,
                                    child: Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do",
                                      style: TextStyle(
                                        color: Color(0xaf000000),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 21.67),
                            Container(
                              width: 319,
                              height: 60,
                              child: Container(
                                width: 319,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80),
                                  color: Color(0xfff6f6f6),
                                ),
                                padding: const EdgeInsets.only(
                                  left: 36,
                                  right: 128,
                                  top: 21,
                                  bottom: 20,
                                ),
                                child: Text(
                                  "richardkale@mail.com",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 21.67),
                            Container(
                              width: 319,
                              height: 60,
                              child: Container(
                                width: 319,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80),
                                  border: Border.all(
                                    color: Color(0xff008b61),
                                    width: 1,
                                  ),
                                  color: Color(0xfff6f6f6),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 36,
                                  vertical: 18,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Password",
                                      style: TextStyle(
                                        color: Color(0xffa1a1a1),
                                        fontSize: 16,
                                        fontFamily: "Lato",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 76.50),
                                    Container(
                                      width: 2,
                                      height: 24,
                                      color: Color(0xff008b61),
                                    ),
                                    SizedBox(width: 76.50),
                                    Container(
                                      width: 24,
                                      height: 15.24,
                                      child: Container(
                                        width: 24,
                                        height: 15.24,
                                        color: Color(0xff008b61),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 3,
                                        ),
                                        child: Opacity(
                                          opacity: 0.50,
                                          child: Container(
                                            width: 9.49,
                                            height: 9.46,
                                            color: Color(0xff008b61),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 21.67),
                            Container(
                              width: 315,
                              height: 60,
                              child: Container(
                                width: 315,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(76),
                                  color: Color(0xff008b61),
                                ),
                                padding: const EdgeInsets.only(
                                  left: 35,
                                  right: 36,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "SIGN IN",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: "Lato",
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(width: 154),
                                    Opacity(
                                      opacity: 0.50,
                                      child: Container(
                                        width: 24,
                                        height: 11.62,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 21.67),
                            Text(
                              "Reset Password",
                              style: TextStyle(
                                color: Color(0xff008b61),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 21.67),
                            Container(
                              width: 319,
                              height: 1,
                              color: Color(0xffebebeb),
                            ),
                            SizedBox(height: 21.67),
                            Container(
                              width: 315,
                              height: 60,
                              child: Container(
                                width: 315,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(76),
                                  color: Color(0x21008b61),
                                ),
                                padding: const EdgeInsets.only(
                                  left: 84,
                                  right: 83,
                                ),
                                child: Text(
                                  "Create an Account",
                                  style: TextStyle(
                                    color: Color(0xff008b61),
                                    fontSize: 18,
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
