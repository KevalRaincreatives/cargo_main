class PackageTypeModel {
  bool success;
  List<PackageResponse> response;

  PackageTypeModel({this.success, this.response});

  PackageTypeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response = new List<PackageResponse>();
      json['response'].forEach((v) {
        response.add(new PackageResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PackageResponse {
  String termTaxonomyId;
  String name;
  String width;
  String height;
  String length;

  PackageResponse(
      {
        this.name,
        this.termTaxonomyId,

        this.width,
        this.height,
        this.length});

  PackageResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    termTaxonomyId = json['term_taxonomy_id'];
    width = json['width'];
    height = json['height'];
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['term_taxonomy_id'] = this.termTaxonomyId;
    data['width'] = this.width;
    data['height'] = this.height;
    data['length'] = this.length;
    return data;
  }
}