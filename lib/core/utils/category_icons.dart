import 'package:flutter/material.dart';


IconData iconForCategory(String category) {
  final key = category.toLowerCase();
  for (final entry in _iconsByKeyword.entries) {
    if (key.contains(entry.key)) return entry.value;
  }
  return Icons.shopping_bag_rounded;
}

const Map<String, IconData> _iconsByKeyword = {
  'smartphone': Icons.smartphone_rounded,
  'mobile': Icons.smartphone_rounded,
  'laptop': Icons.laptop_mac_rounded,
  'tablet': Icons.tablet_mac_rounded,
  'watch': Icons.watch_rounded,
  'fragrance': Icons.local_florist_rounded,
  'perfume': Icons.local_florist_rounded,
  'skin': Icons.spa_rounded,
  'beauty': Icons.brush_rounded,
  'furniture': Icons.chair_rounded,
  'home-decoration': Icons.chair_rounded,
  'kitchen': Icons.kitchen_rounded,
  'grocer': Icons.local_grocery_store_rounded,
  'shirt': Icons.checkroom_rounded,
  'shoe': Icons.hiking_rounded,
  'dress': Icons.checkroom_rounded,
  'top': Icons.checkroom_rounded,
  'jewellery': Icons.diamond_rounded,
  'jewelry': Icons.diamond_rounded,
  'sunglasses': Icons.visibility_rounded,
  'motorcycle': Icons.two_wheeler_rounded,
  'vehicle': Icons.directions_car_rounded,
  'automotive': Icons.directions_car_rounded,
  'bag': Icons.shopping_bag_rounded,
  'sport': Icons.sports_basketball_rounded,
};
