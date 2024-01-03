import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  int status;
  String message;
  String totalCollectedFood;
  String collectedFoodThisYear;
  String totalVolunteers;
  String totalOrganizations;
  String totalCenters;
  List<Statelist>? statelist;
  List<Yearlist>? yearlist;

  HomeModel({
    required this.status,
    required this.message,
    required this.totalCollectedFood,
    required this.collectedFoodThisYear,
    required this.totalVolunteers,
    required this.totalOrganizations,
    required this.totalCenters,
    required this.statelist,
    required this.yearlist,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        status: json["STATUS"] ?? 0,
        message: json["MESSAGE"] ?? "",
        totalCollectedFood: json["total_collected_food"] ?? "0",
        collectedFoodThisYear: json["collected_food_this_year"] ?? "0",
        totalVolunteers: json["total_volunteers"] ?? "0",
        totalOrganizations: json["total_organizations"] ?? "0",
        totalCenters: json["total_centers"] ?? "0",
        statelist: json["state_list"] == null
            ? null
            : List<Statelist>.from(
                json["state_list"].map((x) => Statelist.fromJson(x))),
        yearlist: json["YEARLIST"] == null
            ? null
            : List<Yearlist>.from(
                json["YEARLIST"].map((x) => Yearlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "STATUS": status,
        "MESSAGE": message,
        "total_collected_food": totalCollectedFood,
        "collected_food_this_year": collectedFoodThisYear,
        "total_volunteers": totalVolunteers,
        "total_organizations": totalOrganizations,
        "total_centers": totalCenters,
        "state_list":
            List<dynamic>.from(statelist?.map((x) => x.toJson()) ?? []),
        "YEARLIST": List<dynamic>.from(yearlist?.map((x) => x.toJson()) ?? []),
      };
}

class Statelist {
  String id;
  String stateName;
  String lat;
  String lng;
  String seoStateUrl;
  String seoStateTitle;
  String isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Statelist({
    required this.id,
    required this.stateName,
    required this.lat,
    required this.lng,
    required this.seoStateUrl,
    required this.seoStateTitle,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Statelist.fromJson(Map<String, dynamic> json) => Statelist(
        id: json["id"] ?? "",
        stateName: json["state_name"] ?? "",
        lat: json["lat"] ?? "",
        lng: json["lng"] ?? "",
        seoStateUrl: json["seo_state_url"] ?? "",
        seoStateTitle: json["seo_state_title"] ?? "",
        isActive: json["is_active"] ?? "",
        createdAt: DateTime.parse(json["created_at"]) ?? DateTime.now(),
        updatedAt: DateTime.parse(json["updated_at"]) ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state_name": stateName,
        "lat": lat,
        "lng": lng,
        "seo_state_url": seoStateUrl,
        "seo_state_title": seoStateTitle,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Yearlist {
  String id;
  String regYear;

  Yearlist({
    required this.id,
    required this.regYear,
  });

  factory Yearlist.fromJson(Map<String, dynamic> json) => Yearlist(
        id: json["id"] ?? "",
        regYear: json["reg_year"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reg_year": regYear,
      };
}
