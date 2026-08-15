import 'package:bulk_order_frontend/core/constants/string_constants.dart';
import 'package:bulk_order_frontend/core/design_system/app_colors.dart';
import 'package:bulk_order_frontend/core/design_system/app_tokens.dart';
import 'package:bulk_order_frontend/features/catalog/bloc/catalog_bloc.dart';
import 'package:bulk_order_frontend/features/cart/bloc/cart_bloc.dart';
import 'package:bulk_order_frontend/features/shared/data/api_repository.dart';
import 'package:bulk_order_frontend/shared/widgets/app_badge.dart';
import 'package:bulk_order_frontend/shared/widgets/app_button.dart';
import 'package:bulk_order_frontend/shared/widgets/app_page.dart';
import 'package:bulk_order_frontend/shared/widgets/app_shimmer.dart';
import 'package:bulk_order_frontend/shared/widgets/quantity_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => CatalogBloc(context.read<ApiRepository>())..load(),
      ),
      BlocProvider(
        create: (context) => CartBloc(context.read<ApiRepository>()),
      ),
    ],
    child: const _CatalogView(),
  );
}

class _CatalogView extends StatefulWidget {
  const _CatalogView();
  @override
  State<_CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<_CatalogView> {
  final quantities = <int, int>{};
  @override
  Widget build(BuildContext context) => AppPage(
    title: StringConstants.thisWeeksPool,
    subtitle: StringConstants.cycleSubtitle,
    actions: const [Icon(Icons.location_on_outlined, color: AppColors.ink700)],
    children: [
      const SizedBox(height: AppSpace.x2),
      TextField(
        onSubmitted: (value) => context.read<CatalogBloc>().load(query: value),
        decoration: const InputDecoration(
          hintText: StringConstants.searchEssentials,
          prefixIcon: Icon(Icons.search, color: AppColors.ink400),
        ),
      ),
      const SectionLabel(StringConstants.shopByCategory),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              [
                    StringConstants.all,
                    StringConstants.pantry,
                    StringConstants.freshProduce,
                    StringConstants.homeCleaning,
                  ]
                  .map(
                    (label) => Padding(
                      padding: const EdgeInsets.only(right: AppSpace.x2),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: label == StringConstants.all,
                        onSelected: (_) {},
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
      const SectionLabel(StringConstants.popularInCommunity),
      BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) => switch (state) {
          CatalogLoading() => const AppListShimmer(),
          CatalogFailure(:final message) => _failure(context, message),
          CatalogLoaded(:final items, :final cycle) =>
            items.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(AppSpace.x4),
                    child: Text(StringConstants.noCatalogItems),
                  )
                : Column(
                    children: items
                        .map(
                          (item) => _product(
                            item,
                            (cycle['id'] as num?)?.toInt() ?? 0,
                          ),
                        )
                        .toList(),
                  ),
        },
      ),
    ],
  );
  Widget _failure(BuildContext context, String message) => Padding(
    padding: const EdgeInsets.only(top: AppSpace.x4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message),
        const SizedBox(height: AppSpace.x3),
        AppButton(
          label: StringConstants.retry,
          onPressed: () => context.read<CatalogBloc>().load(),
        ),
      ],
    ),
  );
  Widget _product(Map<String, dynamic> item, int cycleId) {
    final id = (item['item_id'] as num?)?.toInt() ?? 0;
    final count = quantities[id] ?? 0;
    final name = item['name']?.toString() ?? '';
    final detail = '${item['quantity'] ?? ''} ${item['unit'] ?? ''}';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.x4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.ink100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.ink100,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.ink400,
            ),
          ),
          const SizedBox(width: AppSpace.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: const TextStyle(fontSize: 12, color: AppColors.ink600),
                ),
                const SizedBox(height: 7),
                AppBadge(
                  '$count${StringConstants.joinedSuffix}',
                  tone: AppBadgeTone.brand,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.x2),
          count == 0
              ? AppButton(
                  label: StringConstants.add,
                  small: true,
                  style: AppButtonStyle.secondary,
                  onPressed: cycleId == 0
                      ? null
                      : () {
                          setState(() => quantities[id] = 1);
                          context.read<CartBloc>().add(
                            CartItemAdded(
                              cycleId: cycleId,
                              itemId: id,
                              quantity: '1',
                            ),
                          );
                        },
                )
              : QuantityStepper(
                  value: count,
                  onChanged: (value) {
                    setState(() => quantities[id] = value);
                    if (value == 0) {
                      context.read<CartBloc>().add(
                        CartItemRemoved(cycleId: cycleId, itemId: id),
                      );
                    } else {
                      context.read<CartBloc>().add(
                        CartItemQuantityUpdated(
                          cycleId: cycleId,
                          itemId: id,
                          quantity: '$value',
                        ),
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }
}
