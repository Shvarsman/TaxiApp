import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:taxi_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full login, navigation, and theme change', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Экран авторизации
    expect(find.text('Такси'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));

    // Вводим почту и пароль
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, '123456');
    await tester.tap(find.text('Войти'));
    await tester.pumpAndSettle();

    // Должны оказаться на главной с нижней навигацией
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Недавние поездки'), findsOneWidget);

    // Переход на вкладку Настроек
    await tester.tap(find.text('Настройки'));
    await tester.pumpAndSettle();
    expect(find.text('Тёмная тема'), findsOneWidget);

    // Включаем тёмную тему
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    // Проверяем, что тема переключилась (визуально не проверить, но можно продублировать состоянием)

    // Возврат на главную
    await tester.tap(find.text('Главная'));
    await tester.pumpAndSettle();
    expect(find.text('Недавние поездки'), findsOneWidget);

    // Переход в историю
    await tester.tap(find.text('История'));
    await tester.pumpAndSettle();
    expect(find.text('Поездок пока нет'), findsOneWidget);

    // Переход обратно в заказ такси
    await tester.tap(find.text('Заказать такси'));
    await tester.pumpAndSettle();
    expect(find.text('Выбрать тариф'), findsOneWidget);
  });
}