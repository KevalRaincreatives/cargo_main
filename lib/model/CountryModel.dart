import 'dart:ffi';



class CountryModel {
  final String code;
  final String name;
  final List<StateModel> states;

  CountryModel({this.code,this.name, this.states});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    var list = json['states'] as List;
    print(list.runtimeType);
    List<StateModel> imagesList =
          list.map((i) => StateModel.fromJson(i)).toList();

    return CountryModel(code: json['code'],name: json['name'], states: imagesList);
  }
}

class StateModel {
  dynamic code;
  String name;

  StateModel(
      {this.code,
      this.name});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
        code: json['code'],
        name: json['name']);
  }
}
