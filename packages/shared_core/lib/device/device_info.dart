import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_core/models/device_info_model.dart';


abstract class DeviceInfo{
Future<DeviceInfoModel> getDeviceInfo();
}
class DeviceInfoImpl implements DeviceInfo {
  final DeviceInfoPlugin deviceInfo;

  DeviceInfoImpl(this.deviceInfo);

  @override
  Future<DeviceInfoModel> getDeviceInfo() async {
    final deviceInfoData = await deviceInfo.deviceInfo;
    String deviceId = '';
    String deviceName = '';

    if (deviceInfoData is AndroidDeviceInfo) {
      deviceId = deviceInfoData.device;
      deviceName = deviceInfoData.model;
    } else if (deviceInfoData is IosDeviceInfo) {
      deviceId = deviceInfoData.identifierForVendor??'unknown';
      deviceName = deviceInfoData.name;
    } // Add other platforms as needed
      else {
        deviceId = 'unknown';
        deviceName = Platform.operatingSystem;
      }

    return DeviceInfoModel(
      deviceId: deviceId,
      deviceName: deviceName,
    );
  }
}