import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shatabx/core/utils/validator.dart';

void main() {
  testWidgets('email validator accepts a company email', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(Validator.email(context, ''), isNotNull);
    expect(Validator.email(context, 'company@example.com'), isNull);
  });
}
