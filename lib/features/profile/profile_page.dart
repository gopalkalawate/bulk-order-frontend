import 'package:bulk_order_frontend/core/design_system/app_colors.dart';
import 'package:bulk_order_frontend/core/constants/string_constants.dart';
import 'package:bulk_order_frontend/shared/widgets/app_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    title: StringConstants.profile,
    subtitle: StringConstants.manageProfile,
    children: [
      const SectionLabel(StringConstants.account),
      Card(
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.brand100,
                child: Icon(Icons.person, color: AppColors.brand700),
              ),
              title: const Text(StringConstants.household),
              subtitle: const Text(StringConstants.householdHint),
              onTap: () {},
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text(StringConstants.deliveryLocation),
              subtitle: const Text(StringConstants.deliveryLocationHint),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    ],
  );
}
