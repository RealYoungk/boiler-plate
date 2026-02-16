import 'package:flutter_coding_test/domain/usecases/check_target_price_use_case.dart';
import 'package:flutter_coding_test/domain/watchlist/watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockWatchlistRepository extends Mock implements WatchlistRepository {}

void main() {
  late _MockWatchlistRepository mockRepository;
  late CheckTargetPriceUseCase useCase;

  setUp(() {
    mockRepository = _MockWatchlistRepository();
    useCase = CheckTargetPriceUseCase(mockRepository);
  });

  group('CheckTargetPriceUseCase', () {
    const testItem = WatchlistItem(
      stockCode: '005930',
      targetPrice: 75000,
      alertType: AlertType.both,
    );

    group('관심종목이 없는 경우', () {
      test('watchlist가 비어있으면 null을 반환해야 한다', () async {
        when(() => mockRepository.getWatchlist()).thenAnswer((_) async => []);

        final result = await useCase.call(
          stockCode: '005930',
          prevPrice: 70000,
          currentPrice: 76000,
        );

        expect(result, isNull);
      });

      test('해당 종목이 watchlist에 없으면 null을 반환해야 한다', () async {
        when(() => mockRepository.getWatchlist()).thenAnswer(
          (_) async => [testItem],
        );

        final result = await useCase.call(
          stockCode: '000660',
          prevPrice: 70000,
          currentPrice: 76000,
        );

        expect(result, isNull);
      });

      test('targetPrice가 null이면 null을 반환해야 한다', () async {
        when(() => mockRepository.getWatchlist()).thenAnswer(
          (_) async => [const WatchlistItem(stockCode: '005930')],
        );

        final result = await useCase.call(
          stockCode: '005930',
          prevPrice: 70000,
          currentPrice: 76000,
        );

        expect(result, isNull);
      });
    });

    group('상한 돌파 (crossedUp)', () {
      test('가격이 목표가를 상향 돌파하면 isUpper=true를 반환해야 한다', () async {
        when(() => mockRepository.getWatchlist()).thenAnswer(
          (_) async => [testItem],
        );

        final result = await useCase.call(
          stockCode: '005930',
          prevPrice: 74000,
          currentPrice: 75000,
        );

        expect(result, isNotNull);
        expect(result!.isUpper, true);
        expect(result.item, testItem);
      });

      test('AlertType.upper일 때 상향 돌파하면 결과를 반환해야 한다', () async {
        when(() => mockRepository.getWatchlist()).thenAnswer(
          (_) async => [testItem.copyWith(alertType: AlertType.upper)],
        );

        final result = await useCase.call(
          stockCode: '005930',
          prevPrice: 74000,
          currentPrice: 76000,
        );

        expect(result, isNotNull);
        expect(result!.isUpper, true);
      });

      test('AlertType.lower일 때 상향 돌파하면 null을 반환해야 한다', () async {
        when(() => mockRepository.getWatchlist()).thenAnswer(
          (_) async => [testItem.copyWith(alertType: AlertType.lower)],
        );

        final result = await useCase.call(
          stockCode: '005930',
          prevPrice: 74000,
          currentPrice: 76000,
        );

        expect(result, isNull);
      });
    });

    group('하한 돌파 (crossedDown)', () {
      test('가격이 목표가를 하향 돌파하면 isUpper=false를 반환해야 한다', () async {
        when(() => mockRepository.getWatchlist()).thenAnswer(
          (_) async => [testItem],
        );

        final result = await useCase.call(
          stockCode: '005930',
          prevPrice: 76000,
          currentPrice: 75000,
        );

        expect(result, isNotNull);
        expect(result!.isUpper, false);
      });

      test('AlertType.lower일 때 하향 돌파하면 결과를 반환해야 한다', () async {
        when(() => mockRepository.getWatchlist()).thenAnswer(
          (_) async => [testItem.copyWith(alertType: AlertType.lower)],
        );

        final result = await useCase.call(
          stockCode: '005930',
          prevPrice: 76000,
          currentPrice: 74000,
        );

        expect(result, isNotNull);
        expect(result!.isUpper, false);
      });

      test('AlertType.upper일 때 하향 돌파하면 null을 반환해야 한다', () async {
        when(() => mockRepository.getWatchlist()).thenAnswer(
          (_) async => [testItem.copyWith(alertType: AlertType.upper)],
        );

        final result = await useCase.call(
          stockCode: '005930',
          prevPrice: 76000,
          currentPrice: 74000,
        );

        expect(result, isNull);
      });
    });

    group('목표가 미도달', () {
      test('가격이 목표가에 도달하지 않으면 null을 반환해야 한다', () async {
        when(() => mockRepository.getWatchlist()).thenAnswer(
          (_) async => [testItem],
        );

        final result = await useCase.call(
          stockCode: '005930',
          prevPrice: 70000,
          currentPrice: 72000,
        );

        expect(result, isNull);
      });

      test('이전 가격과 현재 가격이 같으면 null을 반환해야 한다', () async {
        when(() => mockRepository.getWatchlist()).thenAnswer(
          (_) async => [testItem],
        );

        final result = await useCase.call(
          stockCode: '005930',
          prevPrice: 74000,
          currentPrice: 74000,
        );

        expect(result, isNull);
      });
    });
  });
}
