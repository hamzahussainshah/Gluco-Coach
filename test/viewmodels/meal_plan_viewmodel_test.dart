import 'package:flutter_test/flutter_test.dart';
import 'package:gluco_coach/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('MealPlanViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
