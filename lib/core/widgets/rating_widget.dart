import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../theme/app_radius.dart';

/// Compact star + numeric rating, e.g. for product cards and reviews.
class RatingWidget extends StatelessWidget {
  final double rating;
  final double size;
  final bool showBackground;

  const RatingWidget({
    super.key,
    required this.rating,
    this.size = 12,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size + 2, color: AppColors.star),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: showBackground ? AppColors.textPrimary : context.colors.textSecondary,
          ),
        ),
      ],
    );

    if (!showBackground) return content;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: AppRadius.xsRadius,
      ),
      child: content,
    );
  }
}
