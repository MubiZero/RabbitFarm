import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/staff_models.dart';
import '../../data/repositories/staff_repository.dart';

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  return StaffRepository(ref.watch(apiClientProvider));
});

/// Состав фермы.
final farmMembersProvider =
    FutureProvider.autoDispose<List<FarmMember>>((ref) async {
  return ref.watch(staffRepositoryProvider).getMembers();
});

/// Действующие приглашения.
final farmInvitationsProvider =
    FutureProvider.autoDispose<List<FarmInvitation>>((ref) async {
  return ref.watch(staffRepositoryProvider).getInvitations();
});
