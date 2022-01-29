import 'dart:io';

import 'package:cargo/utils/ShColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

class SignaturePad extends StatefulWidget {
  static String tag='/SignaturePad';
  @override
  _SignaturePadState createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  Permission _permission = Permission.storage;


  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.grey[200],
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }



  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var _signatureCanvas = Signature(
      controller: _controller,
      height: height * 0.7,
      width: width,
      backgroundColor: Colors.grey[200],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_app_background,
        elevation: 0,
        iconTheme: IconThemeData(color: sh_white),
        title: Text(
          'Signature',
          style: TextStyle(color: sh_white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //SIGNATURE CANVAS
          _signatureCanvas,
          SizedBox(height: 20,),
          //OK AND CLEAR BUTTONS
          Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex : 2,
                      child: Container()),
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          return _controller.clear();
                        });
                      },
                      child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      height: 36,
                      decoration: BoxDecoration(
                          color: sh_scratch_start_gradient,
                          border: Border.all(
                              color: sh_textColorSecondary, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Center(
                          child: Text(
                            'CLEAR',
                            style: TextStyle(fontSize: 14, color: sh_app_black),
                          )),
                  ),
                    ),),
                  Expanded(
                      flex : 2,
                      child: Container()),
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () async{

                        var data = await _controller.toPngBytes();

                        if(!(await _permission.isGranted)) await requestPermission();
                        // Use plugin [path_provider] to export image to storage
                        Directory directory = await getExternalStorageDirectory();
                        String path = directory.path;
                        String directoryName='Cargo';
                        print(path);
                        await Directory('$path/$directoryName').create(recursive: true);
                        String paths='$path/$directoryName/${formattedDate()}.png';

                        File(paths)
                            .writeAsBytesSync(data);

                        print('image data$data');
                        Navigator.pop(context, paths);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 36,
                        decoration: BoxDecoration(
                            color: sh_scratch_start_gradient,
                            border: Border.all(
                                color: sh_textColorSecondary, width: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Center(
                            child: Text(
                              'SAVE',
                              style: TextStyle(fontSize: 14, color: sh_app_black),
                            )),
                      ),
                    ),),
                  Expanded(
                      flex : 2,
                      child: Container()),
                 ],
              )),
          SizedBox(height: 1,),
        ],
      ),
    );
  }
  String formattedDate() {
    DateTime dateTime = DateTime.now();
    String dateTimeString = 'Signature_' +
        dateTime.year.toString() +
        dateTime.month.toString() +
        dateTime.day.toString() +
        dateTime.hour.toString() +
        ':' + dateTime.minute.toString() +
        ':' + dateTime.second.toString() +
        ':' + dateTime.millisecond.toString() +
        ':' + dateTime.microsecond.toString();
    return dateTimeString;
  }

  requestPermission() async {
    final result = await _permission.request();
    return result;
  }
}

