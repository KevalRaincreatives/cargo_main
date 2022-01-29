import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10,),
                        Text("Please Wait....",style: TextStyle(color: Colors.blueAccent),)
                      ]),
                    )
                  ]));
        });
  }
}

Future<void> openFile(var path) async {
  final filePath = path;
  // final filePath = '/Users/chendong/Downloads/S91010-16435053-221705-o_1dmqeua2a2v2o0u126l1baqqc21e-uid-1817947@1080x2160.jpg';
  // await dio.download("https://imgsa.baidu.com/exp/w=500/sign=9d6f3ebe35d3d539c13d0fc30a86e927/7aec54e736d12f2eedbdb0204cc2d56285356831.jpg", filePath);

  final result = await OpenFile.open(filePath);



}