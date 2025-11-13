import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Баннер с важными уведомлениями и алертами
class AlertBanner extends StatelessWidget {
  final String title;
  final String message;
  final AlertType type;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const AlertBanner({
    super.key,
    required this.title,
    required this.message,
    this.type = AlertType.info,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(type);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: config.borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: config.color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: config.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    config.icon,
                    color: config.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: config.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onDismiss != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: onDismiss,
                    color: AppTheme.textSecondary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ] else if (onTap != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: config.color,
                    size: 24,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  _AlertConfig _getConfig(AlertType type) {
    switch (type) {
      case AlertType.error:
        return _AlertConfig(
          icon: Icons.error_outline,
          color: AppTheme.errorColor,
          backgroundColor: AppTheme.errorColor.withOpacity(0.05),
          borderColor: AppTheme.errorColor.withOpacity(0.2),
        );
      case AlertType.warning:
        return _AlertConfig(
          icon: Icons.warning_amber_outlined,
          color: AppTheme.warningColor,
          backgroundColor: AppTheme.warningColor.withOpacity(0.05),
          borderColor: AppTheme.warningColor.withOpacity(0.2),
        );
      case AlertType.success:
        return _AlertConfig(
          icon: Icons.check_circle_outline,
          color: AppTheme.successColor,
          backgroundColor: AppTheme.successColor.withOpacity(0.05),
          borderColor: AppTheme.successColor.withOpacity(0.2),
        );
      case AlertType.info:
        return _AlertConfig(
          icon: Icons.info_outline,
          color: AppTheme.infoColor,
          backgroundColor: AppTheme.infoColor.withOpacity(0.05),
          borderColor: AppTheme.infoColor.withOpacity(0.2),
        );
    }
  }
}

enum AlertType { error, warning, success, info }

class _AlertConfig {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final Color borderColor;

  _AlertConfig({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
  });
}
