import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import 'buttons/primary_button.dart';

/// Friendly error state (network failure, load failure) with a retry action.
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final String retryLabel;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorStateWidget({
    super.key,
    required this.title,
    this.message,
    required this.retryLabel,
    required this.onRetry,
    this.icon = Icons.wifi_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: AppColors.error),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
              ),
            ],
            const SizedBox(height: 24),
            PrimaryButton(
              label: retryLabel,
              onPressed: onRetry,
              fullWidth: false,
              icon: Icons.refresh_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
