// import 'dart:async';
// import 'dart:convert';
//
// import 'package:cargo/model/ContactModel.dart';
// import 'package:cargo/screens/ContactUsScreen.dart';
// import 'package:cargo/utils/ShColors.dart';
// import 'package:cargo/utils/ShConstant.dart';
// import 'package:cargo/utils/ShExtension.dart';
// import 'package:cargo/utils/ShStrings.dart';
// import 'package:cargo/utils/ShWidget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class LocationScreen extends StatefulWidget {
//   static String tag = '/LocationScreen';
//
//   @override
//   _LocationScreenState createState() => _LocationScreenState();
// }
//
// class _LocationScreenState extends State<LocationScreen> {
//   Completer<GoogleMapController> _controller = Completer();
//   List<Marker> _markers = <Marker>[];
//   ContactModel contactModel;
//
//
//
//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(13.114860, -59.579170),
//     zoom: 14.4746,
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAlbum();
//   }
//
//   Future<ContactModel> fetchAlbum() async {
//     try {
//
//       Response response = await get(
//           'https://cargobgi.net/wp-json/v3/contact_info');
//
//       final jsonResponse = json.decode(response.body);
//       print('not json $jsonResponse');
//       contactModel = new ContactModel.fromJson(jsonResponse);
//       return contactModel;
//     } catch (e) {
//       print('caught error $e');
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//
//     _markers.add(
//         Marker(
//             markerId: MarkerId('SomeId'),
//             position: LatLng(13.114860, -59.579170),
//             infoWindow: InfoWindow(
//                 title: 'CargoBGI'
//             )
//         )
//     );
//
//     BoxDecoration myBoxDecoration() {
//       return BoxDecoration(
//           border: Border.all(),
//           borderRadius: BorderRadius.all(Radius.circular(5.0)));
//     }
//
//     ContactInfo() {
//       return Container(
//         width: width,
//         margin: EdgeInsets.fromLTRB(10, 10, 24, 10),
//         padding: EdgeInsets.all(6.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             text('CargoBGI',
//                 textColor: sh_app_background,
//                 fontSize: 24.0,
//                 fontFamily: fontBold),
//             SizedBox(
//               height: 4,
//             ),
//             text2(contactModel.data.address,
//                 textColor: sh_textColorPrimary,
//                 fontSize: 16,
//                 fontFamily: fontMedium),
//             SizedBox(
//               height: 4,
//             ),
//             InkWell(
//               onTap: () {
//                 launch("mailto:office@cargobgi.com");
//               },
//               child: text(contactModel.data.email,
//                   textColor: sh_cat_2,
//                   fontSize: textSizeLargeMedium,
//                   fontFamily: fontMedium),
//             ),
//             SizedBox(
//               height: 4,
//             ),
//             InkWell(
//               onTap: () {
//                 _initCall(contactModel.data.phone);
//               },
//               child: text(contactModel.data.phone,
//                   textColor: sh_cat_2,
//                   fontSize: textSizeLargeMedium,
//                   fontFamily: fontMedium),
//             ),
//           ],
//         ),
//       );
//     }
//
//     saveButton() {
//       return Padding(
//         padding: const EdgeInsets.fromLTRB(20.0, 8, 20, 8),
//         child: MaterialButton(
//           height: 50,
//           minWidth: double.infinity,
//           padding: EdgeInsets.all(spacing_standard),
//           child: text(sh_lbl_contact_us,
//               fontSize: textSizeNormal,
//               fontFamily: fontMedium,
//               textColor: sh_white),
//           textColor: sh_white,
//           shape: RoundedRectangleBorder(
//               borderRadius: new BorderRadius.circular(40.0)),
//           color: sh_app_background,
//           onPressed: () {
//             launchScreen(context, ContactUsScreen.tag);
//           },
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: sh_white,
//         title: text('Location',
//             textColor: sh_textColorPrimary,
//             fontSize: textSizeNormal,
//             fontFamily: fontMedium),
//         iconTheme: IconThemeData(color: sh_textColorPrimary),
//       ),
//       body: Container(
//         child: Center(
//           child: FutureBuilder<ContactModel>(
//             future: fetchAlbum(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Column(
//                   children: <Widget>[
//                     Expanded(
//                       flex: 6,
//                       child: Container(
//                         child: GoogleMap(
//                           mapType: MapType.normal,
//                           initialCameraPosition: _kGooglePlex,
//                           onMapCreated: (GoogleMapController controller) {
//                             _controller.complete(controller);
//                           },
//                           markers: Set<Marker>.of(_markers),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 3,
//                       child: Container(
//                         child: ContactInfo(),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         child: saveButton(),
//                       ),
//                     ),
//                   ],
//                 );
//               } else if (snapshot.hasError) {
//                 return Text("${snapshot.error}");
//               }
//               // By default, show a loading spinner.
//               return CircularProgressIndicator();
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   _initCall(String number) async {
//     FlutterPhoneDirectCaller.callNumber(number);
//
// //    await new CallNumber().callNumber('+1(246) 537-2244');
//   }
// }
