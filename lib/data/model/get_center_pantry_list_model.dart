import 'dart:convert';

GetCenterPantryListModel getCenterPantryListModelFromJson(String str) =>
    GetCenterPantryListModel.fromJson(json.decode(str));

String getCenterPantryListModelToJson(GetCenterPantryListModel data) =>
    json.encode(data.toJson());

class GetCenterPantryListModel {
  int status;
  String message;
  List<CenterList>? centers;
  List<PantryList>? pantries;

  GetCenterPantryListModel({
    required this.status,
    required this.message,
    required this.centers,
    required this.pantries,
  });

  factory GetCenterPantryListModel.fromJson(Map<String, dynamic> json) =>
      GetCenterPantryListModel(
        status: json["STATUS"] ?? 0,
        message: json["MESSAGE"] ?? "",
        centers: json["CENTERS"] == null
            ? null
            : List<CenterList>.from(json["CENTERS"].map((x) => CenterList.fromJson(x))),
        pantries: json["PANTRIES"] == null
            ? null
            : List<PantryList>.from(
                json["PANTRIES"].map((x) => PantryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "STATUS": status,
        "MESSAGE": message,
        "CENTERS": List<dynamic>.from(centers?.map((x) => x.toJson()) ?? []),
        "PANTRIES": List<dynamic>.from(pantries?.map((x) => x.toJson()) ?? []),
      };
}

class CenterList {
  String centerId;
  String orgId;
  String regYearId;
  String stateId;
  String orgName;
  String township;
  String address;
  String time;
  String dates;
  String coName;
  String coEmail;
  String coContact;
  String password;
  String noOfDays;
  String donateFoodDesc;
  String latitude;
  String longitude;
  String status;
  DateTime createdAt;
  String cyId;
  String yearId;

  CenterList({
    required this.centerId,
    required this.orgId,
    required this.regYearId,
    required this.stateId,
    required this.orgName,
    required this.township,
    required this.address,
    required this.time,
    required this.dates,
    required this.coName,
    required this.coEmail,
    required this.coContact,
    required this.password,
    required this.noOfDays,
    required this.donateFoodDesc,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    required this.cyId,
    required this.yearId,
  });

  factory CenterList.fromJson(Map<String, dynamic> json) => CenterList(
        centerId: json["center_id"] ?? "",
        orgId: json["org_id"] ?? "",
        regYearId: json["reg_year_id"] ?? "",
        stateId: json["state_id"] ?? "",
        orgName: json["org_name"] ?? "",
        township: json["township"] ?? "",
        address: json["address"] ?? "",
        time: json["time"] ?? "",
        dates: json["dates"] ?? "",
        coName: json["co_name"] ?? "",
        coEmail: json["co_email"] ?? "",
        coContact: json["co_contact"] ?? "",
        password: json["password"] ?? "",
        noOfDays: json["no_of_days"] ?? "",
        donateFoodDesc: json["donate_food_desc"] ?? "",
        latitude: json["latitude"] ?? "",
        longitude: json["longitude"] ?? "",
        status: json["status"] ?? "",
        createdAt: DateTime.parse(json["created_at"]) ?? DateTime.now(),
        cyId: json["cy_id"] ?? "",
        yearId: json["year_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "center_id": centerId,
        "org_id": orgId,
        "reg_year_id": regYearId,
        "state_id": stateId,
        "org_name": orgName,
        "township": township,
        "address": address,
        "time": time,
        "dates": dates,
        "co_name": coName,
        "co_email": coEmail,
        "co_contact": coContact,
        "password": password,
        "no_of_days": noOfDays,
        "donate_food_desc": donateFoodDesc,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "cy_id": cyId,
        "year_id": yearId,
      };
}

class PantryList {
  String pantryId;
  String stateId;
  String pantryName;
  String township;
  String address;
  String email;
  String contact;
  String latitude;
  String longitude;
  String status;
  DateTime createdAt;

  PantryList({
    required this.pantryId,
    required this.stateId,
    required this.pantryName,
    required this.township,
    required this.address,
    required this.email,
    required this.contact,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
  });

  factory PantryList.fromJson(Map<String, dynamic> json) => PantryList(
        pantryId: json["pantry_id"] ?? "",
        stateId: json["state_id"] ?? "",
        pantryName: json["pantry_name"] ?? "",
        township: json["township"] ?? "",
        address: json["address"] ?? "",
        email: json["email"] ?? "",
        contact: json["contact"] ?? "",
        latitude: json["latitude"] ?? "",
        longitude: json["longitude"] ?? "",
        status: json["status"] ?? "",
        createdAt: DateTime.parse(json["created_at"]) ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "pantry_id": pantryId,
        "state_id": stateId,
        "pantry_name": pantryName,
        "township": township,
        "address": address,
        "email": email,
        "contact": contact,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "created_at": createdAt.toIso8601String(),
      };
}
