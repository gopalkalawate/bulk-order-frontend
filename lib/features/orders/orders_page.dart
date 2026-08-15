import 'package:bulk_order_frontend/core/constants/string_constants.dart';
import 'package:bulk_order_frontend/core/design_system/app_tokens.dart';
import 'package:bulk_order_frontend/core/router/app_router.dart';
import 'package:bulk_order_frontend/features/orders/bloc/orders_bloc.dart';
import 'package:bulk_order_frontend/features/shared/data/api_repository.dart';
import 'package:bulk_order_frontend/shared/widgets/app_page.dart';
import 'package:bulk_order_frontend/shared/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => OrdersBloc(context.read<ApiRepository>())..load(),
    child: const _OrdersView(),
  );
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();
  @override
  Widget build(BuildContext context) => AppPage(
    title: StringConstants.orders,
    subtitle: StringConstants.trackOrders,
    children: [
      const SectionLabel(StringConstants.active),
      BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) => switch (state) {
          OrdersLoading() => const AppListShimmer(count: 2),
          OrdersFailure(:final message) => Text(message),
          OrdersLoaded(:final orders) =>
            orders.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(AppSpace.x4),
                    child: Text(StringConstants.noOrdersMessage),
                  )
                : Column(
                    children: orders
                        .map((order) => _order(context, order))
                        .toList(),
                  ),
        },
      ),
    ],
  );
  Widget _order(BuildContext context, Map<String, dynamic> order) {
    final id = order['id'].toString();
    return Card(
      child: ListTile(
        title: Text('${StringConstants.orderNumberPrefix}$id'),
        subtitle: Text(order['status']?.toString() ?? StringConstants.pooling),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.goNamed(
          AppRoutes.orderDetail,
          pathParameters: {StringConstants.routeParameterId: id},
        ),
      ),
    );
  }
}
