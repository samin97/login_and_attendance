import 'dart:convert';

monthlyReportModel monthlyReportFromJson(String str) =>
    monthlyReportModel.fromJson(json.decode(str));

String monthlyReportToJson(monthlyReportModel data) => json.encode(data.toJson());

class monthlyReportModel {
  monthlyReportModel({
     this.name,
     this.checkInTime,
     this.checkOutTime,
     this.workingHour,
     this.remarks,
     this.date,
  });

  String? name;
  String? checkInTime;
  String? checkOutTime;
  String? workingHour;
  String? remarks;
  String? date;

  factory monthlyReportModel.fromJson(Map<String, dynamic> json) => monthlyReportModel(
        name: json["name"],
        checkInTime: json["checkInTime"],
        checkOutTime: json["checkOutTime"],
        workingHour: json["workingHour"],
        remarks: json["remarks"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "checkInTime": checkInTime,
        "checkOutTime": checkOutTime,
        "workingHour": workingHour,
        "remarks": remarks,
        "date": date,
      };
}
