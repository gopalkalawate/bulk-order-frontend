import 'package:bulk_order_frontend/core/constants/string_constants.dart';
import 'package:bulk_order_frontend/core/design_system/app_colors.dart';
import 'package:bulk_order_frontend/core/design_system/app_tokens.dart';
import 'package:bulk_order_frontend/core/router/app_router.dart';
import 'package:bulk_order_frontend/features/cart/bloc/cart_bloc.dart';
import 'package:bulk_order_frontend/features/shared/data/api_repository.dart';
import 'package:bulk_order_frontend/shared/widgets/app_button.dart';
import 'package:bulk_order_frontend/shared/widgets/app_page.dart';
import 'package:bulk_order_frontend/shared/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) =>
        CartBloc(context.read<ApiRepository>())
          ..add(const CurrentCycleCartRequested()),
    child: const _CartView(),
  );
}

class _CartView extends StatelessWidget {
  const _CartView();
  @override
  Widget build(BuildContext context) => AppPage(
    title: StringConstants.yourCart,
    subtitle: StringConstants.cartChangeMessage,
    children: [
      const SectionLabel(StringConstants.currentCycle),
      BlocBuilder<CartBloc, CartState>(
        builder: (context, state) => switch (state) {
          CartInitial() || CartLoading() => const AppListShimmer(count: 1),
          CartFailure(:final message) => Text(message),
          CartLoaded(:final cart) => _cartContent(context, cart),

          CartCheckoutSuccess(:final order) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpace.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        StringConstants.finalOrderPlaced,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpace.x2),
                      if (order['id'] != null)
                        Text('${StringConstants.orderNumberPrefix} ${order['id']}'),
                      const SizedBox(height: AppSpace.x4),
                      AppButton(
                        label: StringConstants.orders,
                        expand: true,
                        onPressed: () => context.go(AppRoutes.orders),
                      ),
                    ],
                  ),
                ),
              ),
        },
      ),
      const SizedBox(height: AppSpace.x5),
      _protection(),
    ],
  );
  Widget _cartContent(BuildContext context, Map<String, dynamic> cart) {
    final items = (cart['items'] as List? ?? []);
    final cycleId = (cart['cycle_id'] as num?)?.toInt() ?? 0;
    if (items.isNotEmpty) {
      return Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpace.x4),
              child: Column(
                children: items
                    .map(
                      (item) => _cartItem(
                        context,
                        cycleId,
                        Map<String, dynamic>.from(item as Map),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.x4),
          AppButton(
            label: StringConstants.placeFinalOrder,
            expand: true,
            onPressed: cycleId == 0
                ? null
                : () => context
                    .read<CartBloc>()
                    .add(CartCheckoutRequested(cycleId)),
          ),
        ],
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              StringConstants.noItemsInCart,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpace.x2),
            const Text(StringConstants.cartEmptyMessage),
            const SizedBox(height: AppSpace.x4),
            AppButton(
              label: StringConstants.browseStore,
              expand: true,
              onPressed: () => context.go(AppRoutes.catalog),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartItem(
    BuildContext context,
    int cycleId,
    Map<String, dynamic> item,
  ) {
    final itemId = (item['item_id'] as num?)?.toInt() ?? 0;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('${StringConstants.item} #$itemId'),
      subtitle: Text('${StringConstants.quantity}: ${item['quantity']}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: AppColors.danger600),
            tooltip: StringConstants.remove,
            onPressed: cycleId == 0
                ? null
                : () {
                    final qty = (item['quantity'] as num?)?.toInt() ??
                        int.tryParse(item['quantity']?.toString() ?? '') ?? 0;
                    final newQty = qty - 1;
                    if (newQty <= 0) {
                      context.read<CartBloc>().add(
                            CartItemRemoved(cycleId: cycleId, itemId: itemId),
                          );
                    } else {
                      context.read<CartBloc>().add(
                            CartItemQuantityUpdated(
                              cycleId: cycleId,
                              itemId: itemId,
                              quantity: newQty.toString(),
                            ),
                          );
                    }
                  },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('${item['quantity']}', style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: StringConstants.add,
            onPressed: cycleId == 0
                ? null
                : () {
                    final qty = (item['quantity'] as num?)?.toInt() ??
                        int.tryParse(item['quantity']?.toString() ?? '') ?? 0;
                    final newQty = qty + 1;
                    context.read<CartBloc>().add(
                          CartItemQuantityUpdated(
                            cycleId: cycleId,
                            itemId: itemId,
                            quantity: newQty.toString(),
                          ),
                        );
                  },
          ),
        ],
      ),
    );
  }

  Widget _protection() => Container(
    padding: const EdgeInsets.all(AppSpace.x3),
    decoration: BoxDecoration(
      color: AppColors.success100,
      border: Border.all(color: const Color(0xFFBFE3D0)),
      borderRadius: BorderRadius.circular(AppRadius.medium),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.verified_user_outlined, color: AppColors.success700),
        SizedBox(width: AppSpace.x2),
        Expanded(
          child: Text(
            StringConstants.priceProtection,
            style: TextStyle(
              color: AppColors.success700,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}
