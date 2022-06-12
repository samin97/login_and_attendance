class Log{
  String? nepaliDate;
  String? englishDate;
  String? attendDateTime;
  String? latitude;
  String? longitude;
  String? deviceId;
  String? networkId;
  String? attitude;
  Log({
    required this.attendDateTime,
    required this.nepaliDate,
    required this.englishDate,
    required this.latitude,
    required this.longitude,
    required this.deviceId,
    required this.networkId,
    required this.attitude,
});

  Map<String, dynamic> toMap(Log log){
    Map<String, dynamic> logMap = Map();
    logMap["attendDateTime"]= log.attendDateTime;
    logMap["nepaliDate"]= log.nepaliDate;
    logMap["englishDate"]= log.englishDate;
    logMap["latitude"]= log.latitude;
    logMap["longitude"]= log.longitude;
    logMap["deviceId"]= log.deviceId;
    logMap["networkId"]= log.networkId;
    logMap["attitude"]= log.attitude;
    return logMap;
  }
  Log.fromMap(Map logMap){
    this.attendDateTime = logMap["attendDateTime"];
    this.nepaliDate = logMap["nepaliDate"];
    this.englishDate = logMap["englishDate"];
    this.latitude = logMap["latitude"];
    this.longitude = logMap["longitude"];
    this.deviceId = logMap["deviceId"];
    this.networkId = logMap["networkId"];
    this.attitude = logMap["attitude"];
  }
}