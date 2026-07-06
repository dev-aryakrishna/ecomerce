import 'package:flutter/material.dart';


class AppShadows {
  AppShadows._();

  static List<BoxShadow> get none => const [];

  static List<BoxShadow> get low => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get raised => [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> coloredButton(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.28),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
}
