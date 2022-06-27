class Log{
  String? id;
  String? nepaliDate;
  String? englishDate;
  String? attendDateTime;
  String? latitude;
  String? longitude;
  String? deviceId;
  String? networkId;
  String? altitude;
  String? status;
  Log({
    required this.id,
    required this.attendDateTime,
    required this.nepaliDate,
    required this.englishDate,
    required this.latitude,
    required this.longitude,
    required this.deviceId,
    required this.networkId,
    required this.altitude,
    required this.status
});


  Map<String, dynamic> toMap(Log log){
    Map<String, dynamic> logMap = Map();
    logMap["id"]= log.id;
    logMap["attendDateTime"]= log.attendDateTime;
    logMap["nepaliDate"]= log.nepaliDate;
    logMap["englishDate"]= log.englishDate;
    logMap["latitude"]= log.latitude;
    logMap["longitude"]= log.longitude;
    logMap["deviceId"]= log.deviceId;
    logMap["networkId"]= log.networkId;
    logMap["altitude"]= log.altitude;
    logMap["status"]= log.status;
    return logMap;
  }
  Log.fromMap(Map logMap){
    this.id = logMap["id"];
    this.attendDateTime = logMap["attendDateTime"];
    this.nepaliDate = logMap["nepaliDate"];
    this.englishDate = logMap["englishDate"];
    this.latitude = logMap["latitude"];
    this.longitude = logMap["longitude"];
    this.deviceId = logMap["deviceId"];
    this.networkId = logMap["networkId"];
    this.altitude = logMap["altitude"];
    this.status = logMap["status"];
  }
}