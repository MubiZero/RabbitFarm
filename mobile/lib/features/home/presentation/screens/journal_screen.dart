import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/widgets.dart';

/// Журнал — что записано за смену.
class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.journalTitle)),
      body: AppEmptyState(
        icon: Icons.assignment_outlined,
        title: context.l10n.emptyNoRecordsTitle,
        subtitle: context.l10n.emptyNoRecordsBody,
      ),
    );
  }
}
