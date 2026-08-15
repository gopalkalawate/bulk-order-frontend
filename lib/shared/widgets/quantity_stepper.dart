import 'package:bulk_order_frontend/core/design_system/app_colors.dart';
import 'package:bulk_order_frontend/core/design_system/app_tokens.dart';
import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.minimum = 0,
  });
  final int value;
  final int minimum;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Container(
    height: 36,
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.ink200),
      borderRadius: BorderRadius.circular(AppRadius.medium),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _button(
          Icons.remove,
          value > minimum ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 34,
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        _button(Icons.add, () => onChanged(value + 1)),
      ],
    ),
  );
  Widget _button(IconData icon, VoidCallback? onPressed) => IconButton(
    onPressed: onPressed,
    icon: Icon(icon, size: 16),
    visualDensity: VisualDensity.compact,
    color: AppColors.ink900,
    style: IconButton.styleFrom(
      backgroundColor: AppColors.ink100,
      shape: const RoundedRectangleBorder(),
    ),
  );
}
