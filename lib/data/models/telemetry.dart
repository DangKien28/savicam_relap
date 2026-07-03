class Telemetry {
  const Telemetry({
    required this.id,
    required this.pairedDeviceId,
    this.batteryPercent,
    this.networkType,
    this.gpsStatus,
    this.createdAt,
  });

  final String id;
  final String pairedDeviceId;
  final int? batteryPercent;
  final String? networkType;
  final String? gpsStatus;
  final DateTime? createdAt;

  factory Telemetry.fromJson(Map<String, dynamic> json) {
    return Telemetry(
      id: json['id']?.toString() ?? '',
      pairedDeviceId: json['paired_device_id']?.toString() ?? '',
      batteryPercent: json['battery_percent'] is int ? json['battery_percent'] as int : int.tryParse('${json['battery_percent'] ?? ''}'),
      networkType: json['network_type']?.toString(),
      gpsStatus: json['gps_status']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}