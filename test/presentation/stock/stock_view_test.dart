import 'package:flutter/material.dart';
import 'package:flutter_coding_test/presentation/stock/stock_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StockView', () {
    testWidgets('헤더에 종목명이 표시되어야 한다', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StockView()));

      expect(find.text('삼성전자'), findsOneWidget);
    });

    testWidgets('헤더에 종목 코드가 표시되어야 한다', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StockView()));

      expect(find.text('005930'), findsOneWidget);
    });

    testWidgets('헤더에 종목 로고가 표시되어야 한다', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StockView()));

      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });
}
