class OrderEntity {
  final String orderId;
  final List<Map<String, dynamic>> products;
  final double totalAmount;
  final String orderDate;
  final String orderStatus;

  const OrderEntity({
    required this.orderId,
    required this.products,
    required this.totalAmount,
    required this.orderDate,
    required this.orderStatus,
  });
}