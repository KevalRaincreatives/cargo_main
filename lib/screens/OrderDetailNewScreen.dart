import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cargo/model/ErrorMainModel.dart';
import 'package:cargo/model/OrderDetailModel.dart';
import 'package:cargo/model/OrderUpdateModel.dart';
import 'package:cargo/model/QuoteSuccess.dart';
import 'package:cargo/model/UploadInvoiceModel.dart';
import 'package:cargo/model/_ItemHolder.dart';
import 'package:cargo/screens/MyAccountScreen.dart';
import 'package:cargo/screens/SelectDeliveryScreen.dart';
import 'package:cargo/screens/SplashScreens.dart';
import 'package:cargo/utils/CargoImages.dart';
import 'package:cargo/utils/Dialogs.dart';
import 'package:cargo/utils/ShColors.dart';
import 'package:cargo/utils/ShConstant.dart';
import 'package:cargo/utils/ShExtension.dart';
import 'package:cargo/utils/ShStrings.dart';
import 'package:cargo/utils/ShWidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailNewScreen extends StatefulWidget {
  static String tag='/OrderDetailNewScreen';


  @override
  _OrderDetailNewScreenState createState() => _OrderDetailNewScreenState();
}

class _OrderDetailNewScreenState extends State<OrderDetailNewScreen> {
  OrderDetailModel order_model;
  OrderUpdateModel order_update;
  var name = '';
  String _fileName;
  List<PlatformFile> _paths;
  String _directoryPath;
  String _extension = 'ttf,jpg,png,doc,pdf';
  bool _loadingPath = false;
  bool _multiPick = true;
  FileType _pickingType = FileType.custom;
  final List<UploadInvoiceModel> uploadModel = [];
  UploadInvoiceModel itModel;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<PlatformFile> _paths_final = [];
  PlatformFile path_model;
  int selectedAddressIndex=0;
  bool _isLoading;
  bool _permissionReady;
  Permission _permission = Permission.storage;
  String _localPath;
  ReceivePort _port = ReceivePort();
  ErrorMainModel err_model;
  List<_ItemHolder> _items= [];

  @override
  void initState() {
    super.initState();

//    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;

    _prepare();
    // getName();
    // fetchOrder();
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

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;

    setState(() {
      for (var i = 0; i < _paths.length; i++) {
        path_model = PlatformFile(
            path: _paths[i].path,
            name: _paths[i].name,
            bytes: _paths[i].bytes,
            size: _paths[i].size);
        _paths_final.add(path_model);
      }
      _loadingPath = false;
      _fileName = _paths_final != null
          ? _paths_final.map((e) => e.name).toString()
          : '...';
    });
  }

