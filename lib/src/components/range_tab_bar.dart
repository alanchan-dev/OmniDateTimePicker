import 'package:flutter/material.dart';

class RangeTabBar extends StatelessWidget {
  final TabController tabController;
  final Widget? startWidget;
  final Widget? endWidget;

  const RangeTabBar({
    super.key,
    required this.tabController,
    this.startWidget,
    this.endWidget,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    return TabBar(
      controller: tabController,
      indicatorSize: Theme.of(context).tabBarTheme.indicatorSize ??
          TabBarIndicatorSize.tab,
      onTap: (index) {
        tabController.animateTo(index);
      },
      labelColor: Theme.of(context).colorScheme.onSurface,
      indicatorColor: Theme.of(context).colorScheme.primary,
      tabs: [
        Tab(
          text: startWidget == null ? localizations.dateRangeStartLabel : null,
          child: startWidget,
        ),
        Tab(
          text: endWidget == null ? localizations.dateRangeEndLabel : null,
          child: endWidget,
        ),
      ],
    );
  }
}
