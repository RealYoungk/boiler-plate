import 'package:flutter/material.dart';
import 'package:flutter_coding_test/domain/stock/stock.dart';
import 'package:flutter_coding_test/domain/watchlist/watchlist.dart';
import 'package:flutter_coding_test/presentation/stock/stock_provider.dart';
import 'package:flutter_coding_test/presentation/stock/stock_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class _MockStockRepository extends Mock implements StockRepository {}
class _MockWatchlistRepository extends Mock implements WatchlistRepository {}

void main() {
  group('StockView', () {
    Future<void> pumpStockView(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => StockProvider(
              stockRepository: _MockStockRepository(),
              watchlistRepository: _MockWatchlistRepository(),
            ),
            child: const StockView(),
          ),
        ),
      );
    }

    testWidgets('헤더에 종목명이 표시되어야 한다', (tester) async {
      await pumpStockView(tester);

      expect(find.text('삼성전자'), findsOneWidget);
    });

    testWidgets('헤더에 종목 코드가 표시되어야 한다', (tester) async {
      await pumpStockView(tester);

      expect(find.text('005930'), findsOneWidget);
    });

    testWidgets('헤더에 종목 로고가 표시되어야 한다', (tester) async {
      await pumpStockView(tester);

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('섹션 네비게이션 탭이 표시되어야 한다', (tester) async {
      await pumpStockView(tester);

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.descendant(of: find.byType(TabBar), matching: find.text('가격')), findsOneWidget);
      expect(find.descendant(of: find.byType(TabBar), matching: find.text('요약')), findsOneWidget);
      expect(find.descendant(of: find.byType(TabBar), matching: find.text('입력')), findsOneWidget);
      expect(find.descendant(of: find.byType(TabBar), matching: find.text('확장 패널')), findsOneWidget);
      expect(find.descendant(of: find.byType(TabBar), matching: find.text('기타')), findsOneWidget);
    });
  });
}
