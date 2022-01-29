import 'dart:convert';

import 'package:cargo/model/ItemTypeModel.dart';
import 'package:cargo/model/PackageTypeModel.dart';
import 'package:cargo/model/QuoteSuccess.dart';
import 'package:cargo/model/RequestQuoteModel.dart';
import 'package:cargo/screens/ThankYouScreen.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestQuoteFragment extends StatefulWidget {
  @override
  _RequestQuoteFragmentState createState() => _RequestQuoteFragmentState();
}

class _RequestQuoteFragmentState extends State<RequestQuoteFragment> {
  var widthCont = TextEditingController();
  var heightCont = TextEditingController();
  var lengthCont = TextEditingController();
  var weightCont = TextEditingController();
  var priceCont = TextEditingController();
  List _numbers = ["Please select package type", "Bus", "Car", "Van"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentNumber;
  final List<ItemsModel> itemsModel = [];
  final ScrollController _homeController = ScrollController();
  ItemsModel itModel;
  QuoteSuccessModel quoteSuccessModel;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final _formKey = GlobalKey<FormState>();
  Future packagedetail;
  PackageTypeModel packageModel;
  var selectedPackageValue;
  var packagename = "us";
  var packageid = "us";
  String _dropdownPackageError;

  Future itemdetail;
  ItemTypeModel itemtypeModel;
  var selectedItemValue;
  var itemname = "us";
  var itemid = "us";
  String _dropdownItemError;
  String action_str = 'Add Item';
  int action_index = -3;
  bool _visible=true;
  FocusNode myFocusNode;



  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentNumber = _dropDownMenuItems[0].value;
    super.initState();
    packagedetail = fetchpackage();
    itemdetail = fetchitem();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }


  Future<PackageTypeModel> fetchpackage() async {
    try {
      Response response =
          await get('https://cargobgi.net/wp-json/v3/packages');
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      packageModel = new PackageTypeModel.fromJson(jsonResponse);
      return packageModel;
    } catch (e) {
      print('Caught error $e');
    }
  }

