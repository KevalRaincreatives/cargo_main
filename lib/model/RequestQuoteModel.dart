import 'dart:ffi';

class RequestQuoteModel {
  final List<ItemsModel> items;

  RequestQuoteModel({this.items});

  factory RequestQuoteModel.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    print(list.runtimeType);
    List<ItemsModel> imagesList =
        list.map((i) => ItemsModel.fromJson(i)).toList();

    return RequestQuoteModel(items: imagesList);
  }
}

class ItemsModel {
  String package_type;
  String package_id;
  dynamic package_value;
  String width;
  String height;
  String length;
  String weight;
  String item_type;
  String item_id;
  dynamic item_value;
  String price;

  ItemsModel(
      {this.package_type,
      this.package_id,
      this.package_value,
      this.width,
      this.height,
      this.length,
      this.weight,
      this.item_type,
      this.item_id,
      this.item_value,
      this.price});

  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
        package_type: json['package_type'],
        package_id: json['package_id'],
        package_value: json['package_value'],
        width: json['width'],
        height: json['height'],
        length: json['length'],
        weight: json['weight'],
        item_type: json['item_type'],
        item_id: json['item_id'],
        item_value: json['item_value'],
        price: json['price']);
  }

  Map<String, dynamic> toJson() {
    return {
      'package_type': package_type,
      'package_id': package_id,
      'package_value': package_value,
      'width': width,
      'height': height,
      'length': length,
      'weight': weight,
      'item_type': item_type,
      'item_id': item_id,
      'item_value': item_value,
      'price': price,
    };
  }
}

//extension ListUpdate<T> on List {
//  List update(int pos, T t) {
//    List<T> list = new List();
//    list.add(t);
//    replaceRange(pos, pos + 1, list);
//    return this;
//  }
//}
