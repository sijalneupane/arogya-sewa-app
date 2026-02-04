import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String accessTokenKey = "access_token";
const String refreshTokenKey = "refresh_token";
const String attendanceIdKey = "attendanceId";
// const String biometricsKey = "biometric_enabled";
const String biometricsTokenKey = "biometrics_token";
// const String fingerprintHashKey = "fingerprint_hash";
const String themeModeKey = "theme_mode";

class SecurePref {
  final FlutterSecureStorage storage;

  SecurePref({required this.storage});

  /// Save String, bool, or int values
  Future<void> saveData(String key, dynamic value) async {
    if (value is String) {
      await storage.write(key: key, value: value);
    } else if (value is bool) {
      await storage.write(key: key, value: value.toString());
    } else if (value is int) {
      await storage.write(key: key, value: value.toString());
    } else {
      throw UnsupportedError("Type not supported");
    }
  }

  /// Read String
  Future<String> readString(String key) async {
    return await storage.read(key: key) ?? "";
  }

  /// Read Bool
  Future<bool> readBool(String key) async {
    final val = await storage.read(key: key);
    return val?.toLowerCase() == "true";
  }

  /// Read Int
  Future<int> readInt(String key) async {
    final val = await storage.read(key: key);
    return val == null ? 0 : int.tryParse(val) ?? 0;
  }

  /// Remove a single key
  Future<void> remove(String key) async {
    await storage.delete(key: key);
  }

  /// Clear everything except given keys
  Future<void> clearData() async {
    final all = await storage.readAll();
    final keysToKeep = [biometricsTokenKey];
      for (final entry in all.keys) {
        if (!keysToKeep.contains(entry)) {
          await storage.delete(key: entry);
        }
      }
  }

}

