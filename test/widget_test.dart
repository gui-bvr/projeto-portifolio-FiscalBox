import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:portifolio_fiscal_box/modules/home_screens/home_page.dart';

void main() {
  testWidgets('Verifica se HomePage carrega corretamente',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: HomePage(),
      ),
    );

    // Espera o carregamento da UI
    await tester.pumpAndSettle();

    // Verifica se algum texto típico está presente
    expect(find.textContaining('Bom dia', findRichText: true), findsWidgets);
    expect(find.byType(Drawer), findsOneWidget);
  });
}
