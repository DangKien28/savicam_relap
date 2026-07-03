class DevicePair {
  const DevicePair({
    required this.id,
    required this.pairingCode,
    required this.status,
    this.relapUserId,
  });

  final String id;
  final String pairingCode;
  final String status;
  final String? relapUserId;

  factory DevicePair.fromJson(Map<String, dynamic> json) {
    return DevicePair(
      id: json['id']?.toString() ?? '',
      pairingCode: json['pairing_code']?.toString() ?? '',
      status: json['status']?.toString() ?? 'available',
      relapUserId: json['relap_user_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pairing_code': pairingCode,
      'status': status,
      'relap_user_id': relapUserId,
    };
  }
}