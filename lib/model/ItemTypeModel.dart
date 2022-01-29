class ItemTypeModel{
  bool success;
  List<ItemResponse> response;
  ItemTypeModel({this.success, this.response});

  ItemTypeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response = new List<ItemResponse>();
      json['response'].forEach((v) {
        response.add(new ItemResponse.fromJson(v));
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

class ItemResponse {
  String name;
  String termTaxonomyId;

  ItemResponse(
      {
        this.name,

        this.termTaxonomyId});

  ItemResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    termTaxonomyId = json['term_taxonomy_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['term_taxonomy_id'] = this.termTaxonomyId;
    return data;
  }
}