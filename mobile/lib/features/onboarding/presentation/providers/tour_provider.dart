import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_provider.dart';

class TourState {
  /// Current step index (0-based). -1 = not active.
  final int step;
  final bool isActive;

  const TourState({this.step = -1, this.isActive = false});

  bool get isDone => !isActive;

  TourState copyWith({int? step, bool? isActive}) => TourState(
        step: step ?? this.step,
        isActive: isActive ?? this.isActive,
      );
}

class TourNotifier extends Notifier<TourState> {
  @override
  TourState build() => const TourState();

  void start() {
    state = const TourState(step: 0, isActive: true);
  }

  /// Move to the next step. If on the last step, complete the tour.
  void advance(int totalSteps) {
    if (!state.isActive) return;
    if (state.step >= totalSteps - 1) {
      _complete();
    } else {
      state = state.copyWith(step: state.step + 1);
    }
  }

  void skip() => _complete();

  void _complete() {
    state = const TourState(step: -1, isActive: false);
    // Mark tour done in onboarding state
    ref.read(onboardingProvider.notifier).completeTour();
  }
}

final tourProvider =
    NotifierProvider<TourNotifier, TourState>(TourNotifier.new);
