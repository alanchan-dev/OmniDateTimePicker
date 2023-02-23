import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key, required this.tabController});

  final TabController tabController;

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
      labelColor: Theme.of(context).useMaterial3
          ? null
          : Theme.of(context).colorScheme.onSurface,
      indicatorColor: Theme.of(context).useMaterial3
          ? null
          : Theme.of(context).colorScheme.primary,
      tabs: [
        Tab(
          text: localizations.dateRangeStartLabel,
        ),
        Tab(
          text: localizations.dateRangeEndLabel,
        ),
      ],
    );
  }
}
