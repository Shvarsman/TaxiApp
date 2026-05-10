import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/l10n/app_localizations.dart';

/// Общий адаптивный каркас приложения с навигацией.
/// Сохраняется при переключении между вкладками (Home, Booking, History, Settings).
class ShellScaffold extends StatelessWidget {
  final Widget child;

  const ShellScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/booking')) return 1;
    if (location.startsWith('/history')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/booking');
        break;
      case 2:
        context.go('/history');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedIndex = _currentIndex(context);

    final destinations = [
      NavigationDestination(icon: const Icon(Icons.home), label: l10n.home),
      NavigationDestination(icon: const Icon(Icons.local_taxi), label: l10n.orderTaxi),
      NavigationDestination(icon: const Icon(Icons.history), label: l10n.history),
      NavigationDestination(icon: const Icon(Icons.settings), label: l10n.settings),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Мобильный вариант: нижняя панель навигации
          return Scaffold(
            body: child,
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => _onTap(index, context),
              destinations: destinations,
            ),
          );
        } else {
          // Десктоп / планшет: боковая панель
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) => _onTap(index, context),
                  labelType: NavigationRailLabelType.all,
                  destinations: destinations
                      .map((d) => NavigationRailDestination(
                    icon: d.icon,
                    selectedIcon: d.selectedIcon,
                    label: Text(d.label),
                  ))
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            ),
          );
        }
      },
    );
  }
}