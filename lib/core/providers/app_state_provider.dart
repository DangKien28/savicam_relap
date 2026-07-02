import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';

const String demoPairedDeviceId = 'pair-saigon-001';

class RelapAppState {
  const RelapAppState({
    required this.telemetry,
    required this.alerts,
    required this.macros,
    required this.isSyncing,
    required this.lastSyncAt,
  });

  final DeviceTelemetry telemetry;
  final List<EmergencyAlert> alerts;
  final List<UserMacro> macros;
  final bool isSyncing;
  final DateTime? lastSyncAt;

  EmergencyAlert? get activeAlert {
    for (final EmergencyAlert alert in alerts) {
      if (alert.status == AlertStatus.active) {
        return alert;
      }
    }
    return null;
  }

  int get pendingMacroCount => macros
      .where((UserMacro macro) => macro.syncStatus == MacroSyncStatus.pending)
      .length;

  RelapAppState copyWith({
    DeviceTelemetry? telemetry,
    List<EmergencyAlert>? alerts,
    List<UserMacro>? macros,
    bool? isSyncing,
    DateTime? lastSyncAt,
  }) {
    return RelapAppState(
      telemetry: telemetry ?? this.telemetry,
      alerts: alerts ?? this.alerts,
      macros: macros ?? this.macros,
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }
}

class RelapAppController extends StateNotifier<RelapAppState> {
  RelapAppController() : super(_initialState());

  static RelapAppState _initialState() {
    final DateTime now = DateTime.now();
    return RelapAppState(
      telemetry: DeviceTelemetry(
        pairedDeviceId: demoPairedDeviceId,
        batteryLevel: 72,
        networkStatus: NetworkStatus.online,
        isHeadlessMode: true,
        currentLat: 10.7769,
        currentLng: 106.7009,
        lastPingAt: now.subtract(const Duration(minutes: 2)),
      ),
      alerts: <EmergencyAlert>[
        EmergencyAlert(
          id: 'alert-001',
          pairedDeviceId: demoPairedDeviceId,
          status: AlertStatus.active,
          latitude: 10.7769,
          longitude: 106.7009,
          message: 'Người dùng vừa bấm SOS gần trung tâm Quận 1.',
          createdAt: now.subtract(const Duration(minutes: 4)),
        ),
      ],
      macros: <UserMacro>[
        UserMacro(
          id: 'macro-home',
          pairedDeviceId: demoPairedDeviceId,
          keyword: 'Nhà',
          actionType: 'navigate',
          latitude: 10.7821,
          longitude: 106.6993,
          syncStatus: MacroSyncStatus.synced,
          updatedAt: now.subtract(const Duration(hours: 2)),
        ),
        UserMacro(
          id: 'macro-hospital',
          pairedDeviceId: demoPairedDeviceId,
          keyword: 'Bệnh viện',
          actionType: 'navigate',
          latitude: 10.7558,
          longitude: 106.6803,
          syncStatus: MacroSyncStatus.pending,
          updatedAt: now.subtract(const Duration(minutes: 18)),
        ),
        UserMacro(
          id: 'macro-school',
          pairedDeviceId: demoPairedDeviceId,
          keyword: 'Trường',
          actionType: 'navigate',
          latitude: 10.7715,
          longitude: 106.7041,
          syncStatus: MacroSyncStatus.synced,
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
      ],
      isSyncing: false,
      lastSyncAt: now.subtract(const Duration(minutes: 11)),
    );
  }

  void resolveAlert(String alertId) {
    state = state.copyWith(
      alerts: state.alerts
          .map(
            (EmergencyAlert alert) => alert.id == alertId
                ? alert.copyWith(status: AlertStatus.resolved)
                : alert,
          )
          .toList(),
    );
  }

  void createDemoAlert() {
    final DateTime now = DateTime.now();
    state = state.copyWith(
      alerts: <EmergencyAlert>[
        EmergencyAlert(
          id: 'alert-${now.microsecondsSinceEpoch}',
          pairedDeviceId: demoPairedDeviceId,
          status: AlertStatus.active,
          latitude: state.telemetry.currentLat,
          longitude: state.telemetry.currentLng,
          message: 'Tín hiệu SOS mới từ thiết bị T-Mod.',
          createdAt: now,
        ),
        ...state.alerts,
      ],
    );
  }

  void updateTelemetry({
    required int batteryLevel,
    required NetworkStatus networkStatus,
    required bool isHeadlessMode,
  }) {
    state = state.copyWith(
      telemetry: state.telemetry.copyWith(
        batteryLevel: batteryLevel.clamp(0, 100),
        networkStatus: networkStatus,
        isHeadlessMode: isHeadlessMode,
        lastPingAt: DateTime.now(),
      ),
    );
  }

  void upsertMacro({
    String? id,
    required String keyword,
    required double latitude,
    required double longitude,
  }) {
    final DateTime now = DateTime.now();
    final String trimmedKeyword = keyword.trim();
    if (trimmedKeyword.isEmpty) {
      return;
    }

    final UserMacro macro = UserMacro(
      id: id ?? 'macro-${now.microsecondsSinceEpoch}',
      pairedDeviceId: demoPairedDeviceId,
      keyword: trimmedKeyword,
      actionType: 'navigate',
      latitude: latitude,
      longitude: longitude,
      syncStatus: MacroSyncStatus.pending,
      updatedAt: now,
    );

    final bool exists = state.macros.any((UserMacro item) => item.id == macro.id);
    state = state.copyWith(
      macros: exists
          ? state.macros
              .map((UserMacro item) => item.id == macro.id ? macro : item)
              .toList()
          : <UserMacro>[macro, ...state.macros],
    );
  }

  void deleteMacro(String id) {
    state = state.copyWith(
      macros: state.macros.where((UserMacro macro) => macro.id != id).toList(),
    );
  }

  Future<void> syncMacros() async {
    state = state.copyWith(isSyncing: true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    state = state.copyWith(
      isSyncing: false,
      lastSyncAt: DateTime.now(),
      macros: state.macros
          .map(
            (UserMacro macro) =>
                macro.copyWith(syncStatus: MacroSyncStatus.synced),
          )
          .toList(),
    );
  }
}

final relapAppControllerProvider =
    StateNotifierProvider<RelapAppController, RelapAppState>(
  (Ref ref) => RelapAppController(),
);
