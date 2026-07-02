import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashboard/presentation/dashboard_page.dart';
import '../../settings/presentation/settings_page.dart';
import '../../sos_alert/presentation/sos_alert_page.dart';
import '../../telemetry_monitor/presentation/telemetry_page.dart';
import '../../user_macros/presentation/user_macros_page.dart';

final homeIndexProvider = StateProvider<int>((ref) => 0);

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = ref.watch(homeIndexProvider);
    final bool isWideLayout = MediaQuery.sizeOf(context).width >= 840;

    final List<Widget> pages = <Widget>[
      const DashboardPage(),
      const SOSAlertPage(),
      const TelemetryPage(),
      const UserMacrosPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: isWideLayout
            ? Row(
                children: <Widget>[
                  NavigationRail(
                    selectedIndex: currentIndex,
                    onDestinationSelected: (int index) =>
                        ref.read(homeIndexProvider.notifier).state = index,
                    labelType: NavigationRailLabelType.all,
                    minWidth: 88,
                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: Icon(Icons.dashboard_outlined),
                        selectedIcon: Icon(Icons.dashboard),
                        label: Text('Dashboard'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.warning_amber_outlined),
                        selectedIcon: Icon(Icons.warning_amber),
                        label: Text('SOS'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.monitor_heart_outlined),
                        selectedIcon: Icon(Icons.monitor_heart),
                        label: Text('Telemetry'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.book_outlined),
                        selectedIcon: Icon(Icons.book),
                        label: Text('Vị trí'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: Text('Cài đặt'),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: pages[currentIndex]),
                ],
              )
            : Column(
                children: <Widget>[
                  Expanded(child: pages[currentIndex]),
                  NavigationBar(
                    selectedIndex: currentIndex,
                    onDestinationSelected: (int index) =>
                        ref.read(homeIndexProvider.notifier).state = index,
                    destinations: const <NavigationDestination>[
                      NavigationDestination(
                        icon: Icon(Icons.dashboard_outlined),
                        selectedIcon: Icon(Icons.dashboard),
                        label: 'Dashboard',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.warning_amber_outlined),
                        selectedIcon: Icon(Icons.warning_amber),
                        label: 'SOS',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.monitor_heart_outlined),
                        selectedIcon: Icon(Icons.monitor_heart),
                        label: 'Telemetry',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.book_outlined),
                        selectedIcon: Icon(Icons.book),
                        label: 'Vị trí',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: 'Cài đặt',
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
