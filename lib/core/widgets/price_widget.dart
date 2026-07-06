import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

/// Consistent price formatting across product cards, detail, and cart.
/// Pass [originalPrice] to show a struck-through was-price next to it.
class PriceWidget extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final double fontSize;
  final Color? color;

  const PriceWidget({
    super.key,
    required this.price,
    this.originalPrice,
    this.fontSize = 16,
    this.color,
  });

  String _fmt(double v) => '\$${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final showOriginal = originalPrice != null && originalPrice! > price;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          _fmt(price),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: color ?? AppColors.primaryDark,
          ),
        ),
        if (showOriginal) ...[
          const SizedBox(width: 6),
          Flexible(
          child : Text(
            _fmt(originalPrice!),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize * 0.78,
              color: context.colors.textTertiary,
              decoration: TextDecoration.lineThrough,
            ),
          ),),
        ],
      ],
    );
  }
}
