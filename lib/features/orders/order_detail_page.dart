import 'package:bulk_order_frontend/core/design_system/app_colors.dart';
import 'package:bulk_order_frontend/core/design_system/app_tokens.dart';
import 'package:bulk_order_frontend/core/constants/string_constants.dart';
import 'package:bulk_order_frontend/shared/widgets/app_badge.dart';
import 'package:bulk_order_frontend/shared/widgets/app_button.dart';
import 'package:bulk_order_frontend/shared/widgets/cycle_rail.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.orderId});
  final String orderId;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: AppColors.paper,
      surfaceTintColor: Colors.transparent,
      title: Text(
        '${StringConstants.orderNumberPrefix}$orderId',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: AppSpace.x4),
          child: Center(
            child: AppBadge(StringConstants.pooling, tone: AppBadgeTone.brand),
          ),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(AppSpace.x5),
      children: [
        const Text(
          StringConstants.orderDetailTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpace.x1),
        const Text(StringConstants.orderDetailDescription),
        const SizedBox(height: AppSpace.x7),
        const CycleRail(currentStage: CycleStage.pooling),
        const SizedBox(height: AppSpace.x7),
        const _DetailCard(
          title: StringConstants.whatHappensNext,
          child: Text(StringConstants.nextStepMessage),
        ),
        const SizedBox(height: AppSpace.x4),
        const _DetailCard(
          title: StringConstants.yourPledge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(StringConstants.yourPledge),
              SizedBox(height: 8),
              Text(
                StringConstants.estimatedTotal,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.x5),
        AppButton(
          label: StringConstants.changeOrder,
          style: AppButtonStyle.ghost,
          expand: true,
          onPressed: () {},
        ),
      ],
    ),
  );
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpace.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpace.x2),
          child,
        ],
      ),
    ),
  );
}
