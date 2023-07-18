import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eventos_minerva/main.dart' as app;

void main(){
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    group('CT6', () {

      testWidgets(
        'Verify Signup',
            (tester) async {
          app.main();

          // Aguarde o tempo de animação
          await tester.pumpAndSettle();

          // Localize o botão de navegação para a página de cadastro e clique nele
          final registerButton = find.byKey(const Key('signUpButton'));
          expect(registerButton, findsOneWidget);
          await tester.tap(registerButton);

          // Aguarde a finalização das animações
          await tester.pumpAndSettle();

          // Verifique se está na página de cadastro
          final registerPage = find.text('Cadastro');
          expect(registerPage, findsOneWidget);

          // Localize o campo de email e preencha-o
          final emailField = find.byKey(Key('email'));
          expect(emailField, findsOneWidget);
          final random = Random();
          final randomString = String.fromCharCodes(List.generate(8, (_) => random.nextInt(26) + 97));
          final email = '$randomString@teste.com';
          await tester.enterText(emailField, email);

          // Localize o campo de senha e preencha-o
          final passwordField = find.byKey(const Key('password'));
          expect(passwordField, findsOneWidget);
          await tester.enterText(passwordField, '12345678');

          // Localize o botão de cadastro e clique nele
          final registerButton2 = find.byKey(const Key('signup'));
          expect(registerButton2, findsOneWidget);
          await tester.tap(registerButton2);

          // Aguarde a finalização das animações
          await tester.pumpAndSettle();
        },
      );
    });
}