import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eventos_minerva/main.dart' as app;

void main(){
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    group('CT2', () {

      testWidgets(
        'Verify Login Screen',
        (tester) async {
          app.main();

          // Aguarde o tempo de animação
          await tester.pumpAndSettle();

          // Passo 1: Preencher os campos de email e senha
          await tester.enterText(find.byKey(const Key('email')), 'teste@teste.com');
          await tester.enterText(find.byKey(const Key('password')), '12345678');

          // Passo 2: Clicar no botão de entrada
          await tester.tap(find.byKey(const Key('login')));
          await tester.pump(Duration(seconds: 10));
          await tester.pumpAndSettle();


          // Passo 3: Selecionar o card do evento
          await tester.tap(find.byKey(const Key('eventCard')));
          await tester.pumpAndSettle();

          // Passo 4: Selecionar o botão de programação
          await tester.tap(find.byKey(const Key('scheduleButton')));
          await tester.pumpAndSettle();

          // Verificações:
          // Insira aqui as verificações necessárias após cada passo

          // Exemplo: Verificar se uma nova página é aberta após o passo 4
          final schedulePage = find.text('Programação');
          expect(schedulePage, findsOneWidget);
        },
      );
     });
}