class DeviceTelemetry {
  final String tmodDeviceId;
  final String pairedDeviceId;
  final int batteryLevel; // int2
  final String networkStatus;
  final bool isHeadlessMode;
  final double currentLat; // float8
  final double currentLng; // float8
  final DateTime lastPingAt;

  DeviceTelemetry({
    required this.tmodDeviceId,
    required this.pairedDeviceId,
    required this.batteryLevel,
    required this.networkStatus,
    required this.isHeadlessMode,
    required this.currentLat,
    required this.currentLng,
    required this.lastPingAt,
  });

  factory DeviceTelemetry.fromJson(Map<String, dynamic> json) {
    return DeviceTelemetry(
      tmodDeviceId: json['tmod_device_id'] as String,
      pairedDeviceId: json['paired_device_id'] as String,
      batteryLevel: (json['battery_level'] as num).toInt(),
      networkStatus: json['network_status'] as String,
      isHeadlessMode: json['is_headless_mode'] as bool? ?? false,
      currentLat: (json['current_lat'] as num).toDouble(),
      currentLng: (json['current_lng'] as num).toDouble(),
      lastPingAt: DateTime.parse(json['last_ping_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tmod_device_id': tmodDeviceId,
      'paired_device_id': pairedDeviceId,
      'battery_level': batteryLevel,
      'network_status': networkStatus,
      'is_headless_mode': isHeadlessMode,
      'current_lat': currentLat,
      'current_lng': currentLng,
      'last_ping_at': lastPingAt.toIso8601String(),
    };
  }
}
