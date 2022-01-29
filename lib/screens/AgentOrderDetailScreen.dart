import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cargo/model/AddressListModel.dart';
import 'package:cargo/model/OrderAgentModel.dart';
import 'package:cargo/model/StatusUpdateModel.dart';
import 'package:cargo/screens/AgentOrderListScreen.dart';
import 'package:cargo/screens/SignaturePad.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgentOrderDetailScreen extends StatefulWidget with WidgetsBindingObserver{
  static String tag = '/AgentOrderDetailScreen';

  @override
  _AgentOrderDetailScreenState createState() => _AgentOrderDetailScreenState();
}

class _AgentOrderDetailScreenState extends State<AgentOrderDetailScreen> {
  Permission _permission = Permission.storage;
  Future<OrderAgentModel> futureorder;
  OrderAgentModel order_model;
  StatusUpdateModel statusUpdateModel;
  List<String> status_type = [
    "Imported",
    "On the way",
    "Delivered",
    "Cancelled"
  ];
  var selectedValue;
  String imagevalue;
  ByteData _img = ByteData(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  bool _visible = false;
  bool _visible_sign = false;
  var data;
  final ScrollController _homeController = ScrollController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();
  List<_ItemHolder> _items= [];

  @override
  void initState() {
    super.initState();


    _isLoading = true;
    _permissionReady = false;
    _prepare();
    futureorder = fetchOrder();
    _downloadListener();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  _downloadListener() {
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (status.toString() == "DownloadTaskStatus(3)" && progress == 100 && id != null) {
        String query = "SELECT * FROM task WHERE task_id='" + id + "'";
        var tasks = FlutterDownloader.loadTasksWithRawQuery(query: query);
        //if the task exists, open it
        if (tasks != null) FlutterDownloader.open(taskId: id);
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _download(int index) async {
    String _localPath =
        (await findLocalPath()) + Platform.pathSeparator + 'Example_Downloads';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    String _url =
        order_model.details.invoices[index].invoice;
//    String _url =
//        "https://picsum.photos/200/300?grayscale";
    final download = await FlutterDownloader.enqueue(
      url: _url,
      savedDir: _localPath,
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  void _requestDownload(Invoices task) async {

    task.taskId = await FlutterDownloader.enqueue(
        url: task.invoice,
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  Future<String> findLocalPath() async {
    final directory =
    // (MyGlobals.platform == "android")
    // ?
    await getExternalStorageDirectory();
    // : await getApplicationDocumentsDirectory();
    return directory.path;
  }




  Future<OrderAgentModel> fetchOrder() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String order_id = prefs.getString('order_id');
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoAuthToken': token,
        'cargoUserId': UserId
      };

      Response response = await get(
          'https://cargobgi.net/wp-json/v3/shipment_details?shipment_id=$order_id',
          headers: headers);

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
//      order_model = new OrderDetailModel.fromJson(responsefnl.data);
      order_model = new OrderAgentModel.fromJson(jsonResponse);
      selectedValue = order_model.details.status;
      imagevalue = order_model.details.signature;
      if (imagevalue.length > 5) {
        _visible_sign = false;
      } else {
        _visible_sign = true;
      }

      final tasks = await FlutterDownloader.loadTasks();
      int count = 0;

      for (int i = count; i < order_model.details.invoices.length; i++) {
        _items.add(_ItemHolder(task: order_model.details.invoices[i]));
        count++;
      }

      tasks?.forEach((task) {
        for (Invoices info in order_model.details.invoices) {
          if (info.invoice == task.url) {
            info.taskId = task.taskId;
            info.status = task.status;
            info.progress = task.progress;
          }
        }
      });

      return order_model;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<StatusUpdateModel> getUpdate() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String order_id = prefs.getString('order_id');
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoAuthToken': token,
        'cargoUserId': UserId
      };
      Response responsefnl;

      if (data != null && data != '') {
        File fls = File(data);
        Uint8List bytes = fls.readAsBytesSync();

        var result = fls.path;
        print('file name is $result');

        String fileName = fls.path.split('/').last;

        String base64Image = base64Encode(bytes);
        final msg = jsonEncode({
          "status": selectedValue,
          "quote_id": order_id,
          "signature": base64Image,
          "name": fileName,
        });

        responsefnl = await post(
            'https://cargobgi.net/wp-json/v3/update_shipping_status',
            headers: headers,
            body: msg);
      } else {
        final msg = jsonEncode({"status": selectedValue, "quote_id": order_id});

        responsefnl = await post(
            'https://cargobgi.net/wp-json/v3/update_shipping_status',
            headers: headers,
            body: msg);
      }

      final jsonResponse = json.decode(responsefnl.body);
      print('not json $jsonResponse');
      statusUpdateModel = new StatusUpdateModel.fromJson(jsonResponse);
      if (statusUpdateModel.success) {
        toast('Updated');
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Route route =
            MaterialPageRoute(builder: (context) => AgentOrderListScreen());
        Navigator.pushReplacement(context, route);
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        toast('Something Went Wrong');
      }

//      selectedValue = order_model.details.status;
      return statusUpdateModel;
    } catch (e) {
      rethrow;
    }
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  Future<bool> _openDownloadedFile(Invoices task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    ImageAs() {
      if (data != null && data != '') {
        _visible = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _homeController.animateTo(_homeController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        });
        if (imagevalue.length > 5) {
          return Container(
              height: 200, child: Image.network(order_model.details.signature));
        } else {
          return Visibility(
            visible: _visible,
            child: Container(height: 200, child: Image.file(new File(data))),
          );
        }
      } else {
        _visible = false;
        if (imagevalue.length > 5) {
          return Container(
              height: 200, child: Image.network(order_model.details.signature));
        } else {
          return Container();
        }
      }
    }

    AddSignature() {
      if (imagevalue.length > 5) {
        return Container();
      } else {
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignaturePad()))
                .then((value) {
              setState(() {
                // refresh state of Page1
                data = value;
                print('image as$data');
                if (data != null && data != '') {
                  _visible = true;
                } else {
                  _visible = false;
                }
              });
            });
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(30, 12, 30, 12),
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            height: 36,
            decoration: BoxDecoration(
                color: sh_scratch_start_gradient,
                border: Border.all(color: sh_textColorSecondary, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: Center(
                child: Text(
              'Capture Sign',
              style: TextStyle(fontSize: 14, color: sh_app_black),
            )),
          ),
        );
      }
    }

    saveButton() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          height: 50,
          minWidth: double.infinity,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          onPressed: () {
            getUpdate();
          },
          color: sh_app_background,
          child: text(sh_lbl_update,
              fontFamily: fontMedium,
              fontSize: textSizeLargeMedium,
              textColor: sh_white),
        ),
      );
    }

