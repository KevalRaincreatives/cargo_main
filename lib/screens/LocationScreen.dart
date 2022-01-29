import 'dart:async';
import 'dart:convert';

import 'package:cargo/model/Contact2Model.dart';
import 'package:cargo/model/ContactModel.dart';
import 'package:cargo/screens/ContactUsScreen.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationScreen extends StatefulWidget {
  static String tag = '/LocationScreen';

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<Marker> _markers = <Marker>[];
  Completer<GoogleMapController> _controller = Completer();

  // ContactModel contactModel;
  Contact2Model contactModel;
  var _listIconTabToggle = [
    Icons.location_on,
    Icons.location_on,
  ];
  var _listGenderText = ["BARBADOS", "MIAMI - USA"];
  var _tabTextIconIndexSelected = 0;

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(13.114860, -59.579170),
  //   zoom: 14.4746,
  // );

  @override
  void initState() {
    super.initState();
    fetchAlbum();
  }

  Future<Contact2Model> fetchAlbum() async {
    try {
      Response response =
          await get('https://cargobgi.net/wp-json/v3/contact_info');

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      contactModel = new Contact2Model.fromJson(jsonResponse);
      return contactModel;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<void> _copyToClipboard(String tcxt) async {
    await Clipboard.setData(ClipboardData(text: tcxt));
    toast("Copied to clipboard");
  }

  Future<void> _makePhoneCall(String url) async {
    // toast(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _goToTheLake(int index) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _tabTextIconIndexSelected == 0
          ? LatLng(double.parse(contactModel.data.latitude),
          double.parse(contactModel.data.longitude))
          : LatLng(double.parse(contactModel.dataAddress.latitude),
          double.parse(contactModel.dataAddress.longitude)),
      zoom: 12,
    )));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    // Future<void> moveCamera() async {
    //   final GoogleMapController controller = await _controller.future;
    //   controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //     target: _tabTextIconIndexSelected == 0
    //         ? LatLng(double.parse(contactModel.data.latitude),
    //             double.parse(contactModel.data.longitude))
    //         : LatLng(double.parse(contactModel.dataAddress.latitude),
    //             double.parse(contactModel.dataAddress.longitude)),
    //     zoom: 14,
    //   )));
    // }

    MapInfo() {
      CameraPosition _kGooglePlex=null;

      _markers.clear();
      _markers.add(Marker(
          markerId: MarkerId('SomeId'),
          position: _tabTextIconIndexSelected == 0
              ? LatLng(double.parse(contactModel.data.latitude),
                  double.parse(contactModel.data.longitude))
              : LatLng(double.parse(contactModel.dataAddress.latitude),
                  double.parse(contactModel.dataAddress.longitude)),
          infoWindow: InfoWindow(title: 'CargoBGI')));

      _kGooglePlex = CameraPosition(
        target: _tabTextIconIndexSelected == 0
            ? LatLng(double.parse(contactModel.data.latitude),
                double.parse(contactModel.data.longitude))
            : LatLng(double.parse(contactModel.dataAddress.latitude),
                double.parse(contactModel.dataAddress.longitude)),
        zoom: 12,
      );

      return GoogleMap(
        mapType: MapType.normal,

        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          // moveCamera();
        },
        markers: Set<Marker>.of(_markers),
      );
    }

    BoxDecoration myBoxDecoration() {
      return BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(5.0)));
    }

    ContactInfo() {
      return Container(
        width: width,
        margin: EdgeInsets.fromLTRB(10, 10, 24, 6),
        padding: EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            text('CargoBGI',
                textColor: sh_app_background,
                fontSize: 23.0,
                fontFamily: fontBold),
            SizedBox(
              height: 2,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text2(
                          _tabTextIconIndexSelected == 0
                              ? contactModel.data.address1
                              : contactModel.dataAddress.address1,
                          textColor: sh_textColorPrimary,
                          fontSize: 15,
                          fontFamily: fontMedium),
                      text2(
                          _tabTextIconIndexSelected == 0
                              ? contactModel.data.address2
                              : contactModel.dataAddress.address2,
                          textColor: sh_textColorPrimary,
                          fontSize: 15,
                          fontFamily: fontMedium),
                      text2(
                          _tabTextIconIndexSelected == 0
                              ? contactModel.data.address3
                              : contactModel.dataAddress.address3,
                          textColor: sh_textColorPrimary,
                          fontSize: 15,
                          fontFamily: fontMedium),
                    ],
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.copy,color: sh_app_background,size: 20,),
                    onPressed: () async{
                      if(_tabTextIconIndexSelected == 0){
                        String str1=contactModel.data.address1;
                        String str2=contactModel.data.address2;
                        String str3=contactModel.data.address3;
                        _copyToClipboard(str1+"\n"+str2+"\n"+str3);
                      }else{
                          String str1=contactModel.dataAddress.address1;
                          String str2=contactModel.dataAddress.address2;
                          String str3=contactModel.dataAddress.address3;
                          _copyToClipboard(str1+"\n"+str2+"\n"+str3);
                      }

                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 2,
            ),
            InkWell(
              onTap: () {
                launch("mailto:office@cargobgi.com");
              },
              child: text(
                  _tabTextIconIndexSelected == 0
                      ? contactModel.data.email
                      : contactModel.dataAddress.email,
                  // contactModel.data.email,
                  textColor: sh_cat_2,
                  fontSize: textSizeMedium,
                  fontFamily: fontMedium),
            ),
            SizedBox(
              height: 2,
            ),
            InkWell(
              onTap: () {
                _initCall(
                  _tabTextIconIndexSelected == 0
                      ? contactModel.data.phone
                      : contactModel.dataAddress.phone,
                );
              },
              child: text(
                  _tabTextIconIndexSelected == 0
                      ? contactModel.data.phone
                      : contactModel.dataAddress.phone,
                  textColor: sh_cat_2,
                  fontSize: textSizeMedium,
                  fontFamily: fontMedium),
            ),
          ],
        ),
      );
    }

    saveButton() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 2, 20, 2),
        child: MaterialButton(
          height: 40,
          minWidth: double.infinity,
          padding: EdgeInsets.all(spacing_standard),
          child: text(sh_lbl_contact_us,
              fontSize: textSizeNormal,
              fontFamily: fontMedium,
              textColor: sh_white),
          textColor: sh_white,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(40.0)),
          color: sh_app_background,
          onPressed: () {
            launchScreen(context, ContactUsScreen.tag);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text('Our Locations',
            textColor: sh_textColorPrimary,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder<Contact2Model>(
            future: fetchAlbum(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlutterToggleTab(
                          width: 70,
                          borderRadius: 15,
                          selectedTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                          unSelectedTextStyle: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          labels: _listGenderText,
                          icons: _listIconTabToggle,
                          selectedIndex: _tabTextIconIndexSelected,
                          selectedLabelIndex: (index) {
                            _goToTheLake(index);

                            setState(() {
                              _tabTextIconIndexSelected = index;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: Container(
                              child: MapInfo(),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              child: ContactInfo(),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: saveButton(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  _initCall(String number) async {
    final Uri _phoneLaunchUri =
    Uri(scheme: 'tel', path: number);
    _makePhoneCall(_phoneLaunchUri.toString());
    // _makePhoneCall(number);

//    await new CallNumber().callNumber('+1(246) 537-2244');
  }
}
