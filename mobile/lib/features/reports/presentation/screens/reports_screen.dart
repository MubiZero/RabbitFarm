import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/widgets.dart';

/// Отчёты по ферме, здоровью и деньгам.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.reportsTitle)),
      body: AppEmptyState(
        icon: Icons.insights_outlined,
        title: context.l10n.emptyNoRecordsTitle,
        subtitle: context.l10n.emptyNoRecordsBody,
      ),
    );
  }
}
