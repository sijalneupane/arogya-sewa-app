import 'package:shared_core/domain/entities/device_info_entity.dart';

class DeviceInfoModel extends DeviceInfoEntity {
  DeviceInfoModel({
    required super.deviceId,
    required super.deviceName,
  });

  factory DeviceInfoModel.fromEntity(DeviceInfoEntity entity) {
    return DeviceInfoModel(
      deviceId: entity.deviceId,
      deviceName: entity.deviceName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
    };
  }
}