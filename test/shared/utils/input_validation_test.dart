import 'package:flutter_test/flutter_test.dart';
import 'package:cash_money/shared/utils/helpers/validate/input_validation.dart';


void main() {
  group('InputValidation.validator', () {
    test('returns error message when value is null', () {
      final result = InputValidation.validator(null, 'Name');

      expect(result, 'Please enter your Name');
    });

    test('returns error message when value is empty', () {
      final result = InputValidation.validator('', 'Email');

      expect(result, 'Please enter your Email');
    });

    test('returns null when value is not empty', () {
      final result = InputValidation.validator('Ali', 'Name');

      expect(result, isNull);
    });

    test('includes the fieldName in the error message', () {
      final result = InputValidation.validator('', 'Password');

      expect(result, contains('Password'));
    });

    test('returns null for whitespace-only string (documents behavior)', () {
      // '   ' ليست فارغة (isEmpty == false) → null
      final result = InputValidation.validator('   ', 'Name');

      expect(result, isNull);
    });
  });
}