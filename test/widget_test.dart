import 'package:bulk_order_frontend/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the catalog shell', (tester) async {
    await tester.pumpWidget(const BulkOrderApp());
    await tester.pumpAndSettle();
    expect(find.text('This week’s pool'), findsOneWidget);
    expect(find.text('Store'), findsOneWidget);
  });
}
