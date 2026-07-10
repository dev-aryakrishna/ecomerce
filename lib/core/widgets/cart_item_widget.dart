import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../theme/app_radius.dart';
import 'price_widget.dart';
import 'quantity_selector.dart';
import 'package:ecomerceapp/core/utils/price_calculation.dart';


/// Row used for each line item on the Cart screen.
class CartItemWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  /// Pre-discount price, if this item was on sale when added to the cart.
  final double? originalPrice;

  const CartItemWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;
    final discountPercent = PriceCalculation.discountPercentageForm(
      price: price, 
      originalPrice: originalPrice
    );
        

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: AppRadius.smRadius,
                child: imageUrl.isEmpty
                    ? Container(
                        width: 72,
                        height: 72,
                        color: context.colors.surfaceAlt,
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          color: context.colors.textTertiary,
                        ),
                      )
                    : Image.network(
                        imageUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 72,
                          height: 72,
                          color: context.colors.surfaceAlt,
                          child: Icon(
                            Icons.broken_image_rounded,
                            color: context.colors.textTertiary,
                          ),
                        ),
                      ),
              ),
              if (hasDiscount)
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.sm),
                        bottomRight: Radius.circular(AppRadius.xs),
                      ),
                    ),
                    child: Text(
                      '$discountPercent%',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                PriceWidget(
                  price: price,
                  originalPrice: originalPrice,
                  fontSize: 14,
                ),
                if (hasDiscount) ...[
                  const SizedBox(height: 2),
                  Text(
                    '$discountPercent% off',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                QuantitySelector(
                  quantity: quantity,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: context.colors.textTertiary,
            ),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
