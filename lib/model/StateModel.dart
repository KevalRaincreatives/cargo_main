class StateHModel {
  String code;
  String name;
  List<States> states;

  StateHModel({this.code, this.name, this.states});

  StateHModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    if (json['states'] != null) {
      states = new List<States>();
      json['states'].forEach((v) {
        states.add(new States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    if (this.states != null) {
      data['states'] = this.states.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class States {
  dynamic code;
  String name;

  States({this.code, this.name});

  int get hashCode => code.hashCode;

  bool operator==(Object other) => other is States && other.code == code;

  States.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

