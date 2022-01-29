class MetaDataModel {
  String key;
  String value;


  MetaDataModel(
      {this.key,
        this.value});

  factory MetaDataModel.fromJson(Map<String, dynamic> json) {
    return MetaDataModel(
        key: json['key'],
        value: json['value']);
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value
    };
  }
}