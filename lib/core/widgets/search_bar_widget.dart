import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../theme/app_radius.dart';

/// Standard search input used on Store / Search / Category screens.
/// Purely presentational — filtering logic stays in the screen/bloc.
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool showClear;
  final VoidCallback? onFilterTap;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.showClear = false,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: AppRadius.smRadius,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(Icons.search_rounded, color: context.colors.textTertiary),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showClear)
                IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: onClear,
                ),
              if (onFilterTap != null)
                IconButton(
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: onFilterTap,
                ),
              const SizedBox(width: 4),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: AppRadius.smRadius,
            borderSide: BorderSide.none,
          ),
          isDense: true,
        ),
      ),
    );
  }
}
