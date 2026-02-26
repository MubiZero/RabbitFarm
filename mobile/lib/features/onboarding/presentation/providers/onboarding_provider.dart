import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingDone = 'onboarding_done';
const _kFarmName       = 'farm_name';
const _kFarmType       = 'farm_type'; // 'solo' | 'team'
const _kTourDone       = 'tour_done';

class OnboardingState {
  final bool isDone;
  final String farmName;
  final String farmType; // 'solo' | 'team'
  final bool tourDone;

  const OnboardingState({
    this.isDone   = false,
    this.farmName = '',
    this.farmType = 'solo',
    this.tourDone = false,
  });

  OnboardingState copyWith({
    bool? isDone,
    String? farmName,
    String? farmType,
    bool? tourDone,
  }) =>
      OnboardingState(
        isDone:   isDone   ?? this.isDone,
        farmName: farmName ?? this.farmName,
        farmType: farmType ?? this.farmType,
        tourDone: tourDone ?? this.tourDone,
      );
}

class OnboardingNotifier extends AsyncNotifier<OnboardingState> {
  @override
  Future<OnboardingState> build() async {
    final prefs = await SharedPreferences.getInstance();
    return OnboardingState(
      isDone:   prefs.getBool(_kOnboardingDone) ?? false,
      farmName: prefs.getString(_kFarmName) ?? '',
      farmType: prefs.getString(_kFarmType) ?? 'solo',
      tourDone: prefs.getBool(_kTourDone) ?? false,
    );
  }

  Future<void> saveFarmName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFarmName, name);
    state = AsyncData(state.value!.copyWith(farmName: name));
  }

  Future<void> saveFarmType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFarmType, type);
    state = AsyncData(state.value!.copyWith(farmType: type));
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingDone, true);
    state = AsyncData(state.value!.copyWith(isDone: true));
  }

  Future<void> completeTour() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTourDone, true);
    state = AsyncData(state.value!.copyWith(tourDone: true));
  }
}

final onboardingProvider =
    AsyncNotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);
