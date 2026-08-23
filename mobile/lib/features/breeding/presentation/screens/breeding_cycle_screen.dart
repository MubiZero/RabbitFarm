import 'package:flutter/material.dart';

import 'breeding_list_screen.dart';

/// Разведение — линия цикла от случки до отсадки.
///
/// Пока показывает прежний список случек; лента стадий собирается отдельно.
class BreedingCycleScreen extends StatelessWidget {
  const BreedingCycleScreen({super.key});

  @override
  Widget build(BuildContext context) => const BreedingListScreen();
}
