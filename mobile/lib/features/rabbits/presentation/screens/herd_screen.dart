import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../cages/presentation/screens/cages_list_screen.dart';
import 'rabbits_list_screen.dart';

/// Стадо — два взгляда на одно и то же поголовье.
///
/// В крольчатнике идут по рядам, а не по списку бирок, поэтому клетки здесь
/// равноправны со списком особей, а не спрятаны в меню.
class HerdScreen extends StatefulWidget {
  const HerdScreen({super.key});

  @override
  State<HerdScreen> createState() => _HerdScreenState();
}

class _HerdScreenState extends State<HerdScreen> {
  int _view = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                AppSpacing.lg,
                AppSpacing.screenH,
                AppSpacing.md,
              ),
              child: SegmentedButton<int>(
                segments: [
                  ButtonSegment(value: 0, label: Text(context.l10n.herdTabCages)),
                  ButtonSegment(
                      value: 1, label: Text(context.l10n.herdTabRabbits)),
                ],
                selected: {_view},
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _view = s.first),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _view,
                children: const [CagesListScreen(), RabbitsListScreen()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
