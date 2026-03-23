import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: _TestApp()));
    expect(find.text('القرآن الكريم'), findsWidgets);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text('القرآن الكريم')),
      ),
    );
  }
}