import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:done_together/app/views/view_home/home_view.dart';

void main() {
  testWidgets('HomeView shows app title and content after load', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Done Together'), findsOneWidget);
    expect(find.text('Groups • Tasks • Leaderboard'), findsOneWidget);
  });
}
