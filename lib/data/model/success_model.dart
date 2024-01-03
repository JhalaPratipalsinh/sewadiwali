import 'dart:convert';

SuccessModel successModelFromJson(String str) =>
    SuccessModel.fromJson(json.decode(str));

String successModelToJson(SuccessModel data) => json.encode(data.toJson());

class SuccessModel {
  int status;
  String message;

  SuccessModel({
    required this.status,
    required this.message,
  });

  factory SuccessModel.fromJson(Map<String, dynamic> json) => SuccessModel(
        status: json["STATUS"] ?? 0,
        message: json["MESSAGE"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "STATUS": status,
        "MESSAGE": message,
      };
}
