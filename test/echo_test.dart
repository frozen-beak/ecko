import 'package:flutter_test/flutter_test.dart';

import 'package:echo/echo.dart';

void main() {
  test('Placeholder test', () {
    final echo = Echo();
    expect(echo, isA<Echo>());
  });
}
