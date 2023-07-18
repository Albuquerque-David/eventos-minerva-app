import 'package:eventos_minerva/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eventos_minerva/main.dart' as app;

void main(){
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    group('CT1', () {
      testWidgets(
        'verify login screen', 
        (tester) async {
          app.main();
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(TextField).at(0), 'username');
          await tester.enterText(find.byType(TextField).at(1), 'password');
          await tester.tap(find.byKey(Key('login')));
          await tester.pumpAndSettle();

          expect(find.byType(HomePage), findsOneWidget);
        },
      );
     });
}