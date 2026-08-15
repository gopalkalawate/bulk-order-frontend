import 'package:bulk_order_frontend/core/design_system/app_colors.dart';
import 'package:bulk_order_frontend/core/design_system/app_tokens.dart';
import 'package:flutter/material.dart';

enum AppButtonStyle { primary, secondary, ghost, dangerGhost }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = AppButtonStyle.primary,
    this.icon,
    this.expand = false,
    this.small = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final IconData? icon;
  final bool expand;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, border) = switch (style) {
      AppButtonStyle.primary => (
        AppColors.brand600,
        AppColors.surface,
        Colors.transparent,
      ),
      AppButtonStyle.secondary => (
        AppColors.surface,
        AppColors.brand600,
        AppColors.brand600,
      ),
      AppButtonStyle.ghost => (
        Colors.transparent,
        AppColors.ink700,
        AppColors.ink200,
      ),
      AppButtonStyle.dangerGhost => (
        Colors.transparent,
        AppColors.danger600,
        AppColors.danger100,
      ),
    };
    return SizedBox(
      width: expand ? double.infinity : null,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: AppColors.ink200,
          disabledForegroundColor: AppColors.ink400,
          elevation: 0,
          minimumSize: Size(0, small ? 34 : 44),
          padding: EdgeInsets.symmetric(horizontal: small ? 12 : 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              small ? AppRadius.small : AppRadius.medium,
            ),
            side: BorderSide(color: border),
          ),
        ),
      ),
    );
  }
}
