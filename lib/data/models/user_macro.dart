class UserMacro {
  const UserMacro({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.notes,
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? notes;

  factory UserMacro.fromJson(Map<String, dynamic> json) {
    return UserMacro(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      notes: json['notes']?.toString(),
    );
  }
}