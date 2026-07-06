import 'package:flutter/material.dart';

/// Standard app bar used across screens so title style, back button, and
/// action spacing stay consistent. Wraps [AppBar] rather than reinventing
/// it, picking up all styling from [AppTheme.appBarTheme].
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      centerTitle: centerTitle,
      actions: actions == null
          ? null
          : [...actions!, const SizedBox(width: 8)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
