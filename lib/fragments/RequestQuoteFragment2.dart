import 'package:cargo/screens/ThankYouScreen.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestQuoteFragment extends StatefulWidget {
  @override
  _RequestQuoteFragmentState createState() => _RequestQuoteFragmentState();
}

class _RequestQuoteFragmentState extends State<RequestQuoteFragment> {
  List _numbers = ["Please select package type", "Bus", "Car", "Van"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentNumber;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentNumber = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _numbers) {
      items.add(new DropdownMenuItem(
          value: city,
          child: Container(
            child: new Text(
              city,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          )));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    HeightBox() {
      return Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: TextFormField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
              color: sh_app_background,
              fontFamily: fontRegular,
              fontSize: textSizeMedium),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Please Enter Email';
            }
            return null;
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: sh_transparent,
              focusColor: sh_app_background,
              hintText: 'H',
              hintStyle: TextStyle(
                  color: sh_textColorSecondary,
                  fontFamily: fontRegular,
                  fontSize: textSizeMedium),
              contentPadding: EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: sh_app_background, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: sh_app_background, width: 1.5))),
        ),
      );
    }

    WeightBox() {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
        child: TextFormField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
              color: sh_app_background,
              fontFamily: fontRegular,
              fontSize: textSizeMedium),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Please Enter Email';
            }
            return null;
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: sh_transparent,
              focusColor: sh_app_background,
              hintText: 'W',
              hintStyle: TextStyle(
                  color: sh_textColorSecondary,
                  fontFamily: fontRegular,
                  fontSize: textSizeMedium),
              contentPadding: EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: sh_app_background, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: sh_app_background, width: 1.5))),
        ),
      );
    }

    LengthBox() {
      return Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Center(
          child: TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
                color: sh_app_background,
                fontFamily: fontRegular,
                fontSize: textSizeMedium),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Please Enter Email';
              }
              return null;
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: sh_transparent,
                focusColor: sh_app_background,
                hintText: 'L',

                hintStyle: TextStyle(
                    color: sh_textColorSecondary,
                    fontFamily: fontRegular,
                    fontSize: textSizeMedium),
                contentPadding: EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: sh_app_background, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: sh_app_background, width: 1.5))),
          ),
        ),
      );
    }

    LbsBox() {
      return Container(
        margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: TextFormField(
          textAlign: TextAlign.end,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
              color: sh_app_background,
              fontFamily: fontRegular,
              fontSize: textSizeMedium),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Please Enter Email';
            }
            return null;
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: sh_transparent,
              focusColor: sh_app_background,
              hintText: 'lbs',
              hintStyle: TextStyle(
                  color: sh_textColorSecondary,
                  fontFamily: fontRegular,
                  fontSize: textSizeMedium),
              contentPadding: EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: sh_app_background, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: sh_app_background, width: 1.5))),
        ),
      );
    }

    PriceBox() {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: TextFormField(
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
              color: sh_app_background,
              fontFamily: fontRegular,
              fontSize: textSizeMedium),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Please Enter Email';
            }
            return null;
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: sh_transparent,
              focusColor: sh_app_background,
              hintText: '\$',
              hintStyle: TextStyle(
                  color: sh_textColorSecondary,
                  fontFamily: fontRegular,
                  fontSize: textSizeMedium),
              contentPadding: EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: sh_app_background, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: sh_app_background, width: 1.5))),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: width,
        height: height,
        color: sh_background_color,
        padding: EdgeInsets.fromLTRB(30, 00, 30, 0),
        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DropdownButton(
                  value: _currentNumber,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem),
              SizedBox(
                height: 14,
              ),
              Text(
                'Dimensions & Weight',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Expanded(flex: 2, child: WeightBox()),
                  Expanded(flex: 2, child: HeightBox()),
                  Expanded(flex: 2, child: LengthBox()),
                  Expanded(flex: 4, child: LbsBox())
                ],
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                'Item Price',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Expanded(flex: 4, child: PriceBox()),
                  Expanded(flex: 2, child: Container()),
                  Expanded(flex: 2, child: Container()),
                  Expanded(flex: 2, child: Container())
                ],
              ),
              SizedBox(
                height: 18,
              ),
              DropdownButton(
                  value: _currentNumber,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: 36,
                  decoration: BoxDecoration(
                      color: sh_app_background,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Center(child: Row(
                    children: <Widget>[
                      Icon(Icons.add,color: sh_white,size: 16,),
                      Text('Add Item',style: TextStyle(fontSize: 13,color: sh_white),),
                    ],
                  )),
                ),
              ],),
              SizedBox(
                height: 38,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    height: 36,
                    decoration: BoxDecoration(
                        color: sh_app_background,
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Center(child: GestureDetector(
                      onTap: (){
                        launchScreen(context, ThankYouScreen.tag);
                      },
                        child: Text('Request Quote',style: TextStyle(fontSize: 14,color: sh_white),))),
                  ),
                ],)
            ],
          ),
        ),
      ),
    );
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentNumber = selectedCity;
    });
  }
}