  Future<ItemTypeModel> fetchitem() async {
    try {
      Response response =
          await get('https://cargobgi.net/wp-json/v3/items');
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      itemtypeModel = new ItemTypeModel.fromJson(jsonResponse);
      return itemtypeModel;
    } catch (e) {
      print('Caught error $e');
    }
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

  void addItemToList() async {
    setState(() {
      if (action_index == -3) {
        itModel = ItemsModel(
            package_type: packagename,
            package_id: packageid,
            package_value: selectedPackageValue,
            width: widthCont.text,
            height: heightCont.text,
            length: lengthCont.text,
            weight: weightCont.text,
            item_type: itemname,
            item_id: itemid,
            item_value: selectedItemValue,
            price: priceCont.text);
        itemsModel.add(itModel);
//        _homeController.animateTo(180.0,
//            duration: Duration(milliseconds: 500), curve: Curves.ease);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _homeController.animateTo(_homeController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        });
        widthCont.clear();
        heightCont.clear();
        lengthCont.clear();
        weightCont.clear();
        priceCont.clear();
        selectedPackageValue = null;
        selectedItemValue = null;
        toast('Added');
      } else {
        itemsModel[action_index].package_type = packagename;
        itemsModel[action_index].package_id = packageid;
        itemsModel[action_index].package_value = selectedPackageValue;
        itemsModel[action_index].width = widthCont.text;
        itemsModel[action_index].height = heightCont.text;
        itemsModel[action_index].length = lengthCont.text;
        itemsModel[action_index].weight = weightCont.text;
        itemsModel[action_index].item_type = itemname;
        itemsModel[action_index].item_id = itemid;
        itemsModel[action_index].item_value = selectedItemValue;
        itemsModel[action_index].price = priceCont.text;

//        _homeController.animateTo(180.0,
//            duration: Duration(milliseconds: 500), curve: Curves.ease);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _homeController.animateTo(_homeController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        });
        widthCont.clear();
        heightCont.clear();
        lengthCont.clear();
        weightCont.clear();
        priceCont.clear();
        action_index = -3;
        toast('Updated');
      }
    });
  }

  void addItemToMainList() async {
    setState(() {
      if(_visible) {
        if (action_index == -3) {
          itModel = ItemsModel(
              package_type: packagename,
              package_id: packageid,
              package_value: selectedPackageValue,
              width: widthCont.text,
              height: heightCont.text,
              length: lengthCont.text,
              weight: weightCont.text,
              item_type: itemname,
              item_id: itemid,
              item_value: selectedItemValue,
              price: priceCont.text);
          itemsModel.add(itModel);

          widthCont.clear();
          heightCont.clear();
          lengthCont.clear();
          weightCont.clear();
          priceCont.clear();
          selectedPackageValue = null;
          selectedItemValue = null;
          toast('Added');

          fetchquotes();
        } else {
          itemsModel[action_index].package_type = packagename;
          itemsModel[action_index].package_id = packageid;
          itemsModel[action_index].package_value = selectedPackageValue;
          itemsModel[action_index].width = widthCont.text;
          itemsModel[action_index].height = heightCont.text;
          itemsModel[action_index].length = lengthCont.text;
          itemsModel[action_index].weight = weightCont.text;
          itemsModel[action_index].item_type = itemname;
          itemsModel[action_index].item_id = itemid;
          itemsModel[action_index].item_value = selectedItemValue;
          itemsModel[action_index].price = priceCont.text;


          widthCont.clear();
          heightCont.clear();
          lengthCont.clear();
          weightCont.clear();
          priceCont.clear();
          action_index = -3;
          toast('Updated');

          fetchquotes();
        }
      }else{
        fetchquotes();
      }
    });
  }

  Future<QuoteSuccessModel> fetchquotes() async {
    try {
      Dialogs.showLoadingDialog(context, _keyLoader);

      String jsonTutorial = jsonEncode(itemsModel);

      Map data = {'items': itemsModel};


      String body = json.encode(data);

      print(jsonTutorial);
      print(body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'CargoAuthToken': token,
        'CargoUserId': UserId
      };

      Response response = await post(
        'https://cargobgi.net/wp-json/v3/quote',
        headers: headers,
        body: body,
      );

      final jsonResponse = json.decode(response.body);

      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      print('not json $jsonResponse');
      quoteSuccessModel = new QuoteSuccessModel.fromJson(jsonResponse);
      if (quoteSuccessModel.success) {
        String suc_id = quoteSuccessModel.quote_id.toString();
        prefs.setString("success_id", suc_id);

        launchScreen(context, ThankYouScreen.tag);
      } else {
        toast('Something Went Wrong');
      }

      return quoteSuccessModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  _validateForm() {
    bool _isValid = _formKey.currentState.validate();

    if (selectedPackageValue == null &&
        selectedPackageValue == 'Please Select Package Type') {
      setState(() => _dropdownPackageError = "Please select an option!");
      _isValid = false;
    } else {
      _dropdownPackageError = null;
    }

    if (selectedItemValue == null &&
        selectedItemValue == 'Please Select Item Type') {
      setState(() => _dropdownItemError = "Please select an option!");
      _isValid = false;
    } else {
      _dropdownItemError = null;
    }

    if (_isValid) {
      FocusScope.of(context).unfocus();
//      myFocusNode.requestFocus();
      addItemToList(); //form is valid
    }
  }

  _validateMainForm() {
    bool _isValidMaAin = _formKey.currentState.validate();

    if (selectedPackageValue == null &&
        selectedPackageValue == 'Please Select Package Type') {
      setState(() => _dropdownPackageError = "Please select an option!");
      _isValidMaAin = false;
    } else {
      _dropdownPackageError = null;
    }

    if (selectedItemValue == null &&
        selectedItemValue == 'Please Select Item Type') {
      setState(() => _dropdownItemError = "Please select an option!");
      _isValidMaAin = false;
    } else {
      _dropdownItemError = null;
    }

    if (_isValidMaAin) {
      addItemToMainList(); //form is valid
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    HeightBox() {
      return Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: TextFormField(
          controller: heightCont,
          textAlign: TextAlign.center,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
          keyboardType: TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          style: TextStyle(
              color: sh_app_background,
              fontFamily: fontRegular,
              fontSize: textSizeSMedium),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return '';
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
                  fontSize: textSizeSMedium),
              contentPadding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: sh_app_background, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      BorderSide(color: sh_app_background, width: 1.5))),
        ),
      );
    }

    WidthBox() {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
        child: TextFormField(
          focusNode: myFocusNode,
          controller: widthCont,
          textAlign: TextAlign.center,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
          keyboardType: TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          style: TextStyle(
              color: sh_app_background,
              fontFamily: fontRegular,
              fontSize: textSizeSMedium),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return '';
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
                  fontSize: textSizeSMedium),
              contentPadding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: sh_app_background, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      BorderSide(color: sh_app_background, width: 1.5))),
        ),
      );
    }

    LengthBox() {
      return Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Center(
          child: TextFormField(
            controller: lengthCont,
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
            keyboardType: TextInputType.numberWithOptions(
                signed: true, decimal: true),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            style: TextStyle(
                color: sh_app_background,
                fontFamily: fontRegular,
                fontSize: textSizeSMedium),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return '';
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
                    fontSize: textSizeSMedium),
                contentPadding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: sh_app_background, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: sh_app_background, width: 1.5))),
          ),
        ),
      );
    }

    LbsBox() {
      return Container(
        margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: sh_app_background, width: 1.5),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                  child: TextFormField(
                    controller: weightCont,
                    textAlign: TextAlign.start,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(
                        color: sh_app_background,
                        fontFamily: fontRegular,
                        fontSize: textSizeSMedium),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                  ),
                )),
            Expanded(
                flex: 4,
                child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                    child: Text(
                      'lbs',
                      style: TextStyle(color: sh_app_background, fontSize: textSizeSMedium),
                    )))
          ],
        ),
      );
    }

    PriceBox() {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: sh_app_background, width: 1.5),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                    child: Text(
                      "\$",
                      style: TextStyle(color: sh_app_background, fontSize: textSizeSMedium),
                    ))),
            Expanded(
                flex: 8,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                  child: TextFormField(
                    controller: priceCont,
                    textAlign: TextAlign.start,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(
                        color: sh_app_background,
                        fontFamily: fontRegular,
                        fontSize: textSizeSMedium),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                  ),
                )),
          ],
        ),
      );
    }

    ListQuote(int index) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Package Type - ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    '${itemsModel[index].package_type}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Width - ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    '${itemsModel[index].width}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Height - ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    '${itemsModel[index].height}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Length - ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    '${itemsModel[index].length}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Wight - ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    '${itemsModel[index].weight}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Item Price - ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    '${itemsModel[index].price}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Item Type - ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    '${itemsModel[index].item_type}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: GestureDetector(
                      onTap: () async {
//                        SharedPreferences prefs = await SharedPreferences.getInstance();
//                        prefs.setString('edit', 'edit');
                        setState(() {
                          selectedPackageValue =
                              itemsModel[index].package_value;
                          packagename = itemsModel[index].package_type;
                          packageid = itemsModel[index].package_id;
                          widthCont.text = itemsModel[index].width;
                          heightCont.text = itemsModel[index].height;
                          lengthCont.text = itemsModel[index].length;
                          weightCont.text = itemsModel[index].weight;
                          priceCont.text = itemsModel[index].price;
                          selectedItemValue = itemsModel[index].item_value;
                          itemname = itemsModel[index].item_type;
                          itemid = itemsModel[index].item_id;
                          action_str = 'Add Item';
                          action_index = index;
                          _visible=true;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _homeController.animateTo(
                                _homeController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);
                          });
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        height: 30,
                        decoration: BoxDecoration(
                            color: sh_green,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Center(
                            child: Text(
                          'Edit',
                          style: TextStyle(fontSize: 13, color: sh_white),
                        )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          itemsModel.removeAt(index);
                          toast('Deleted');
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        height: 30,
                        decoration: BoxDecoration(
                            color: sh_red,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Center(
                            child: Text(
                          'Delete',
                          style: TextStyle(fontSize: 13, color: sh_white),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    PackageType() {
      return FutureBuilder<PackageTypeModel>(
          future: packagedetail,
          builder:
              (BuildContext context, AsyncSnapshot<PackageTypeModel> snapshot) {
            if (!snapshot.hasData)
              return CupertinoActivityIndicator(
                animating: true,
              );
            return Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: sh_app_background, width: 1.5),
              ),
              child: DropdownButton<PackageResponse>(
                underline: SizedBox(),
                isExpanded: true,
                items: snapshot.data.response
                    .map((countyState) => DropdownMenuItem<PackageResponse>(
                          child: Text(
                            countyState.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: fontRegular,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          value: countyState,
                        ))
                    .toList(),
                hint: Text(
                  'Please Select Package Type',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                value: selectedPackageValue,
                onChanged: (PackageResponse newVal) {
                  setState(() {
                    selectedPackageValue = newVal;
                    packagename = newVal.name;
                    packageid = newVal.termTaxonomyId.toString();
                    widthCont.text = newVal.width;
                    heightCont.text = newVal.height;
                    lengthCont.text = newVal.length;
                  });
                },
              ),
            );
          });
    }

    ItemType() {
      return FutureBuilder<ItemTypeModel>(
          future: itemdetail,
          builder:
              (BuildContext context, AsyncSnapshot<ItemTypeModel> snapshot) {
            if (!snapshot.hasData)
              return CupertinoActivityIndicator(
                animating: true,
              );
            return Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: sh_app_background, width: 1.5),
              ),
              child: DropdownButton<ItemResponse>(
                underline: SizedBox(),
                isExpanded: true,
                items: snapshot.data.response
                    .map((countyState) => DropdownMenuItem<ItemResponse>(
                          child: Text(
                            countyState.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: fontRegular,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          value: countyState,
                        ))
                    .toList(),
                hint: Text(
                  'Please Select Item Type',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                value: selectedItemValue,
                onChanged: (ItemResponse newVal) {
                  setState(() {
                    selectedItemValue = newVal;
                    itemname = newVal.name;
                    itemid = newVal.termTaxonomyId.toString();
                  });
                },
              ),
            );
          });
    }

    mainList() {
      return Visibility(
        visible: _visible,
        child: Card(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                PackageType(),
                _dropdownPackageError == null
                    ? SizedBox.shrink()
                    : Text(_dropdownPackageError ?? "",
                        style: TextStyle(color: Colors.red)),
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
                    Expanded(flex: 2, child: WidthBox()),
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
                ItemType(),
                _dropdownItemError == null
                    ? SizedBox.shrink()
                    : Text(_dropdownItemError ?? "",
                        style: TextStyle(color: Colors.red)),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      height: 36,
                      decoration: BoxDecoration(
                          color: sh_scratch_start_gradient,
                          border: Border.all(color: sh_textColorSecondary, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Center(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if(action_index==-3){
                                    if(itemsModel.length>0) {
                                      _visible = false;
                                    }else{
                                      _visible=true;
                                    }
                                  }else {
                                    _visible=false;
                                    itemsModel.removeAt(action_index);
                                    toast('Deleted');
                                  }
                                });

//                              fetchquotes();

//                              launchScreen(context, ThankYouScreen.tag);
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(fontSize: 14, color: sh_app_black),
                              ))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: width,
        height: height,
        color: sh_background_color,
        padding: EdgeInsets.fromLTRB(10, 00, 10, 0),
        child: SingleChildScrollView(
          controller: _homeController,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: itemsModel.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListQuote(index);
                    }),
                SizedBox(
                  height: 14,
                ),
                mainList(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _validateForm();
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        height: 36,
                        decoration: BoxDecoration(
                            color: sh_app_background,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Center(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  color: sh_white,
                                  size: 16,
                                ),
                                Text(
                                  action_str,
                                  style: TextStyle(fontSize: 13, color: sh_white),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
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
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Center(
                          child: GestureDetector(
                              onTap: () {
                                _validateMainForm();

//                              launchScreen(context, ThankYouScreen.tag);
                              },
                              child: Text(
                                'Request Quote',
                                style: TextStyle(fontSize: 14, color: sh_white),
                              ))),
                    ),
                  ],
                )
              ],
            ),
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
