import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../l10n/l10n_context.dart';
import '../providers/locale_provider.dart';
import '../theme/theme.dart';

/// Диктовка вместо набора.
///
/// Заметку о кролике пишут у клетки: одной рукой держат телефон, второй —
/// животное, и обе в перчатках. Набирать текст в таких условиях никто не
/// будет — запись просто не появится. Это единственный вид ввода, который в
/// сарае работает без рук.
///
/// Распознавание идёт средствами телефона, без нашего сервера: интернета в
/// сарае нет, а на Android движок распознавания обычно умеет работать и
/// вовсе без сети.
class VoiceInput {
  VoiceInput();

  final SpeechToText _speech = SpeechToText();
  bool _ready = false;

  /// Готов ли телефон распознавать речь. `false` — на устройстве нет движка
  /// или человек не дал доступ к микрофону.
  Future<bool> prepare() async {
    if (kIsWeb) return false;
    if (_ready) return true;
    try {
      _ready = await _speech.initialize(
        onError: (error) => debugPrint('Диктовка: ${error.errorMsg}'),
      );
    } catch (e) {
      debugPrint('Диктовка недоступна: $e');
      _ready = false;
    }
    return _ready;
  }

  bool get isListening => _speech.isListening;

  /// Какой язык слушать.
  ///
  /// Таджикского и узбекского у системных распознавателей обычно нет вовсе,
  /// и запрос несуществующей локали заканчивается молчанием. Поэтому берётся
  /// ближайшая поддерживаемая: для них это русский — язык, на котором в
  /// регионе и так говорят с телефоном.
  static String recognitionLocale(String languageCode) =>
      switch (languageCode) {
        'en' => 'en_US',
        _ => 'ru_RU',
      };

  Future<void> listen({
    required String localeId,
    required ValueChanged<String> onResult,
    required VoidCallback onDone,
  }) async {
    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
        if (result.finalResult) onDone();
      },
      listenOptions: SpeechListenOptions(
        localeId: localeId,
        // Промежуточные слова видны сразу: без них человек полторы секунды
        // смотрит на пустое поле и начинает диктовать заново.
        partialResults: true,
        cancelOnError: true,
        // Три секунды тишины — конец фразы. Заметка у клетки короткая, и
        // ждать дольше значит держать человека у открытого микрофона.
        pauseFor: const Duration(seconds: 3),
        listenFor: const Duration(seconds: 45),
      ),
    );
  }

  Future<void> stop() => _speech.stop();
}

final voiceInputProvider = Provider<VoiceInput>((ref) => VoiceInput());

/// Значок микрофона в поле ввода.
///
/// Надиктованное дописывается к тому, что уже набрано, а не заменяет его:
/// человек мог начать печатать и продолжить голосом.
class VoiceInputButton extends ConsumerStatefulWidget {
  const VoiceInputButton({super.key, required this.controller, this.onChanged});

  final TextEditingController controller;
  final VoidCallback? onChanged;

  @override
  ConsumerState<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends ConsumerState<VoiceInputButton> {
  bool _listening = false;

  /// Текст до начала диктовки — к нему приписывается распознанное. Без него
  /// каждое уточнение движка затирало бы уже набранное.
  String _base = '';

  Future<void> _toggle() async {
    final voice = ref.read(voiceInputProvider);
    final messenger = ScaffoldMessenger.of(context);
    final unavailable = context.l10n.voiceUnavailable;

    if (_listening) {
      await voice.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }

    if (!await voice.prepare()) {
      messenger.showSnackBar(SnackBar(content: Text(unavailable)));
      return;
    }
    if (!mounted) return;

    _base = widget.controller.text.trimRight();
    setState(() => _listening = true);
    await HapticFeedback.selectionClick();

    final language = ref.read(localeProvider).value?.languageCode ?? 'ru';
    await voice.listen(
      localeId: VoiceInput.recognitionLocale(language),
      onResult: (words) {
        widget.controller.text = _base.isEmpty ? words : '$_base $words';
        widget.controller.selection = TextSelection.collapsed(
          offset: widget.controller.text.length,
        );
        widget.onChanged?.call();
      },
      onDone: () {
        if (mounted) setState(() => _listening = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: _listening ? context.l10n.voiceStop : context.l10n.voiceDictate,
      onPressed: _toggle,
      iconSize: 24,
      constraints: const BoxConstraints(
        minWidth: AppSizes.iconButton,
        minHeight: AppSizes.iconButton,
      ),
      icon: Icon(
        _listening ? Icons.mic : Icons.mic_none_outlined,
        color:
            _listening ? context.colors.error : context.colors.onSurfaceVariant,
      ),
    );
  }
}
