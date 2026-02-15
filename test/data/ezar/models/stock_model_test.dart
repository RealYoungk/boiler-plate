import 'package:const_date_time/const_date_time.dart';
import 'package:flutter_coding_test/data/ezar/models/stock_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StockModel', () {
    group('생성', () {
      test('디폴트 값으로 정상 생성되어야 한다', () {
        const model = StockModel();

        expect(model.code, '');
        expect(model.name, '');
        expect(model.logoUrl, '');
        expect(model.priceHistory, const []);
        expect(model.changeRate, 0.0);
        expect(model.updatedAt, const ConstDateTime(0));
      });

      test('모든 필드를 지정하여 생성할 수 있어야 한다', () {
        final updatedAt = DateTime(2024, 1, 15, 9, 30);

        final model = StockModel(
          code: '005930',
          name: '삼성전자',
          logoUrl: 'https://example.com/samsung.png',
          priceHistory: const [72500],
          changeRate: 1.25,
          updatedAt: updatedAt,
        );

        expect(model.code, '005930');
        expect(model.name, '삼성전자');
        expect(model.logoUrl, 'https://example.com/samsung.png');
        expect(model.priceHistory, const [72500]);
        expect(model.changeRate, 1.25);
        expect(model.updatedAt, updatedAt);
      });
    });

    group('fromJson', () {
      test('JSON을 정상 파싱할 수 있어야 한다', () {
        final json = {
          'code': '005930',
          'name': '삼성전자',
          'logoUrl': 'https://example.com/samsung.png',
          'priceHistory': [72500],
          'changeRate': 1.25,
          'updatedAt': '2024-01-15T09:30:00.000',
        };

        final model = StockModel.fromJson(json);

        expect(model.code, '005930');
        expect(model.name, '삼성전자');
        expect(model.logoUrl, 'https://example.com/samsung.png');
        expect(model.priceHistory, const [72500]);
        expect(model.changeRate, 1.25);
        expect(model.updatedAt, DateTime(2024, 1, 15, 9, 30));
      });

      test('누락된 필드는 디폴트 값이 적용되어야 한다', () {
        final json = <String, dynamic>{};

        final model = StockModel.fromJson(json);

        expect(model.code, '');
        expect(model.name, '');
        expect(model.logoUrl, '');
        expect(model.priceHistory, const []);
        expect(model.changeRate, 0.0);
        expect(model.updatedAt, const ConstDateTime(0));
      });
    });

    group('동등성', () {
      test('동등한 객체는 같다고 판단해야 한다', () {
        final updatedAt = DateTime(2024, 1, 15, 9, 30);

        final model1 = StockModel(
          code: '005930',
          name: '삼성전자',
          logoUrl: 'https://example.com/samsung.png',
          priceHistory: const [72500],
          changeRate: 1.25,
          updatedAt: updatedAt,
        );

        final model2 = StockModel(
          code: '005930',
          name: '삼성전자',
          logoUrl: 'https://example.com/samsung.png',
          priceHistory: const [72500],
          changeRate: 1.25,
          updatedAt: updatedAt,
        );

        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });
    });

    group('copyWith', () {
      test('copyWith로 필드를 변경할 수 있어야 한다', () {
        const original = StockModel(
          code: '005930',
          name: '삼성전자',
          logoUrl: 'https://example.com/samsung.png',
          priceHistory: [72500],
          changeRate: 1.25,
        );

        final copied = original.copyWith(
          code: '035720',
          name: '카카오',
          logoUrl: 'https://example.com/kakao.png',
          priceHistory: const [55000],
          changeRate: -0.5,
        );

        expect(copied.code, '035720');
        expect(copied.name, '카카오');
        expect(copied.logoUrl, 'https://example.com/kakao.png');
        expect(copied.priceHistory, const [55000]);
        expect(copied.changeRate, -0.5);

        expect(original.code, '005930');
        expect(original.name, '삼성전자');
        expect(original.priceHistory, const [72500]);
      });
    });
  });
}
