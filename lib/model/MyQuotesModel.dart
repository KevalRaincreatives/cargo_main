class MyQuotesModel {
  bool success;
  List<QuoteResponse> response;

  MyQuotesModel({this.success, this.response});

  MyQuotesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response = new List<QuoteResponse>();
      json['response'].forEach((v) {
        response.add(new QuoteResponse.fromJson(v));
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

class QuoteResponse {
  String quoteId;
  String quoteDate;
  String quoteStatus;

  QuoteResponse(
      {this.quoteId, this.quoteDate, this.quoteStatus});

  QuoteResponse.fromJson(Map<String, dynamic> json) {
    quoteId = json['quote_id'];
    quoteDate = json['quote_date'];
    quoteStatus = json['quote_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quote_id'] = this.quoteId;
    data['quote_date'] = this.quoteDate;
    data['quote_status'] = this.quoteStatus;
    return data;
  }
}