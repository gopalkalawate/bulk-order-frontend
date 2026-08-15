import 'package:bulk_order_frontend/app/app.dart';
import 'package:bulk_order_frontend/core/storage/app_preferences.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await AppPreferences.create();
  runApp(BulkOrderApp(preferences: preferences));
}
