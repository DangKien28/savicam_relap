import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.saviBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: leading,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}