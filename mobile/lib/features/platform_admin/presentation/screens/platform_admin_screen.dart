import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_context.dart';
import 'platform_farms_tab.dart';
import 'platform_plans_tab.dart';

/// Платформенная админка — то, чем распоряжаются на уровне сервиса, а не
/// внутри одного хозяйства.
///
/// Две вкладки отвечают на два разных вопроса: «что мы вообще продаём» и
/// «кто чем пользуется». Тарифы без ферм — прайс-лист в вакууме, фермы без
/// тарифов — список без рычага, поэтому они рядом.
///
/// Виден экран только платформенному админу: вход в него есть лишь в
/// «Хозяйстве» и лишь при флаге суперадмина, а сервер и так откажет
/// остальным.
class PlatformAdminScreen extends StatefulWidget {
  const PlatformAdminScreen({super.key});

  @override
  State<PlatformAdminScreen> createState() => _PlatformAdminScreenState();
}

class _PlatformAdminScreenState extends State<PlatformAdminScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    // Кнопка «Новый тариф» относится только к вкладке тарифов, поэтому экран
    // следит за переключением: на списке ферм создавать нечего.
    _tabs = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onPlansTab = _tabs.index == 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.platformTitle),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: context.l10n.platformTabFarms),
            Tab(text: context.l10n.platformTabPlans),
          ],
        ),
      ),
      floatingActionButton: onPlansTab
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/platform-admin/plans/form'),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.platformPlanNew),
            )
          : null,
      body: TabBarView(
        controller: _tabs,
        children: const [
          PlatformFarmsTab(),
          PlatformPlansTab(),
        ],
      ),
    );
  }
}
