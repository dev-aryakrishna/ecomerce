import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_durations.dart';

/// The app's main call-to-action button (Login, Add to Cart, Place Order...).
/// Handles its own loading state so screens don't need to swap the button
/// for a `CircularProgressIndicator` themselves.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primary;
    final disabled = isLoading || onPressed == null;

    final child = AnimatedSwitcher(
      duration: AppDurations.fast,
      child: isLoading
          ? const SizedBox(
              key: ValueKey('loading'),
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation(AppColors.textWhite),
              ),
            )
          : Row(
              key: const ValueKey('label'),
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          disabledBackgroundColor: bg.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.smRadius),
        ),
        child: child,
      ),
    );
  }
}
