class LoginModel {
  int status;
  String message;
  LoginData? userDetails;

  LoginModel({
    required this.status,
    required this.message,
    required this.userDetails,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["STATUS"] ?? 0,
        message: json["MESSAGE"] ?? "",
        userDetails:
            json["USER"] == null ? null : LoginData.fromJson(json["USER"]),
      );

  Map<String, dynamic> toJson() => {
        "STATUS": status,
        "MESSAGE": message,
        "USER": userDetails?.toJson(),
      };
}

class LoginData {
  String id;
  String stateId;
  String firstName;
  String lastName;
  String name;
  String password;
  String type;
  String status;
  // DateTime createAt;
  String token;
  String useType;
  String centerId;

  LoginData({
    required this.id,
    required this.stateId,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.password,
    required this.type,
    required this.status,
    // required this.createAt,
    required this.token,
    required this.useType,
    required this.centerId,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        id: json["id"] ?? "",
        stateId: json["state_id"] ?? "",
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        name: json["name"] ?? "",
        password: json["password"] ?? "",
        type: json["type"] ?? "",
        status: json["status"] ?? "",
        // createAt: DateTime.parse(json["create_at"]) ?? DateTime.now(),
        token: json["token"] ?? "",
        useType: json["usertype"] ?? "",
        centerId: json["center_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state_id": stateId,
        "first_name": firstName,
        "last_name": lastName,
        "name": name,
        "password": password,
        "type": type,
        "status": status,
        // "create_at": createAt.toIso8601String(),
        "token": token,
        "usertype": useType,
        "center_id": centerId,
      };
}
