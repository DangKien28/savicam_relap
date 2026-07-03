import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/services/pairing_service.dart';

final pairingStatusProvider = FutureProvider.family<bool, String>((ref, userId) {
  return PairingService().hasPairedDevice(userId);
});