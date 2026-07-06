import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomerceapp/dependency_injection/injection.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_state.dart';
import 'package:ecomerceapp/features/orders/domain/entities/order_entity.dart';
import 'package:ecomerceapp/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:ecomerceapp/features/orders/presentation/bloc/orders_event.dart';
import 'package:ecomerceapp/features/orders/presentation/bloc/orders_state.dart';
import 'package:ecomerceapp/core/utils/notification_service.dart';
import 'package:ecomerceapp/router/route_names.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<OrdersBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.checkout)),
        body: BlocConsumer<OrdersBloc, OrdersState>(
          listener: (context, state) async {
            if (state is OrderCreated) {
              // Clear cart
              context.read<CartBloc>().add(ClearCartRequested());
              // Show notification with the actual order's id and total
              await sl<NotificationService>().showOrderSuccessNotification(
                orderId: state.order.orderId,
                totalAmount: state.order.totalAmount,
              );
              // Navigate to orders
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${l10n.orderSuccess} 🎉')),
              );
              context.go(RouteNames.orders);
            } else if (state is OrdersError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, ordersState) {
            return BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                if (cartState is CartLoaded) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Text(
                              l10n.orderSummary,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...cartState.item.map(
                              (item) => ListTile(
                                leading: Image.network(
                                  item.productImage,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(item.productName),
                                subtitle: Text('${l10n.qtyLabel}: ${item.quantity}'),
                                trailing: Text(
                                  '\$${item.totalPrice.toStringAsFixed(2)}',
                                ),
                              ),
                            ),
                            const Divider(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${l10n.total}:',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${cartState.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ordersState is OrdersLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  final order = OrderEntity(
                                    orderId: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    products: cartState.item
                                        .map((item) => {
                                              'productId': item.productId,
                                              'productName': item.productName,
                                              'price': item.price,
                                              'quantity': item.quantity,
                                            })
                                        .toList(),
                                    totalAmount: cartState.totalPrice,
                                    orderDate:
                                        DateTime.now().toIso8601String(),
                                    orderStatus: 'pending',
                                  );
                                  context.read<OrdersBloc>().add(
                                        CreateOrderRequested(order),
                                      );
                                },
                                child: Text(l10n.placeOrder),
                              ),
                      ),
                    ],
                  );
                } else if (cartState is CartEmpty) {
                  return Center(child: Text(l10n.emptyCart));
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      ),
    );
  }
}