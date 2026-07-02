class UserMacro {
  final String id;
  final String pairedDeviceId;
  final String keyword;
  final String actionType;
  final Map<String, dynamic> dataValue;
  final DateTime updatedAt;
  final DateTime createdAt;

  UserMacro({
    required this.id,
    required this.pairedDeviceId,
    required this.keyword,
    required this.actionType,
    required this.dataValue,
    required this.updatedAt,
    required this.createdAt,
  });

  factory UserMacro.fromJson(Map<String, dynamic> json) {
    return UserMacro(
      id: json['id'] as String,
      pairedDeviceId: json['paired_device_id'] as String,
      keyword: json['keyword'] as String,
      actionType: json['action_type'] as String,
      dataValue: json['data_value'] as Map<String, dynamic>? ?? {},
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paired_device_id': pairedDeviceId,
      'keyword': keyword,
      'action_type': actionType,
      'data_value': dataValue,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
