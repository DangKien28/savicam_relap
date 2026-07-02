class EmergencyAlert {
  final String id;
  final String pairedDeviceId;
  final String status;
  final double latitude; // float8
  final double longitude; // float8
  final String message;
  final DateTime createdAt;

  EmergencyAlert({
    required this.id,
    required this.pairedDeviceId,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.message,
    required this.createdAt,
  });

  factory EmergencyAlert.fromJson(Map<String, dynamic> json) {
    return EmergencyAlert(
      id: json['id'] as String,
      pairedDeviceId: json['paired_device_id'] as String,
      status: json['status'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paired_device_id': pairedDeviceId,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
