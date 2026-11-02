import 'package:cash_money/core/data/data_sources/local/cache_helper_impl.dart';
import 'package:cash_money/core/domain/data_sources/cache_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  late CacheHelper cacheHelper;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    cacheHelper = CacheHelperImpl(prefs: prefs);
  });

  group('CacheHelper - Success', () {
    test('setString then getString returns same value', () async {
      await cacheHelper.setString(key: 'token', value: 'abc123');
      expect(await cacheHelper.getString(key: 'token'), 'abc123');
    });

    test('getString returns empty when key missing', () async {
      expect(await cacheHelper.getString(key: 'missing'), '');
    });

    test('setInt and getInt work', () async {
      await cacheHelper.setInt(key: 'age', value: 25);
      expect(await cacheHelper.getInt(key: 'age'), 25);
    });

    test('removeValue deletes the key', () async {
      await cacheHelper.setString(key: 'token', value: 'abc');
      await cacheHelper.removeValue(key: 'token');
      expect(await cacheHelper.getString(key: 'token'), '');
    });
  });
}