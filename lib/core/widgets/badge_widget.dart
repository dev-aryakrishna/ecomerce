import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../theme/app_radius.dart';

enum BadgeVariant { success, warning, error, info, neutral }

/// Small pill label for statuses like "In Stock", "-20%", "Delivered".
class BadgeWidget extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final IconData? icon;

  const BadgeWidget({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.icon,
  });

  (Color, Color) _colors(BuildContext context) {
    switch (variant) {
      case BadgeVariant.success:
        return (AppColors.successLight, AppColors.success);
      case BadgeVariant.warning:
        return (AppColors.warningLight, AppColors.warning);
      case BadgeVariant.error:
        return (AppColors.errorLight, AppColors.error);
      case BadgeVariant.info:
        return (AppColors.primaryLight, AppColors.primaryDark);
      case BadgeVariant.neutral:
        return (context.colors.surfaceAlt, context.colors.textSecondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
          ),
        ],
      ),
    );
  }
}
