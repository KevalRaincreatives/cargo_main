class UploadInvoiceModel {
  String name;
  String file;


  UploadInvoiceModel(
      {this.name,
        this.file});

  factory UploadInvoiceModel.fromJson(Map<String, dynamic> json) {
    return UploadInvoiceModel(
      name: json['name'],
        file: json['file'],
  );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'file': file,
    };
  }
}