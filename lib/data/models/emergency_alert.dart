class EmergencyAlert {
  const EmergencyAlert({
    required this.id,
    required this.status,
    this.message,
    this.pairedDeviceId,
  });

  final String id;
  final String status;
  final String? message;
  final String? pairedDeviceId;

  factory EmergencyAlert.fromJson(Map<String, dynamic> json) {
    return EmergencyAlert(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'active',
      message: json['message']?.toString(),
      pairedDeviceId: json['paired_device_id']?.toString(),
    );
  }
}