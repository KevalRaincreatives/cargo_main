class TermsModel {
  bool success;
  String content;

  TermsModel({this.success, this.content});

  TermsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['content'] = this.content;
    return data;
  }
}