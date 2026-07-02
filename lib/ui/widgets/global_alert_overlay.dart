import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savicam_relap/features/alerts/alert_provider.dart';
import 'package:savicam_relap/ui/screens/red_alert_screen.dart';

class GlobalAlertOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const GlobalAlertOverlay({super.key, required this.child});

  @override
  ConsumerState<GlobalAlertOverlay> createState() => _GlobalAlertOverlayState();
}

class _GlobalAlertOverlayState extends ConsumerState<GlobalAlertOverlay> {
  String? _currentlyShowingAlertId;

  @override
  Widget build(BuildContext context) {
    ref.listen(alertStreamProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        final alert = next.value!;
        // Nếu alert chưa được hiển thị, thì push màn hình RedAlert
        if (_currentlyShowingAlertId != alert.id) {
          _currentlyShowingAlertId = alert.id;
          
          // Dùng Navigator với context toàn cục (nếu có key) hoặc đẩy trực tiếp nếu thiết lập đúng
          // Ở đây ta dùng cách đơn giản nhất: đẩy lên bằng root Navigator.
          // Lưu ý: Yêu cầu MaterialApp có navigatorKey hoặc context này phải chứa Navigator.
          // Do widget này bọc child, chúng ta có thể push đè lên bằng một lớp Overlay, 
          // nhưng push route là an toàn nhất.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => RedAlertScreen(alert: alert),
              ),
            ).then((_) {
              // Khi màn hình bị đóng
              _currentlyShowingAlertId = null;
            });
          });
        }
      }
    });

    return widget.child;
  }
}
