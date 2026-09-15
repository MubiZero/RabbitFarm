import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_context.dart';
import 'platform_announcements_tab.dart';
import 'platform_audit_tab.dart';
import 'platform_farms_tab.dart';
import 'platform_plans_tab.dart';
import 'platform_summary_tab.dart';
import 'platform_support_requests_tab.dart';
import '../widgets/support_contact_dialog.dart';

/// Платформенная админка — то, чем распоряжаются на уровне сервиса, а не
/// внутри одного хозяйства.
///
/// Вкладки отвечают на разные вопросы: «как дела у сервиса в целом», «кто чем
/// пользуется», «что мы вообще продаём», «что мы им сообщали», «о чём они нас
/// просят» и «что мы с ними делали». Тарифы без ферм — прайс-лист в вакууме,
/// фермы без тарифов — список без рычага, рассылка без истории — повод
/// отправить одно и то же дважды, без сводки картина целиком видна только по
/// кусочкам списка ферм, а без журнала на «кто закрыл эту ферму и зачем»
/// ответить нечем, хотя сервер записывает это с самого начала.
///
/// Виден экран только платформенному админу: вход в него есть лишь в
/// «Хозяйстве» и лишь при флаге суперадмина, а сервер и так откажет
/// остальным.
class PlatformAdminScreen extends StatefulWidget {
  const PlatformAdminScreen({super.key, this.initialTab});

  /// С какой вкладки открыть. Имя, а не номер: ссылка «Весь журнал» с
  /// карточки фермы не должна ломаться от того, что вкладок стало больше.
  final String? initialTab;

  /// Порядок вкладок на экране. Один список на разбор ссылки и на сборку
  /// самих вкладок: разойдясь, они открывали бы не то, что обещает ссылка.
  static const tabs = [
    'summary',
    'farms',
    'plans',
    'announcements',
    'support',
    'audit',
  ];

  @override
  State<PlatformAdminScreen> createState() => _PlatformAdminScreenState();
}

class _PlatformAdminScreenState extends State<PlatformAdminScreen>
    with SingleTickerProviderStateMixin {
  static const _plansTab = 2;
  static const _announcementsTab = 3;
  static const _supportTab = 4;
  static final _tabCount = PlatformAdminScreen.tabs.length;

  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    // Кнопка внизу справа своя у каждой вкладки, а на сводке, списке ферм и
    // обращениях её нет вовсе — поэтому экран следит за переключением.
    final requested = PlatformAdminScreen.tabs.indexOf(widget.initialTab ?? '');
    _tabs = TabController(
      length: _tabCount,
      vsync: this,
      initialIndex: requested < 0 ? 0 : requested,
    )..addListener(() => setState(() {}));
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
        // Официальный контакт поддержки правится отсюда, а не с отдельного
        // экрана: правят его раз в год, а искать такую настройку идут туда,
        // где читают обращения.
        actions: [
          if (_tabs.index == _supportTab)
            IconButton(
              icon: const Icon(Icons.contact_support_outlined),
              tooltip: l10n.platformSupportContactTitle,
              onPressed: () => showSupportContactDialog(context),
            ),
        ],
        bottom: TabBar(
          controller: _tabs,
          // Вкладок шесть — подписи целиком в ширину телефона не помещаются,
          // поэтому полоса прокручивается, а не ужимает слова до многоточий.
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: l10n.platformTabSummary),
            Tab(text: l10n.platformTabFarms),
            Tab(text: l10n.platformTabPlans),
            Tab(text: l10n.platformTabAnnouncements),
            Tab(text: l10n.platformTabSupport),
            Tab(text: l10n.platformTabAudit),
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
            onPressed: () => context.push('/platform-admin/announcements/form'),
            icon: const Icon(Icons.campaign_outlined),
            label: Text(l10n.platformAnnouncementNew),
          ),
        // На сводке, списке ферм, обращениях и в журнале создавать нечего:
        // сводка ничего не заводит, фермы появляются сами при регистрации,
        // обращения заводит фермер, а запись журнала — след чужого действия,
        // её не создают руками.
        _ => null,
      },
      body: TabBarView(
        controller: _tabs,
        children: const [
          PlatformSummaryTab(),
          PlatformFarmsTab(),
          PlatformPlansTab(),
          PlatformAnnouncementsTab(),
          PlatformSupportRequestsTab(),
          PlatformAuditTab(),
        ],
      ),
    );
  }
}
