import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/report_model.dart';
import '../../../rabbits/presentation/providers/breeds_provider.dart';
import '../../data/repositories/reports_repository.dart';

/// Reports repository provider
final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  final apiClient = ref.watch(apiClientProvider);
  return ReportsRepository(apiClient);
});

/// Dashboard report provider
final dashboardReportProvider =
    FutureProvider.autoDispose<DashboardReport>((ref) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getDashboard();
});

/// Farm report provider
final farmReportProvider = FutureProvider.autoDispose
    .family<FarmReport, ReportDateParams>((ref, params) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getFarmReport(
    fromDate: params.fromDate,
    toDate: params.toDate,
  );
});

/// Health report provider
final healthReportProvider = FutureProvider.autoDispose
    .family<HealthReport, ReportDateParams>((ref, params) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getHealthReport(
    fromDate: params.fromDate,
    toDate: params.toDate,
  );
});

/// Financial report provider
final financialReportProvider = FutureProvider.autoDispose
    .family<FinancialReport, FinancialReportParams>((ref, params) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getFinancialReport(
    fromDate: params.fromDate,
    toDate: params.toDate,
    groupBy: params.groupBy,
  );
});

/// Report date parameters
class ReportDateParams {
  final String? fromDate;
  final String? toDate;

  ReportDateParams({
    this.fromDate,
    this.toDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportDateParams &&
          runtimeType == other.runtimeType &&
          fromDate == other.fromDate &&
          toDate == other.toDate;

  @override
  int get hashCode => fromDate.hashCode ^ toDate.hashCode;
}

/// Financial report parameters
class FinancialReportParams extends ReportDateParams {
  final String? groupBy;

  FinancialReportParams({
    super.fromDate,
    super.toDate,
    this.groupBy,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is FinancialReportParams &&
          runtimeType == other.runtimeType &&
          groupBy == other.groupBy;

  @override
  int get hashCode => super.hashCode ^ groupBy.hashCode;
}

/// Названия пород по идентификатору.
///
/// В отчёте по ферме сервер отдаёт разбивку поголовья только по `breed_id`.
/// «Порода №7» человеку ничего не говорит, а список пород в приложении уже
/// загружается — остаётся сопоставить. Отдельный провайдер нужен, чтобы экран
/// отчётов не зависел от устройства списка пород (и чтобы в тестах хватало
/// одной подмены).
final reportBreedNamesProvider = Provider<Map<int, String>>((ref) {
  final breeds = ref.watch(breedsProvider).breeds;
  return {for (final breed in breeds) breed.id: breed.name};
});
