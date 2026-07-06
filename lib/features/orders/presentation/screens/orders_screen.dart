import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomerceapp/dependency_injection/injection.dart';
import 'package:ecomerceapp/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:ecomerceapp/features/orders/presentation/bloc/orders_event.dart';
import 'package:ecomerceapp/features/orders/presentation/bloc/orders_state.dart';
import 'package:ecomerceapp/features/orders/domain/entities/order_entity.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<OrdersBloc>()..add(LoadOrdersRequested()),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.orders)),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrdersEmpty) {
              return Center(child: Text(l10n.emptyOrders));
            } else if (state is OrdersLoaded) {
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return InkWell(
                    onTap: () => _showOrderDetails(context, l10n, order),
                    child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${l10n.orderHashPrefix}${order.orderId.substring(order.orderId.length - 6)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  order.orderStatus.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.purple,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l10n.dateLabel}: ${order.orderDate.substring(0, 10)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l10n.itemsLabel}: ${order.products.length}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l10n.total}: \$${order.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                },
              );
            } else if (state is OrdersError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

void _showOrderDetails(
  BuildContext context,
  AppLocalizations l10n,
  OrderEntity order,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.orderDetails,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(sheetContext).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.orderHashPrefix}${order.orderId.substring(order.orderId.length - 6)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  '${l10n.dateLabel}: ${order.orderDate.substring(0, 10)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                const Divider(),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: order.products.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = order.products[index];
                      final price = (item['price'] as num?)?.toDouble() ?? 0;
                      final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item['productName']?.toString() ?? ''),
                        subtitle: Text('${l10n.qtyLabel}: $quantity'),
                        trailing: Text(
                          '\$${(price * quantity).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${l10n.total}:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


