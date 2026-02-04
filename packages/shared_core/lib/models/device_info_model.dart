class DeviceInfoModel {
  final String deviceId;
  final String deviceName;

  DeviceInfoModel({
    required this.deviceId,
    required this.deviceName
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
    };
  }
}