import 'package:flutter/material.dart';
import 'package:ecomerceapp/core/themes/app_colors.dart';
import 'package:ecomerceapp/core/utils/category_icons.dart';


class CategoryQuickAccess extends StatelessWidget {
  final List<String> categories;
  final ValueChanged<String> onCategoryTap;

  const CategoryQuickAccess({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 92,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () => onCategoryTap(category),
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 64,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(
                        iconForCategory(category),
                        color: AppColors.primaryDark,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _label(category),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: context.colors.textSecondary),
                    ),
                  ],
                ),
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
