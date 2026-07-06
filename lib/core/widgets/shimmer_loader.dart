import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_durations.dart';

/// Self-contained shimmer effect (no third-party package required).
/// Wrap any placeholder shape in this to get a moving highlight sweep.
class ShimmerLoader extends StatefulWidget {
  final Widget child;

  const ShimmerLoader({super.key, required this.child});

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.shimmer,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.colors.shimmerBase;
    final highlight = context.colors.shimmerHighlight;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final t = _controller.value;
            return LinearGradient(
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
              begin: Alignment(-1 - t * 2, 0),
              end: Alignment(1 - t * 2 + 1, 0),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A plain rectangular/rounded shimmer block — the basic building unit for
/// skeleton screens (a title bar, an image placeholder, a line of text...).
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? radius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height = 16,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.colors.shimmerBase,
          borderRadius: radius ?? AppRadius.xsRadius,
        ),
      ),
    );
  }
}

/// Skeleton placeholder shaped like a [ProductCard], used while product
/// grids are loading.
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: context.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: ShimmerBox(width: double.infinity, height: double.infinity, radius: BorderRadius.zero),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: double.infinity, height: 13),
                const SizedBox(height: 8),
                ShimmerBox(width: 60, height: 11),
                const SizedBox(height: 10),
                ShimmerBox(width: 50, height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid of [ProductCardSkeleton] matching the real product grid layout.
class ProductGridSkeleton extends StatelessWidget {
  final int itemCount;

  const ProductGridSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.64,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ProductCardSkeleton(),
    );
  }
}
