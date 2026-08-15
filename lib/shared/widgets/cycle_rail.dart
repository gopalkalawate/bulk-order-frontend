import 'package:bulk_order_frontend/core/design_system/app_colors.dart';
import 'package:bulk_order_frontend/core/constants/string_constants.dart';
import 'package:flutter/material.dart';

enum CycleStage { pooling, bidding, invoiced, paid, delivery }

extension CycleStageLabel on CycleStage {
  String get label => switch (this) {
    CycleStage.pooling => StringConstants.pooling,
    CycleStage.bidding => StringConstants.bidding,
    CycleStage.invoiced => StringConstants.invoice,
    CycleStage.paid => StringConstants.paid,
    CycleStage.delivery => StringConstants.delivery,
  };
}

class CycleRail extends StatelessWidget {
  const CycleRail({super.key, required this.currentStage});
  final CycleStage currentStage;
  @override
  Widget build(BuildContext context) {
    final current = CycleStage.values.indexOf(currentStage);
    return Row(
      children: List.generate(CycleStage.values.length, (index) {
        final stage = CycleStage.values[index];
        final done = index < current;
        final selected = index == current;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 1,
                        color: done || selected
                            ? AppColors.brand600
                            : AppColors.ink200,
                      ),
                    ),
                  Container(
                    width: selected ? 11 : 9,
                    height: selected ? 11 : 9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done || selected
                          ? AppColors.brand600
                          : AppColors.ink200,
                      boxShadow: selected
                          ? const [
                              BoxShadow(
                                color: AppColors.brand100,
                                spreadRadius: 3,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  if (index < CycleStage.values.length - 1)
                    Expanded(
                      child: Container(
                        height: 1,
                        color: done ? AppColors.brand600 : AppColors.ink200,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                stage.label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? AppColors.brand700
                      : done
                      ? AppColors.ink700
                      : AppColors.ink400,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
