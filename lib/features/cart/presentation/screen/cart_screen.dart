import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_state.dart';
import 'package:ecomerceapp/router/route_names.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';
import 'package:ecomerceapp/core/themes/app_colors.dart';
import 'package:ecomerceapp/core/theme/app_spacing.dart';
import 'package:ecomerceapp/core/theme/app_shadows.dart';
import 'package:ecomerceapp/core/widgets/widgets.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCartRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBarWidget(title: l10n.cart),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading || state is CartInitial) {
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, __) => ShimmerBox(
                width: double.infinity,
                height: 96,
                radius: BorderRadius.circular(14),
              ),
            );
          } else if (state is CartEmpty) {
            return EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: l10n.emptyCart,
              actionLabel: l10n.store,
              onActionTap: () => context.go(RouteNames.store),
            );
          } else if (state is CartLoaded) {
            final itemCount = state.item.fold<int>(0, (sum, i) => sum + i.quantity);
            final totalSavings = state.item.fold<double>(0, (sum, i) => sum + i.savings);
            final totalOriginal = state.item.fold<double>(
              0,
              (sum, i) => sum + ((i.originalPrice ?? i.price) * i.quantity),
            );

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: state.item.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = state.item[index];
                      return CartItemWidget(
                        name: item.productName,
                        imageUrl: item.productImage,
                        price: item.price,
                        quantity: item.quantity,
                        originalPrice: item.originalPrice,
                        onIncrement: () {
                          context.read<CartBloc>().add(
                                UpdateQuantityRequested(
                                  item.productId,
                                  item.quantity + 1,
                                ),
                              );
                        },
                        onDecrement: () {
                          if (item.quantity > 1) {
                            context.read<CartBloc>().add(
                                  UpdateQuantityRequested(
                                    item.productId,
                                    item.quantity - 1,
                                  ),
                                );
                          } else {
                            context.read<CartBloc>().add(
                                  RemoveFromCartRequested(item.productId),
                                );
                          }
                        },
                        onRemove: () {
                          context
                              .read<CartBloc>()
                              .add(RemoveFromCartRequested(item.productId));
                        },
                      );
                    },
                  ),
                ),
                _OrderSummaryBar(
                  itemCount: itemCount,
                  originalTotal: totalOriginal,
                  savings: totalSavings,
                  total: state.totalPrice,
                  onCheckout: () => context.push(RouteNames.checkout),
                ),
              ],
            );
          } else if (state is CartError) {
            return ErrorStateWidget(
              title: l10n.errorUnknown,
              message: state.message,
              retryLabel: l10n.retry,
              onRetry: () => context.read<CartBloc>().add(LoadCartRequested()),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}


class _OrderSummaryBar extends StatelessWidget {
  final int itemCount;
  final double originalTotal;
  final double savings;
  final double total;
  final VoidCallback onCheckout;

  const _OrderSummaryBar({
    required this.itemCount,
    required this.originalTotal,
    required this.savings,
    required this.total,
    required this.onCheckout,
  });

  String _fmt(double v) => '\$${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: AppShadows.raised,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (savings > 0)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer_rounded, size: 15, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text(
                    'You save ${_fmt(savings)} on this order!',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Price ($itemCount items)', style: TextStyle(color: context.colors.textSecondary)),
              Text(_fmt(originalTotal)),
            ],
          ),
          if (savings > 0) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discount', style: TextStyle(color: context.colors.textSecondary)),
                Text('-${_fmt(savings)}', style: const TextStyle(color: AppColors.success)),
              ],
            ),
          ],
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery', style: TextStyle(color: context.colors.textSecondary)),
              const Text('FREE', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${l10n.totalAmount}:', style: Theme.of(context).textTheme.titleLarge),
              PriceWidget(price: total, fontSize: 20, color: AppColors.primaryDark),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: l10n.proceedToCheckout,
            onPressed: onCheckout,
          ),
        ],
      ),
    );
  }
}
