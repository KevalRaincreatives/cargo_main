class ProfileUpdateModel {
  final String status;
  final ProfileUpdateHModel data;

  ProfileUpdateModel({this.status,this.data});

  factory ProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateModel(status: json['status'],data: ProfileUpdateHModel.fromJson(json['data']));
  }
}

class ProfileUpdateHModel {
  String message;


  ProfileUpdateHModel(
      {this.message});

  factory ProfileUpdateHModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateHModel(
        message: json['message']);
  }
}
