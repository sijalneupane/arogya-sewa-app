/// Pure domain entity - NO external dependencies
class NotificationPayloadEntity {
  final String? routeName;
  final Map<String, String>? routeParams; // GoRouter requires String values
  final String? title;
  final String? body;
  final String? type;
  final Map<String, dynamic>? rawPayload;

  const NotificationPayloadEntity({
    this.routeName,
    this.routeParams,
    this.title,
    this.body,
    this.type,
    this.rawPayload,
  });

  factory NotificationPayloadEntity.empty() => const NotificationPayloadEntity();

  bool get isNavigable => routeName != null && routeName!.isNotEmpty;

  @override
  String toString() => 'NotificationPayloadEntity(routeName: $routeName, type: $type)';
}