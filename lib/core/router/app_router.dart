import 'package:bulk_order_frontend/features/catalog/catalog_page.dart';
import 'package:bulk_order_frontend/features/cart/cart_page.dart';
import 'package:bulk_order_frontend/features/orders/order_detail_page.dart';
import 'package:bulk_order_frontend/features/orders/orders_page.dart';
import 'package:bulk_order_frontend/features/profile/profile_page.dart';
import 'package:bulk_order_frontend/shared/widgets/app_shell.dart';
import 'package:bulk_order_frontend/core/constants/string_constants.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const catalog = '/catalog';
  static const cart = '/cart';
  static const orders = '/orders';
  static const profile = '/profile';
  static const orderDetail = StringConstants.orderDetail;
}

abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.catalog,
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: AppRoutes.catalog,
            builder: (context, state) => const CatalogPage(),
          ),
          GoRoute(
            path: AppRoutes.cart,
            builder: (context, state) => const CartPage(),
          ),
          GoRoute(
            path: AppRoutes.orders,
            builder: (context, state) => const OrdersPage(),
            routes: [
              GoRoute(
                path: ':${StringConstants.routeParameterId}',
                name: AppRoutes.orderDetail,
                builder: (_, state) => OrderDetailPage(
                  orderId:
                      state.pathParameters[StringConstants.routeParameterId]!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
