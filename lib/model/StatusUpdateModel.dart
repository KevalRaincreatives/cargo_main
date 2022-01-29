class StatusUpdateModel {
  bool success;
  Signature signature;

  StatusUpdateModel({this.success, this.signature});

  StatusUpdateModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    signature = json['signature'] != null
        ? new Signature.fromJson(json['signature'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.signature != null) {
      data['signature'] = this.signature.toJson();
    }
    return data;
  }
}

class Signature {
  String file;
  String url;
  String type;

  Signature({this.file, this.url, this.type});

  Signature.fromJson(Map<String, dynamic> json) {
    file = json['file'];
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file'] = this.file;
    data['url'] = this.url;
    data['type'] = this.type;
    return data;
  }
}