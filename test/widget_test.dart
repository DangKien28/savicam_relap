import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:savicam_relap/app.dart';

void main() {
  testWidgets('renders the companion app shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SaViCamRelapApp()));

    expect(find.text('SaViCam Relap'), findsOneWidget);
    expect(find.text('SOS đang hoạt động'), findsOneWidget);
    expect(find.textContaining('Live tracking'), findsOneWidget);
  });
}
