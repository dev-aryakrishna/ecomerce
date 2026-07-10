import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import 'price_widget.dart';
import 'rating_widget.dart';
import 'package:ecomerceapp/core/utils/price_calculation.dart';

/// The single source of truth for how a product looks in a grid — Store,
/// Category, Search, and Wishlist should all use this instead of building
/// their own `Card`.
class ProductCard extends StatelessWidget {
  final String title;
  final String category;
  final String imageUrl;
  final double price;
  final double rating;
  final VoidCallback onTap;
  final VoidCallback? onWishlistTap;
  final bool isWishlisted;
  /// 0–100. When > 0, shows a "-X%" ribbon on the image and the
  /// pre-discount price struck through next to the current price.
  final double discountPercentage;

  const ProductCard({
    super.key,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.onTap,
    this.onWishlistTap,
    this.isWishlisted = false,
    this.discountPercentage = 0,
  });

  double? get _originalPrice => PriceCalculation.originalPriceForm(
    price: price, 
    discountPercentage: discountPercentage
    );
      
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      borderRadius: AppRadius.mdRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdRadius,
            border: Border.all(color: context.colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _ProductImage(imageUrl: imageUrl),
                    if (discountPercentage > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: _DiscountRibbon(percentage: discountPercentage),
                      ),
                    if (onWishlistTap != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _WishlistBadge(
                          filled: isWishlisted,
                          onTap: onWishlistTap!,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                    ),
                    if (category.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11.5, color: context.colors.textTertiary),
                      ),
                    ],
                    const SizedBox(height: 6),
                    PriceWidget(
                      price: price,
                      originalPrice: _originalPrice,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (discountPercentage > 0)
                          Text(
                            '${discountPercentage.round()}% off',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        RatingWidget(rating: rating),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscountRibbon extends StatelessWidget {
  final double percentage;
  const _DiscountRibbon({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: AppRadius.xsRadius,
        boxShadow: AppShadows.low,
      ),
      child: Text(
        '${percentage.round()}%',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;
  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        color: context.colors.surfaceAlt,
        child: Icon(Icons.image_not_supported_rounded, color: context.colors.textTertiary),
      );
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(color: context.colors.surfaceAlt);
      },
      errorBuilder: (_, __, ___) => Container(
        color: context.colors.surfaceAlt,
        child: Icon(Icons.broken_image_rounded, color: context.colors.textTertiary),
      ),
    );
  }
}

class _WishlistBadge extends StatelessWidget {
  final bool filled;
  final VoidCallback onTap;
  const _WishlistBadge({required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppShadows.low,
          ),
          child: Icon(
            filled ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 16,
            color: filled ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
