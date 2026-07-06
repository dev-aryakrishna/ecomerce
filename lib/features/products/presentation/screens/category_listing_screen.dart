import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomerceapp/dependency_injection/injection.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/categories/categories_bloc.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/categories/categories_event.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/categories/categories_state.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/products/products_bloc.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/products/products_event.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/products/products_state.dart';
import 'package:ecomerceapp/router/route_names.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';
import 'package:ecomerceapp/core/themes/app_colors.dart';
import 'package:ecomerceapp/core/theme/app_spacing.dart';
import 'package:ecomerceapp/core/utils/category_icons.dart';
import 'package:ecomerceapp/core/widgets/widgets.dart';

/// Categories tab, restyled as a browsing hub: a persistent icon rail on
/// the left (every category, always visible, matching the reference
/// "All Categories" layout) and a content panel on the right that
/// previews real products for whichever category is selected — so
/// picking a category shows something useful immediately instead of
/// requiring a second navigation just to see if it's worth opening.
class CategoryListingScreen extends StatelessWidget {
  const CategoryListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<CategoriesBloc>()..add(FetchCategoriesRequested()),
      child: Scaffold(
        appBar: AppBarWidget(title: l10n.categories),
        body: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoriesLoaded) {
              if (state.categories.isEmpty) {
                return EmptyState(
                  icon: Icons.grid_view_rounded,
                  title: l10n.noProductsFound,
                );
              }
              return _CategoryBrowser(categories: state.categories);
            } else if (state is CategoriesError) {
              return ErrorStateWidget(
                title: l10n.errorUnknown,
                message: state.message,
                retryLabel: l10n.retry,
                onRetry: () => context
                    .read<CategoriesBloc>()
                    .add(FetchCategoriesRequested()),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _CategoryBrowser extends StatefulWidget {
  final List<String> categories;
  const _CategoryBrowser({required this.categories});

  @override
  State<_CategoryBrowser> createState() => _CategoryBrowserState();
}

class _CategoryBrowserState extends State<_CategoryBrowser> {
  late String _selected = widget.categories.first;
  late final ProductsBloc _previewBloc;

  @override
  void initState() {
    super.initState();
    _previewBloc = sl<ProductsBloc>()
      ..add(FetchProductsByCategoryRequested(_selected));
  }

  @override
  void dispose() {
    _previewBloc.close();
    super.dispose();
  }

  void _select(String category) {
    if (category == _selected) return;
    setState(() => _selected = category);
    _previewBloc.add(FetchProductsByCategoryRequested(category));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _previewBloc,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CategoryRail(
            categories: widget.categories,
            selected: _selected,
            onSelect: _select,
          ),
          Expanded(
            child: _CategoryPreviewPanel(category: _selected),
          ),
        ],
      ),
    );
  }
}

/// Left-hand vertical rail — always visible, mirrors the reference
/// screenshot's full-height category list.
class _CategoryRail extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  const _CategoryRail({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      color: context.colors.surfaceAlt,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selected;
          return InkWell(
            onTap: () => onSelect(category),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? context.colors.surface : Colors.transparent,
                border: Border(
                  left: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        isSelected ? AppColors.primary : context.colors.surface,
                    child: Icon(
                      iconForCategory(category),
                      size: 20,
                      color: isSelected ? Colors.white : context.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _label(category),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primaryDark : context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _label(String category) {
    final words = category.replaceAll('-', ' ').split(' ');
    return words.map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1)).join(' ');
  }
}

/// Right-hand content panel: a header for the selected category plus a
/// live preview grid of its products.
class _CategoryPreviewPanel extends StatelessWidget {
  final String category;
  const _CategoryPreviewPanel({required this.category});

  String _label(String category) {
    final words = category.replaceAll('-', ' ').split(' ');
    return words.map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1)).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _label(category),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              TextButton(
                onPressed: () => context.push(RouteNames.categoryProducts, extra: category),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text (l10n.viewAll),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoading) {
                return const ProductGridSkeleton();
              } else if (state is ProductsLoaded) {
                if (state.products.isEmpty) {
                  return EmptyState(icon: Icons.inventory_2_outlined, title: l10n.noProductsFound);
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.sm, 0, AppSpacing.md, AppSpacing.md),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.62,
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
                      onTap: () => context.push(RouteNames.productDetail, extra: product.id),
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
              } else if (state is ProductsEmpty) {
                return EmptyState(icon: Icons.inventory_2_outlined, title: l10n.noProductsFound);
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