  Future<OrderDetailModel> fetchOrder() async {
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
      if(response.statusCode==200) {
        order_model = new OrderDetailModel.fromJson(jsonResponse);

        // selectedAddressIndex = 1;

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

        // setState(() {
          if (order_model.details.deliveryMethod == 'Curb-side') {
            selectedAddressIndex = 0;
          } else {
            selectedAddressIndex = 1;
          }
        // });
      }else{
        err_model = new ErrorMainModel.fromJson(jsonResponse);
        toast(err_model.error);
      }

      return order_model;
    } catch (e) {
      print('caught error $e');
    }
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
      name = prefs.getString('UserName');
    // });
    return name;
  }

  Future<String> getLogout() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');
      String device_id = prefs.getString('device_id');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoAuthToken': token,
        'cargoUserId': UserId
      };
      final msg = jsonEncode({"device_id": device_id});

      Response response = await get(
        'https://cargobgi.net/wp-json/v3/logout?device_id=$device_id',
        headers: headers,
      );
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      prefs.setString('token', '');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreens(),
        ),
      );

      return null;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }


  }

  Future<String> getDeleted(int invo_id) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');
      String order_id = prefs.getString('order_id');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoAuthToken': token,
        'cargoUserId': UserId
      };
      final msg = jsonEncode({"quote_id": order_id, "invoice_id": invo_id});

      Response response = await post(
        'https://cargobgi.net/wp-json/v3/delete_invoice',
        headers: headers,
        body: msg,
      );

      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');
      toast('Deleted');
      setState(() {

      });

      return null;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }

  Future<OrderUpdateModel> getUpdate() async {
//    String jsonTutorial = jsonEncode(uploadModel);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String order_id = prefs.getString('order_id');
    String address;
    String methodd;

    try {
      Dialogs.showLoadingDialog(context, _keyLoader);
      if (selectedAddressIndex == 0) {
        address = "";
        methodd = "Curb-side";
      } else if (selectedAddressIndex == 1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        address = prefs.getString('address');
        methodd = "Doorstep Delivery";
      } else {
        address = order_model.details.deliveryAddress;
        methodd = order_model.details.deliveryMethod;
      }

      Map data = {
        'quote_id': order_id,
        'delivery_address': address,
        'delivery_method': methodd,
        'invoices': uploadModel
      };

      String body = json.encode(data);

      print(body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String UserId = prefs.getString('UserId');
      String token = prefs.getString('token');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'cargoAuthToken': token,
        'cargoUserId': UserId
      };

      Response response = await post(
        'https://cargobgi.net/wp-json/v3/update_delivery',
        headers: headers,
        body: body,
      );

      final jsonResponse = json.decode(response.body);
      print('not json $jsonResponse');

      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      order_update = new OrderUpdateModel.fromJson(jsonResponse);
      if (order_update.success) {
//        String suc_id = quoteSuccessModel.quote_id.toString();
//        prefs.setString("success_id", suc_id);
        toast('Updated');
        Navigator.pop(context);
      } else {
        toast('Something Went Wrong');
      }

      return order_update;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print('caught error $e');
    }
  }

  Future<bool> _openDownloadedFile(Invoices task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void ItemAdd() {
    for (var i = 0; i < _paths_final.length; i++) {
      File fls = File(_paths_final[i].path);
      Uint8List bytes = fls.readAsBytesSync();
      String base64Image = base64Encode(bytes);
      itModel =
          UploadInvoiceModel(name: _paths_final[i].name, file: base64Image);
      uploadModel.add(itModel);
    }
    getUpdate();
    print('object');
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;



    DeleteDialogue(int invo_id) async {
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Are You sure you want to delete?'),
            actions: [
              TextButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                },
              ),
              TextButton(
                child: const Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                  getDeleted(invo_id);
                },
              )
            ],
          );
        },
      );
    }

    DeleteDialogue2(int index) async {
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Are You sure you want to delete?'),
            actions: [
              TextButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                },
              ),
              TextButton(
                child: const Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                  setState(() {
                    _paths_final.removeAt(index);
                  });
                },
              )
            ],
          );
        },
      );
    }

    OpenDelivery() {
      if (selectedAddressIndex == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectDeliveryScreen(
                  cat_title: 0,
                ))).then((value) {
          setState(() {
            selectedAddressIndex = value;
          });
        });
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectDeliveryScreen(
                  cat_title: 1,
                ))).then((value) {
          setState(() {
            selectedAddressIndex = value;
          });
        });
      }
    }

    DeliveryMode(String methods,int selectedAddressIndex) {
      if (selectedAddressIndex == 0) {
        return Text(
          'Delivery Mode : Curb-side',
          style: TextStyle(
              fontSize: 15, color: sh_app_black, fontWeight: FontWeight.bold),
        );
      } else if (selectedAddressIndex == 1) {
        return Text(
          'Delivery Mode : Doorstep Delivery',
          style: TextStyle(
              fontSize: 15, color: sh_app_black, fontWeight: FontWeight.bold),
        );
      } else {
        return Text(
          'Delivery Mode : $methods',
          style: TextStyle(
              fontSize: 15, color: sh_app_black, fontWeight: FontWeight.bold),
        );
      }
    }

    Logout() async {
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Are You sure you want to logout?'),
            actions: [
              TextButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
//                  setState(() {
//                    futureAlbum = fetchAlbum();
//                    cartdetail=fetchCart();
//                  });
                },
              ),
              TextButton(
                child: const Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                  getLogout();
                },
              )
            ],
          );
        },
      );
    }

    ItemList(String name, int index) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            decoration: BoxDecoration(
                border:
                Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    (Expanded(
                        flex: 6,
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: TextStyle(
                              fontSize: 12,
                              color: sh_app_black,
                              fontWeight: FontWeight.bold),
                        ))),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Center(
                            child: IconButton(
                                icon: Icon(Icons.remove_red_eye,size: 20,),
                                onPressed: () async {
                                  if(!(await _permission.isGranted)) await requestPermission();
//                                  toast('Downloading..');
                                  openFile(_paths_final[index].path);

                                })),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Center(
                            child: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  DeleteDialogue2(index);

                                })),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          )
        ],
      );
    }

    InvoiceList() {
      return Builder(
        builder: (BuildContext context) => _loadingPath
            ? Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: const CircularProgressIndicator(),
        )
            : _directoryPath != null
            ? ListTile(
          title: Text('Directory path'),
          subtitle: Text(_directoryPath),
        )
            : _paths_final != null
            ? Container(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Scrollbar(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                _paths_final != null && _paths_final.isNotEmpty
                    ? _paths_final.length
                    : 0,
                itemBuilder: (BuildContext context, int index) {
                  final bool isMultiPath =
                      _paths_final != null && _paths_final.isNotEmpty;
                  final String name = 'File $index: ' +
                      (isMultiPath
                          ? _paths_final
                          .map((e) => e.name)
                          .toList()[index]
                          : _fileName ?? '...');

                  return ItemList(name, index);
                },

              )),
        )
            : const SizedBox(),
      );
    }

    ExistInvoices(int index) {
      int dd = index + 1;
      String fileName =
          order_model.details.invoices[index].invoice.split('/').last;
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            decoration: BoxDecoration(
                border:
                Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
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
                                icon: Icon(Icons.file_download),
                                onPressed: () async {
                                  if(!(await _permission.isGranted)) await requestPermission();
                                  toast('Downloading..');
//                                  _download(index);
                                  _requestDownload(_items[index].task);
                                })),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Center(
                            child: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  DeleteDialogue(order_model.details.invoices[index].invoiceId);
                                })),
                      ),
                    )
                  ],
                ),
                _items[index].task.status == DownloadTaskStatus.running ||
                    _items[index].task.status == DownloadTaskStatus.paused
                    ? Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: LinearProgressIndicator(
                    value: _items[index].task.progress / 100,
                  ),
                )
                    : Container()
              ],
            ),
          ),
          SizedBox(
            height: 8,
          )
        ],
      );
    }

    ListValidation(){
      if(order_model.details.invoices.length == 0 && _paths_final.length ==0 ){
        return Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'No invoice uploaded',
            style: TextStyle(
                fontSize: 16,
                color: sh_app_black,
                fontWeight: FontWeight.bold),
          ),
        );
      }else{
        return Container();
      }
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

    listView(int selectedAddressIndex) {
      String sts = order_model.details.status;
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 4,
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
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Est. Arrival: ',
                            style: TextStyle(
                                fontSize: 15,
                                color: sh_app_black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            order_model.details.estimatedDate,
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
                      child: DeliveryMode(order_model.details.deliveryMethod,selectedAddressIndex),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 1,
                      color: sh_dots_color,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex: 3,
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.pin_drop,
                                    color: sh_dots_color,
                                    size: 15,
                                  ),
                                  Text(
                                    ' Tracking',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: sh_app_background,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          width: 3,
                        ),
                        Expanded(
                            flex: 5,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  _openFileExplorer();
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.file_upload,
                                        color: sh_dots_color,
                                        size: 15,
                                      ),
                                      Text(
                                        ' Upload Invoice',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: sh_app_background,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 3,
                        ),
                        Expanded(
                            flex: 3,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
//                                  launchScreen(context, SelectDeliveryScreen.tag);

                                  OpenDelivery();
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Icon(
                                        Icons.description,
                                        color: sh_dots_color,
                                        size: 15,
                                      ),
                                      Text(
                                        ' Delivery',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: sh_app_background,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 1,
                      color: sh_dots_color,
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
                          return ExistInvoices(index);
                        }),
                    InvoiceList(),
                    ListValidation(),
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

          ],
        ),
      );
    }

    saveButton() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20.0,8,20,8),
        child: MaterialButton(
          height: 50,
          minWidth: double.infinity,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          onPressed: () {
            ItemAdd();
//            _paths.length;
//            params["attachment"] = jsonEncode(attch);
//            getUpdate();

//            File fls = File(_paths[0].path);
//            Uint8List bytes = fls.readAsBytesSync();
//            String base64Image = base64Encode(bytes);
            print('object');
          },
          color: sh_app_background,
          child: text(sh_lbl_update,
              fontFamily: fontMedium,
              fontSize: textSizeLargeMedium,
              textColor: sh_white),
        ),
      );
    }

    return FutureBuilder<String>(
      future: getName(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: sh_app_background,
              elevation: 0,
              iconTheme: IconThemeData(color: sh_white),
              actions: <Widget>[
                IconButton(
                  icon: new Image.asset(
                    cargo_logout,
                    color: Colors.white,
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () {
                    Logout();
                  },
                )
              ],
              title: Text(
                name,
                style: TextStyle(color: sh_white),
              ),
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24)),
                      shape: BoxShape.rectangle,
                      color: sh_app_background),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 12),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        FutureBuilder<OrderDetailModel>(
                          future: fetchOrder(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return listView(selectedAddressIndex);
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            // By default, show a loading spinner.
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                        SizedBox(
                          width: 22,
                        ),

                        saveButton(),
                        SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
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

    // setState(() {
    //   _isLoading = false;
    // });
  }

}
class _ItemHolder {
  final Invoices task;

  _ItemHolder({this.task});
}

