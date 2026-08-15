import 'package:bulk_order_frontend/core/design_system/app_colors.dart';
import 'package:bulk_order_frontend/core/router/app_router.dart';
import 'package:bulk_order_frontend/core/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child, required this.location});
  final Widget child;
  final String location;
  @override
  Widget build(BuildContext context) {
    const destinations = [
      (Icons.storefront_outlined, StringConstants.store, AppRoutes.catalog),
      (Icons.shopping_cart_outlined, StringConstants.cart, AppRoutes.cart),
      (Icons.inventory_2_outlined, StringConstants.orders, AppRoutes.orders),
      (Icons.person_outline, StringConstants.profile, AppRoutes.profile),
    ];
    final index = destinations.indexWhere(
      (item) => location.startsWith(item.$3),
    );
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index < 0 ? 0 : index,
        onDestinationSelected: (value) => context.go(destinations[value].$3),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.brand100,
        destinations: [
          for (final item in destinations)
            NavigationDestination(
              icon: Icon(item.$1),
              selectedIcon: Icon(item.$1, color: AppColors.brand600),
              label: item.$2,
            ),
        ],
      ),
    );
  }
}
