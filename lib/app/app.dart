import 'package:bulk_order_frontend/core/constants/string_constants.dart';
import 'package:bulk_order_frontend/core/network/api_client.dart';
import 'package:bulk_order_frontend/core/router/app_router.dart';
import 'package:bulk_order_frontend/core/storage/app_preferences.dart';
import 'package:bulk_order_frontend/core/theme/app_theme.dart';
import 'package:bulk_order_frontend/features/shared/data/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BulkOrderApp extends StatefulWidget {
  const BulkOrderApp({super.key, this.preferences});
  final AppPreferences? preferences;

  @override
  State<BulkOrderApp> createState() => _BulkOrderAppState();
}

class _BulkOrderAppState extends State<BulkOrderApp> {
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _saveTestingToken();
  }

  Future<void> _saveTestingToken() async {
    // Persist the supplied test JWT before API-backed BLoCs start loading.
    await widget.preferences?.saveAccessToken(
      StringConstants.testingAccessToken,
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _initialization,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return MaterialApp(theme: AppTheme.light, home: const Scaffold());
      }
      return _app();
    },
  );

  Widget _app() {
    final repository = ApiRepository(
      ApiClient(
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: StringConstants.baseUrl,
        ),
        tokenProvider: widget.preferences == null
            ? null
            : () => widget.preferences!.accessToken,
      ),
    );
    return RepositoryProvider.value(
      value: repository,
      child: MaterialApp.router(
        title: StringConstants.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
