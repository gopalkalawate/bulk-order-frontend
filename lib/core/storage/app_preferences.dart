import 'package:shared_preferences/shared_preferences.dart';
import 'package:bulk_order_frontend/core/constants/string_constants.dart';

class AppPreferences {
  AppPreferences._(this._preferences);
  final SharedPreferencesAsync _preferences;

  static Future<AppPreferences> create() async =>
      AppPreferences._(SharedPreferencesAsync());
  Future<String?> get accessToken =>
      _preferences.getString(StringConstants.accessTokenKey);
  Future<void> saveAccessToken(String token) =>
      _preferences.setString(StringConstants.accessTokenKey, token);
  Future<void> clearAccessToken() =>
      _preferences.remove(StringConstants.accessTokenKey);
  Future<bool> get hasSeenOnboarding async =>
      await _preferences.getBool(StringConstants.onboardingSeenKey) ?? false;
  Future<void> markOnboardingSeen() =>
      _preferences.setBool(StringConstants.onboardingSeenKey, true);
}
