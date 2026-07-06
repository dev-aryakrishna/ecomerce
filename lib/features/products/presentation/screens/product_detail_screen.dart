import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomerceapp/dependency_injection/injection.dart';
import 'package:ecomerceapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/product_detail/product_detail_bloc.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/product_detail/product_detail_event.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/product_detail/product_detail_state.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  final PageController _galleryController = PageController();
  int _galleryIndex = 0;

  @override
  void dispose() {
    _galleryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<ProductDetailBloc>()
        ..add(FetchProductDetailRequested(widget.productId)),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.productDetailTitle)),
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductDetailLoaded) {
              final product = state.product;
              // Fall back to the thumbnail if the product has no gallery
              // images, so the carousel always has something to show.
              final gallery =
                  product.images.isNotEmpty ? product.images : [product.thumbnail];
              final inStock = product.stock > 0;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image carousel / gallery
                    SizedBox(
                      height: 250,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView.builder(
                            controller: _galleryController,
                            itemCount: gallery.length,
                            onPageChanged: (i) =>
                                setState(() => _galleryIndex = i),
                            itemBuilder: (context, i) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  gallery[i],
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.broken_image,
                                        size: 48, color: Colors.grey),
                                  ),
                                ),
                              );
                            },
                          ),
                          if (gallery.length > 1)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  gallery.length,
                                  (i) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _galleryIndex == i
                                          ? Colors.purple
                                          : Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (product.discountPercentage > 0) ...[
                          Text(
                            '\$${(product.price / (1 - product.discountPercentage / 100)).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.purple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (product.discountPercentage > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${product.discountPercentage.toStringAsFixed(0)}% off',
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text('${product.rating}'),
                        const SizedBox(width: 16),
                        Icon(
                          inStock ? Icons.check_circle : Icons.cancel,
                          size: 16,
                          color: inStock ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          inStock
                              ? '${l10n.stock} (${product.stock})'
                              : l10n.outOfStock,
                          style: TextStyle(
                            color: inStock ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (product.category.isNotEmpty)
                      Text('${l10n.categoryLabel}: ${product.category}'),
                    const SizedBox(height: 12),
                    if (product.description.isNotEmpty) Text(product.description),
                    const SizedBox(height: 24),

                    // Quantity selector
                    Row(
                      children: [
                        Text(
                          l10n.quantity,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: (!inStock || _quantity >= product.stock)
                              ? null
                              : () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: !inStock
                            ? null
                            : () {
                                context.read<CartBloc>().add(
                                      AddToCartRequested(
                                        CartItemEntity(
                                          productId: product.id,
                                          productName: product.title,
                                          price: product.price,
                                          productImage: product.thumbnail,
                                          quantity: _quantity,
                                          originalPrice: product.discountPercentage > 0
                                              ? product.price /
                                                  (1 - product.discountPercentage / 100)
                                              : null,
                                        ),
                                      ),
                                    );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.addedToCartSnackbar),
                                  ),
                                );
                              },
                        child: Text(inStock ? l10n.addToCart : l10n.outOfStock),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProductDetailError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}