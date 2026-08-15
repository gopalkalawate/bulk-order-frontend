import 'package:bulk_order_frontend/core/design_system/app_colors.dart';
import 'package:bulk_order_frontend/core/design_system/app_tokens.dart';
import 'package:flutter/material.dart';

enum AppBadgeTone { success, amber, danger, neutral, brand }

class AppBadge extends StatelessWidget {
  const AppBadge(this.label, {super.key, this.tone = AppBadgeTone.neutral});
  final String label;
  final AppBadgeTone tone;
  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      AppBadgeTone.success => (AppColors.success100, AppColors.success700),
      AppBadgeTone.amber => (AppColors.amber100, AppColors.amber700),
      AppBadgeTone.danger => (AppColors.danger100, AppColors.danger700),
      AppBadgeTone.neutral => (AppColors.ink100, AppColors.ink700),
      AppBadgeTone.brand => (AppColors.brand100, AppColors.brand700),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colors.$2,
        ),
      ),
    );
  }
}
