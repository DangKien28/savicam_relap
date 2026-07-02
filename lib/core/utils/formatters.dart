import '../models/app_models.dart';

String formatCoordinate(double value) => value.toStringAsFixed(5);

String formatLatLng(double latitude, double longitude) {
  return '${formatCoordinate(latitude)}, ${formatCoordinate(longitude)}';
}

String networkStatusLabel(NetworkStatus status) {
  return switch (status) {
    NetworkStatus.online => 'Online',
    NetworkStatus.weak => 'Yếu',
    NetworkStatus.offline => 'Mất kết nối',
  };
}

String timeAgo(DateTime value) {
  final Duration diff = DateTime.now().difference(value);
  if (diff.inSeconds < 60) {
    return 'vừa xong';
  }
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} phút trước';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours} giờ trước';
  }
  return '${diff.inDays} ngày trước';
}
