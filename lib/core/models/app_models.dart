enum AlertStatus { active, resolved }

enum NetworkStatus { online, weak, offline }

enum MacroSyncStatus { synced, pending }

class DeviceTelemetry {
  const DeviceTelemetry({
    required this.pairedDeviceId,
    required this.batteryLevel,
    required this.networkStatus,
    required this.isHeadlessMode,
    required this.currentLat,
    required this.currentLng,
    required this.lastPingAt,
  });

  final String pairedDeviceId;
  final int batteryLevel;
  final NetworkStatus networkStatus;
  final bool isHeadlessMode;
  final double currentLat;
  final double currentLng;
  final DateTime lastPingAt;

  DeviceTelemetry copyWith({
    int? batteryLevel,
    NetworkStatus? networkStatus,
    bool? isHeadlessMode,
    double? currentLat,
    double? currentLng,
    DateTime? lastPingAt,
  }) {
    return DeviceTelemetry(
      pairedDeviceId: pairedDeviceId,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      networkStatus: networkStatus ?? this.networkStatus,
      isHeadlessMode: isHeadlessMode ?? this.isHeadlessMode,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      lastPingAt: lastPingAt ?? this.lastPingAt,
    );
  }
}

class EmergencyAlert {
  const EmergencyAlert({
    required this.id,
    required this.pairedDeviceId,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.message,
    required this.createdAt,
  });

  final String id;
  final String pairedDeviceId;
  final AlertStatus status;
  final double latitude;
  final double longitude;
  final String message;
  final DateTime createdAt;

  EmergencyAlert copyWith({AlertStatus? status}) {
    return EmergencyAlert(
      id: id,
      pairedDeviceId: pairedDeviceId,
      status: status ?? this.status,
      latitude: latitude,
      longitude: longitude,
      message: message,
      createdAt: createdAt,
    );
  }
}

class UserMacro {
  const UserMacro({
    required this.id,
    required this.pairedDeviceId,
    required this.keyword,
    required this.actionType,
    required this.latitude,
    required this.longitude,
    required this.syncStatus,
    required this.updatedAt,
  });

  final String id;
  final String pairedDeviceId;
  final String keyword;
  final String actionType;
  final double latitude;
  final double longitude;
  final MacroSyncStatus syncStatus;
  final DateTime updatedAt;

  UserMacro copyWith({
    String? keyword,
    double? latitude,
    double? longitude,
    MacroSyncStatus? syncStatus,
    DateTime? updatedAt,
  }) {
    return UserMacro(
      id: id,
      pairedDeviceId: pairedDeviceId,
      keyword: keyword ?? this.keyword,
      actionType: actionType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      syncStatus: syncStatus ?? this.syncStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
