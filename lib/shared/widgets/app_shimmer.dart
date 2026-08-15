import 'package:bulk_order_frontend/core/design_system/app_colors.dart';
import 'package:bulk_order_frontend/core/design_system/app_tokens.dart';
import 'package:flutter/material.dart';

class AppShimmer extends StatefulWidget {
  const AppShimmer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.radius = AppRadius.small,
  });
  final double width;
  final double height;
  final double radius;
  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, child) => Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        gradient: LinearGradient(
          begin: Alignment(-1.0 + (_controller.value * 2), 0),
          end: Alignment(_controller.value * 2, 0),
          colors: const [AppColors.ink100, AppColors.ink200, AppColors.ink100],
        ),
      ),
    ),
  );
}

class AppListShimmer extends StatelessWidget {
  const AppListShimmer({super.key, this.count = 3});
  final int count;
  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(
      count,
      (_) => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpace.x3),
        child: Row(
          children: [
            AppShimmer(width: 58, height: 58, radius: AppRadius.medium),
            SizedBox(width: AppSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmer(width: 180, height: 14),
                  SizedBox(height: AppSpace.x2),
                  AppShimmer(width: 110, height: 12),
                  SizedBox(height: AppSpace.x3),
                  AppShimmer(width: 90, height: 12),
                ],
              ),
            ),
            SizedBox(width: AppSpace.x2),
            AppShimmer(width: 52, height: 34, radius: AppRadius.small),
          ],
        ),
      ),
    ),
  );
}
