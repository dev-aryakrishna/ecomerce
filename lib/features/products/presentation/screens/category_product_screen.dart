
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomerceapp/dependency_injection/injection.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomerceapp/router/route_names.dart';
import'package:ecomerceapp/features/products/presentation/bloc/products/products_bloc.dart';
import'package:ecomerceapp/features/products/presentation/bloc/products/products_event.dart';
import'package:ecomerceapp/features/products/presentation/bloc/products/products_state.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';
import 'package:ecomerceapp/core/theme/app_spacing.dart';
import 'package:ecomerceapp/core/widgets/widgets.dart';

class CategoryProductScreen extends StatelessWidget{
  
  final String category;

  const CategoryProductScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<ProductsBloc>()..add(FetchProductsByCategoryRequested(category)),
      child: Scaffold(
        appBar: AppBar(title: Text('${l10n.productsIn} $category')),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const ProductGridSkeleton();
            } else if (state is ProductsLoaded) {
              if (state.products.isEmpty) {
                return EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: l10n.noProductsFound,
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.6,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductCard(
                    title: product.title,
                    category: product.category,
                    imageUrl: product.thumbnail,
                    price: product.price,
                    rating: product.rating,
                    discountPercentage: product.discountPercentage,
                    onTap: () => context.push(
                      RouteNames.productDetail,
                      extra: product.id,
                    ),
                  );
                },
              );
            } else if (state is ProductsError) {
              return ErrorStateWidget(
                title: l10n.errorNetwork,
                message: l10n.checkConnection,
                retryLabel: l10n.retry,
                onRetry: () => context
                    .read<ProductsBloc>()
                    .add(FetchProductsByCategoryRequested(category)),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}