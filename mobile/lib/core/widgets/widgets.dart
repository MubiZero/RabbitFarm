/// Единая точка входа в библиотеку общих элементов интерфейса.
///
/// Экран подключает её одной строкой и получает карточки, состояния загрузки,
/// пустоты и ошибки, каркасы списка и формы. Собственные копии этих элементов
/// в экранах заводить не нужно — именно из-за них соседние разделы приложения
/// выглядели по-разному.
library;

export 'alert_card.dart';
export 'app_async_view.dart';
export 'app_brand_mark.dart';
export 'app_card.dart';
export 'app_crash_view.dart';
export 'app_date_field.dart';
export 'app_empty_state.dart';
export 'app_error_state.dart';
export 'app_filter_bar.dart';
export 'app_form_scaffold.dart';
export 'app_form_section.dart';
export 'app_group_label.dart';
export 'app_section_title.dart';
export 'delayed_spinner.dart';
export 'metric_bar.dart';
export 'paged_list_view.dart';
export 'plan_limit_dialog.dart';
export 'skeleton.dart';
export 'stale_data_banner.dart';
export 'stat_tile.dart';
export 'stats_period.dart';
export 'status_badge.dart';
