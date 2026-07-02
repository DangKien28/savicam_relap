class DevicePair {
  final String id;
  final String tmodMacAddress;
  final String relapUserId;
  final String pairingCode;
  final String status;
  final DateTime createdAt;

  DevicePair({
    required this.id,
    required this.tmodMacAddress,
    required this.relapUserId,
    required this.pairingCode,
    required this.status,
    required this.createdAt,
  });

  factory DevicePair.fromJson(Map<String, dynamic> json) {
    return DevicePair(
      id: json['id'] as String,
      tmodMacAddress: json['tmod_mac_address'] as String,
      relapUserId: json['relap_user_id'] as String,
      pairingCode: json['pairing_code'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tmod_mac_address': tmodMacAddress,
      'relap_user_id': relapUserId,
      'pairing_code': pairingCode,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
