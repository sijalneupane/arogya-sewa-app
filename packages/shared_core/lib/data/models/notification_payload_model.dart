import 'dart:convert';
import 'package:shared_core/domain/entities/notification_payload_entity.dart';

class NotificationPayloadModel extends NotificationPayloadEntity {
  const NotificationPayloadModel({
    super.routeName,
    super.routeParams,
    super.title,
    super.body,
    super.type,
    super.rawPayload,
  });

  factory NotificationPayloadModel.fromMap(Map<String, dynamic> rawData) {
    final payloadData = _extractPayloadData(rawData);
    
    String? routeName = _extractString(payloadData, 'routeName') ??
                        _extractString(payloadData, 'screen') ??
                        _extractString(payloadData, 'path');
    
    Map<String, String>? routeParams = _extractRouteParams(payloadData);

    return NotificationPayloadModel(
      routeName: routeName,
      routeParams: routeParams,
      title: _extractString(payloadData, 'title') ?? _extractString(rawData, 'title'),
      body: _extractString(payloadData, 'body') ?? _extractString(rawData, 'body'),
      type: _extractString(payloadData, 'type') ?? _extractString(payloadData, 'category'),
      rawPayload: rawData,
    );
  }

  static Map<String, dynamic> _extractPayloadData(Map<String, dynamic> rawData) {
    // Case 1: Direct payload
    if (rawData.containsKey('routeName') || rawData.containsKey('type')) {
      return rawData;
    }

    // Case 2: Stringified JSON in "data" field
    if (rawData.containsKey('data') && rawData['data'] is String) {
      try {
        return Map<String, dynamic>.from(jsonDecode(rawData['data'] as String));
      } catch (_) {}
    }

    // Case 3: Firebase Console format (data inside "data" map)
    if (rawData.containsKey('data') && rawData['data'] is Map<String, dynamic>) {
      return rawData['data'] as Map<String, dynamic>;
    }

    return rawData;
  }

  static String? _extractString(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is String) return value.trim().isEmpty ? null : value;
    if (value is num || value is bool) return value.toString();
    return null;
  }

  static Map<String, String>? _extractRouteParams(Map<String, dynamic> data) {
    final params = data['routeParams'] ?? data['params'] ?? data['queryParameters'];
    
    if (params is Map) {
      return params.map((key, value) => MapEntry(key.toString(), value.toString()));
    }
    
    if (params is String) {
      try {
        final parsed = jsonDecode(params) as Map;
        return parsed.map((key, value) => MapEntry(key.toString(), value.toString()));
      } catch (_) {}
    }
    
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      if (routeName != null) 'routeName': routeName,
      if (routeParams != null) 'routeParams': routeParams,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (type != null) 'type': type,
    }..removeWhere((key, value) => value == null);
  }
}