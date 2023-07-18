
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eventos_minerva/main.dart' as app;

void main(){
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    group('CT1', () {

      testWidgets(
        'Verify Login Screen',
        (tester) async {
          app.main();

          // Aguarde o tempo de animação
          await tester.pumpAndSettle();

          // Localize o campo de email e preencha-o
          final emailField = find.byKey(const Key('email'));
          expect(emailField, findsOneWidget);
          await tester.enterText(emailField, 'teste@teste.com');

          // Localize o campo de senha e preencha-o
          final passwordField = find.byKey(const Key('password'));
          expect(passwordField, findsOneWidget);
          await tester.enterText(passwordField, '12345678');

          // Localize o botão de entrada e clique nele
          final loginButton = find.byKey(const Key('login'));
          expect(loginButton, findsOneWidget);
          await tester.tap(loginButton);

          // Aguarde a finalização das animações
          await tester.pumpAndSettle();

          // Verifique se a ação de login foi realizada corretamente
          // Insira aqui as verificações necessárias após o login

          // Exemplo: Verifique se uma nova página é aberta após o login
          final newPage = find.text('Eventos Minerva');
          expect(newPage, findsOneWidget);
        },
      );
     });
}