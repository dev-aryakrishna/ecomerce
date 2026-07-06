import 'package:ecomerceapp/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomerceapp/dependency_injection/injection.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/products/products_bloc.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/products/products_event.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/products/products_state.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/categories/categories_bloc.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/categories/categories_event.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/categories/categories_state.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_state.dart';
import 'package:ecomerceapp/features/products/presentation/widgets/promo_banner_carousel.dart';
import 'package:ecomerceapp/features/products/presentation/widgets/category_quick_access.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';
import 'package:ecomerceapp/core/theme/app_spacing.dart';
import 'package:ecomerceapp/core/themes/app_colors.dart';
import 'package:ecomerceapp/core/widgets/widgets.dart';

class StoreListingScreen extends StatelessWidget {
  const StoreListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProductsBloc>()..add(FetchProductsRequested())),
        BlocProvider(create: (_) => sl<CategoriesBloc>()..add(FetchCategoriesRequested())),
      ],
      child: const _StoreListingView(),
    );
  }
}

class _StoreListingView extends StatefulWidget {
  const _StoreListingView();

  @override
  State<_StoreListingView> createState() => _StoreListingViewState();
}

class _StoreListingViewState extends State<_StoreListingView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _selectedCategory;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Only paginate the default (no search / no category filter) listing —
    // matches the bloc, which doesn't support pagination for those.
    if (_query.isNotEmpty || _selectedCategory != null) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductsBloc>().add(LoadMoreProductsRequested());
    }
  }

  void _applyFilter() {
    if (_query.isNotEmpty) {
      context.read<ProductsBloc>().add(SearchProductsRequested(_query));
    } else if (_selectedCategory != null) {
      context
          .read<ProductsBloc>()
          .add(FetchProductsByCategoryRequested(_selectedCategory!));
    } else {
      context.read<ProductsBloc>().add(FetchProductsRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: _query.isEmpty,
      onPopInvoked: (didPop){
        if (didPop) return;
        _searchController.clear();
        setState(() => _query = '');
        _applyFilter();
      },
      child: Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _StoreHeader(
              searchController: _searchController,
              query: _query,
              onQueryCleared: () {
                _searchController.clear();
                setState(() => _query = '');
                _applyFilter();
              },
              onSubmitted: (value) {
                setState(() => _query = value.trim());
                _applyFilter();
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() => _query = '');
                  _applyFilter();
                }
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<ProductsBloc>().add(RefreshProductsRequested());
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: BlocBuilder<CategoriesBloc, CategoriesState>(
                        builder: (context, catState) {
                          if (catState is! CategoriesLoaded || catState.categories.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              const SizedBox(height: AppSpacing.sm),
                              CategoryQuickAccess(
                                categories: catState.categories,
                                onCategoryTap: (category) => context.push(
                                  RouteNames.categoryProducts,
                                  extra: category,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              const PromoBannerCarousel(),
                              const SizedBox(height: AppSpacing.md),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                                child: SizedBox(
                                  height: 44,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      CategoryChip(
                                        label: l10n.allCategoriesLabel,
                                        selected: _selectedCategory == null,
                                        onTap: () {
                                          setState(() => _selectedCategory = null);
                                          _applyFilter();
                                        },
                                      ),
                                      for (final category in catState.categories)
                                        CategoryChip(
                                          label: category,
                                          selected: _selectedCategory == category,
                                          onTap: () {
                                            setState(() => _selectedCategory = category);
                                            _applyFilter();
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                                child: SectionHeader(
                                  title: _selectedCategory != null
                                      ? _selectedCategory!
                                      : (_query.isNotEmpty ? l10n.searchHint : l10n.store),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                            ],
                          );
                        },
                      ),
                    ),
                    BlocBuilder<ProductsBloc, ProductsState>(
                      builder: (context, state) {
                        if (state is ProductsLoading) {
                          return const SliverFillRemaining(
                            hasScrollBody: false,
                            child: ProductGridSkeleton(),
                          );
                        } else if (state is ProductsLoaded) {
                          return SliverPadding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.md, 0, AppSpacing.md, AppSpacing.md,
                            ),
                            sliver: SliverGrid(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.62,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index >= state.products.length) {
                                    return const ProductCardSkeleton();
                                  }
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
                                childCount: state.products.length + (state.isLoadingMore ? 2 : 0),
                              ),
                            ),
                          );
                        } else if (state is ProductsError) {
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: ErrorStateWidget(
                              title: l10n.errorNetwork,
                              message: l10n.checkConnection,
                              retryLabel: l10n.retry,
                              onRetry: _applyFilter,
                            ),
                          );
                        } else if (state is ProductsEmpty) {
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: EmptyState(
                              icon: Icons.search_off_rounded,
                              title: l10n.noProductsFound,
                            ),
                          );
                        }
                        return const SliverToBoxAdapter(child: SizedBox());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
     ), ),
    );
  }
}


class _StoreHeader extends StatelessWidget {
  final TextEditingController searchController;
  final String query;
  final VoidCallback onQueryCleared;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;

  const _StoreHeader({
    required this.searchController,
    required this.query,
    required this.onQueryCleared,
    required this.onSubmitted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storefront_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Text(
                  l10n.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    final count = state is CartLoaded
                        ? state.item.fold<int>(0, (sum, i) => sum + i.quantity)
                        : 0;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_rounded, color: Colors.white),
                          onPressed: () => context.go(RouteNames.cart),
                        ),
                        if (count > 0)
                          Positioned(
                            top: 6,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primaryDark, width: 1.5),
                              ),
                              child: Text(
                                count > 99 ? '99+' : '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SearchBarWidget(
                controller: searchController,
                hintText: l10n.searchHint,
                showClear: query.isNotEmpty,
                onClear: onQueryCleared,
                onSubmitted: onSubmitted,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
