import 'package:const_date_time/const_date_time.dart';
import 'package:flutter_coding_test/data/ezar/models/stock_tick_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StockTickMessage', () {
    group('생성', () {
      test('디폴트 값으로 정상 생성되어야 한다', () {
        const message = StockTickMessage();

        expect(message.type, '');
        expect(message.stockCode, '');
        expect(message.currentPrice, 0);
        expect(message.changeRate, 0.0);
        expect(message.timestamp, const ConstDateTime(0));
      });

      test('모든 필드를 지정하여 생성할 수 있어야 한다', () {
        final timestamp = DateTime.parse('2024-01-15T09:30:00.000Z');

        final message = StockTickMessage(
          type: 'price_update',
          stockCode: '005930',
          currentPrice: 72500,
          changeRate: 1.25,
          timestamp: timestamp,
        );

        expect(message.type, 'price_update');
        expect(message.stockCode, '005930');
        expect(message.currentPrice, 72500);
        expect(message.changeRate, 1.25);
        expect(message.timestamp, timestamp);
      });
    });

    group('fromJson', () {
      test('WebSocket 메시지를 정상 파싱할 수 있어야 한다', () {
        final json = {
          'type': 'price_update',
          'stockCode': '005930',
          'currentPrice': 72500,
          'changeRate': 1.25,
          'timestamp': '2024-01-15T09:30:00.000Z',
        };

        final message = StockTickMessage.fromJson(json);

        expect(message.type, 'price_update');
        expect(message.stockCode, '005930');
        expect(message.currentPrice, 72500);
        expect(message.changeRate, 1.25);
        expect(message.timestamp, DateTime.parse('2024-01-15T09:30:00.000Z'));
      });

      test('누락된 필드는 디폴트 값이 적용되어야 한다', () {
        final json = <String, dynamic>{};

        final message = StockTickMessage.fromJson(json);

        expect(message.type, '');
        expect(message.stockCode, '');
        expect(message.currentPrice, 0);
        expect(message.changeRate, 0.0);
        expect(message.timestamp, const ConstDateTime(0));
      });
    });

    group('동등성', () {
      test('동등한 객체는 같다고 판단해야 한다', () {
        final timestamp = DateTime.parse('2024-01-15T09:30:00.000Z');

        final message1 = StockTickMessage(
          type: 'price_update',
          stockCode: '005930',
          currentPrice: 72500,
          changeRate: 1.25,
          timestamp: timestamp,
        );

        final message2 = StockTickMessage(
          type: 'price_update',
          stockCode: '005930',
          currentPrice: 72500,
          changeRate: 1.25,
          timestamp: timestamp,
        );

        expect(message1, equals(message2));
        expect(message1.hashCode, equals(message2.hashCode));
      });
    });

    group('copyWith', () {
      test('copyWith로 필드를 변경할 수 있어야 한다', () {
        final timestamp = DateTime.parse('2024-01-15T09:30:00.000Z');

        final original = StockTickMessage(
          type: 'price_update',
          stockCode: '005930',
          currentPrice: 72500,
          changeRate: 1.25,
          timestamp: timestamp,
        );

        final updated = original.copyWith(
          currentPrice: 73000,
          changeRate: 1.94,
        );

        expect(updated.type, 'price_update');
        expect(updated.stockCode, '005930');
        expect(updated.currentPrice, 73000);
        expect(updated.changeRate, 1.94);
        expect(updated.timestamp, timestamp);

        expect(original.currentPrice, 72500);
        expect(original.changeRate, 1.25);
      });
    });
  });
}
