import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Свёрнутая часть формы — всё, что можно не заполнять.
///
/// Длинная форма отпугивает сильнее, чем отсутствие полей: человек видит
/// десяток строк и откладывает запись «на потом», а потом не возвращается.
/// Поля при этом никуда не деваются — они просто не требуют внимания, пока
/// их не попросили.
///
/// Раскрытие не прячет заполненное: если внутри уже что-то есть (правка
/// существующей записи), блок открыт сразу — иначе человек решил бы, что
/// данные потерялись.
class AppFormDisclosure extends StatefulWidget {
  const AppFormDisclosure({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });

  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  State<AppFormDisclosure> createState() => _AppFormDisclosureState();
}

class _AppFormDisclosureState extends State<AppFormDisclosure> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: AppRadius.mdAll,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppSizes.touchTarget,
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: context.text.titleMedium?.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: context.reduceMotion
                      ? Duration.zero
                      : AppDuration.fast,
                  curve: AppDuration.curve,
                  child: Icon(
                    Icons.expand_more,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: AppSpacing.lg),
          for (var i = 0; i < widget.children.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.lg),
            widget.children[i],
          ],
        ],
      ],
    );
  }
}
