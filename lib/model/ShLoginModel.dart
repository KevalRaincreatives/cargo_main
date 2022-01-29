class ShLoginModel {
  String token;
  String userEmail;
  String userNicename;
  String userDisplayName;
  int userId;

  ShLoginModel(
      {this.token, this.userEmail, this.userNicename, this.userDisplayName,this.userId});

  ShLoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userEmail = json['user_email'];
    userNicename = json['user_nicename'];
    userDisplayName = json['user_display_name'];
    userId=json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['user_email'] = this.userEmail;
    data['user_nicename'] = this.userNicename;
    data['user_display_name'] = this.userDisplayName;
    data['userId']= this.userId;
    return data;
  }
}