    StatusList() {
      return Container(
        margin: EdgeInsets.fromLTRB(30, 12, 30, 12),
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        child: DropdownButton<String>(
          underline: SizedBox(),
          isExpanded: true,
          items: status_type.map((item) {
            return new DropdownMenuItem(
              child: Text(
                item,
                style: TextStyle(
                    fontSize: 15,
                    color: sh_app_black,
                    fontWeight: FontWeight.bold),
              ),
              value: item,
            );
          }).toList(),
          hint: Text('Select Status'),
          value: selectedValue,
          onChanged: (newVal) {
            setState(() {
              selectedValue = newVal;
            });
          },
        ),
      );
    }

    ListQuote(int index) {
      int dd = index + 1;
      String dg = order_model.details.items[index].itemType;
      return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child: Text(
                      'Item $dd: ',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 13,
                          color: sh_app_black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    ' $dg',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: TextStyle(
                        fontSize: 13,
                        color: sh_app_black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            )
          ],
        ),
      );
    }

    ListInvoice(int index) {
      int dd = index + 1;
      String fileName = order_model.details.invoices[index].invoice.split('/').last;
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    (Expanded(
                        flex: 6,
                        child: GestureDetector(
                          onTap: () {
                            _openDownloadedFile(_items[index].task).then((success) {
                              if (!success) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Cannot open this file')));
                              }
                            });
                          },
                          child: Text(
                            fileName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: TextStyle(
                                fontSize: 12,
                                color: sh_app_black,
                                fontWeight: FontWeight.bold),
                          ),
                        ))),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Center(
                            child: IconButton(
                                icon: Icon(Icons.file_download), onPressed: () async{
                              if(!(await _permission.isGranted)) await requestPermission();
                              toast('Downloading..');
//                              _download(index);
                              _requestDownload(_items[index].task);
                            })),
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
          SizedBox(height: 8,)
        ],
      );
    }

    listView() {
      String sts = order_model.details.status;
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color: sh_app_background,
                              size: 30,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Details',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.chevron_left,
                              color: sh_app_background,
                              size: 36,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      height: 1,
                      color: sh_dots_color,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Package #',
                          style: TextStyle(
                              fontSize: 15,
                              color: sh_app_black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          order_model.details.shipment_order_id,
                          style: TextStyle(
                              fontSize: 15,
                              color: sh_app_background,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' is $sts.',
                          style: TextStyle(
                              fontSize: 15,
                              color: sh_app_black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Order Date: ',
                            style: TextStyle(
                                fontSize: 15,
                                color: sh_app_black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            order_model.details.date,
                            style: TextStyle(
                                fontSize: 15,
                                color: sh_app_black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delivery Mode : Pick Up/Home Delivery',
                        style: TextStyle(
                            fontSize: 15,
                            color: sh_app_black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Invoices',
                        style: TextStyle(
                            fontSize: 16,
                            color: sh_app_background,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: order_model.details.invoices.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListInvoice(index);
                        }),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Package Details',
                        style: TextStyle(
                            fontSize: 16,
                            color: sh_app_background,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: order_model.details.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListQuote(index);
                        }),
                  ],
                ),
              ),
              color: sh_white,
              margin: EdgeInsets.fromLTRB(26, 4, 26, 0),
            ),
            SizedBox(
              height: 20,
            ),
            StatusList(),
            SizedBox(
              height: 12,
            ),
            AddSignature(),
            ImageAs()
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_app_background,
        elevation: 0,
        iconTheme: IconThemeData(color: sh_white),
        title: Text(
          'Details',
          style: TextStyle(color: sh_white),
        ),
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 9,
              child: SingleChildScrollView(
                controller: _homeController,
                child: Column(
                  children: <Widget>[
                    FutureBuilder<OrderAgentModel>(
                      future: futureorder,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return listView();
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default, show a loading spinner.
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(flex: 1, child: saveButton())
          ],
        ),
      ),
    );
  }
  requestPermission() async {
    final result = await _permission.request();
    return result;
  }
  Future<bool> _checkPermission() async {
//    if (widget.platform == TargetPlatform.android) {
    final status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }

    return false;
  }
  Future<String> _findLocalPath() async {
    if (Platform.isAndroid) {
      // Android-specific code
      final directory =
      await getExternalStorageDirectory();
      return directory.path;

    } else if (Platform.isIOS) {
      // iOS-specific code
      final directory =  await getApplicationDocumentsDirectory();
      return directory.path;

    }
  }
  Future<Null> _prepare() async {


    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download5';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

}
class _ItemHolder {
  final Invoices task;

  _ItemHolder({this.task});
}