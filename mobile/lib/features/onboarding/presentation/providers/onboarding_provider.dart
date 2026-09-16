import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/onboarding_answers.dart';

const _kOnboardingSeen = 'onboarding_seen';
const _kOnboardingAnswers = 'onboarding_answers';

/// Знакомство пройдено — больше не показывать.
///
/// Отдельно от аккаунта и намеренно переживает выход: человек, который вышел
/// и зашёл снова, уже видел эти вопросы, и второй раз они выглядят
/// издевательством, а не знакомством.
class OnboardingSeenNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kOnboardingSeen) ?? false;
  }

  Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingSeen, true);
    state = const AsyncData(true);
  }
}

final onboardingSeenProvider =
    AsyncNotifierProvider<OnboardingSeenNotifier, bool>(
  OnboardingSeenNotifier.new,
);

/// Ответы из знакомства.
///
/// Читаются уже после регистрации — на «Сегодня», чтобы первые шаги
/// соответствовали тому, что человек про себя рассказал.
class OnboardingAnswersNotifier extends AsyncNotifier<OnboardingAnswers> {
  @override
  Future<OnboardingAnswers> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kOnboardingAnswers);
    if (raw == null) return const OnboardingAnswers();

    try {
      return OnboardingAnswers.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } on FormatException {
      // Ответы — подсказка, а не данные фермы: испорченную строку незачем
      // чинить или показывать человеку, достаточно забыть.
      return const OnboardingAnswers();
    }
  }

  Future<void> save(OnboardingAnswers answers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kOnboardingAnswers, jsonEncode(answers.toJson()));
    state = AsyncData(answers);
  }
}

final onboardingAnswersProvider =
    AsyncNotifierProvider<OnboardingAnswersNotifier, OnboardingAnswers>(
  OnboardingAnswersNotifier.new,
);
