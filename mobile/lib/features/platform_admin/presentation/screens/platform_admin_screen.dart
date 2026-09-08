import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_context.dart';
import 'platform_announcements_tab.dart';
import 'platform_farms_tab.dart';
import 'platform_plans_tab.dart';

/// Платформенная админка — то, чем распоряжаются на уровне сервиса, а не
/// внутри одного хозяйства.
///
/// Три вкладки отвечают на три разных вопроса: «кто чем пользуется», «что мы
/// вообще продаём» и «что мы им сообщали». Тарифы без ферм — прайс-лист в
/// вакууме, фермы без тарифов — список без рычага, а рассылка без истории —
/// повод отправить одно и то же дважды.
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
  static const _plansTab = 1;
  static const _announcementsTab = 2;

  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    // Кнопка внизу справа своя у каждой вкладки, а на списке ферм её нет
    // вовсе — поэтому экран следит за переключением.
    _tabs = TabController(length: 3, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.platformTitle),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.platformTabFarms),
            Tab(text: l10n.platformTabPlans),
            Tab(text: l10n.platformTabAnnouncements),
          ],
        ),
      ),
      floatingActionButton: switch (_tabs.index) {
        _plansTab => FloatingActionButton.extended(
            onPressed: () => context.push('/platform-admin/plans/form'),
            icon: const Icon(Icons.add),
            label: Text(l10n.platformPlanNew),
          ),
        _announcementsTab => FloatingActionButton.extended(
            onPressed: () =>
                context.push('/platform-admin/announcements/form'),
            icon: const Icon(Icons.campaign_outlined),
            label: Text(l10n.platformAnnouncementNew),
          ),
        // На списке ферм создавать нечего: фермы появляются сами, когда
        // кто-нибудь регистрируется.
        _ => null,
      },
      body: TabBarView(
        controller: _tabs,
        children: const [
          PlatformFarmsTab(),
          PlatformPlansTab(),
          PlatformAnnouncementsTab(),
        ],
      ),
    );
  }
}
