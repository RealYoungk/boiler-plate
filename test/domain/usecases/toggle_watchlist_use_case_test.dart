import 'package:flutter_coding_test/domain/usecases/toggle_watchlist_use_case.dart';
import 'package:flutter_coding_test/domain/watchlist/watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockWatchlistRepository extends Mock implements WatchlistRepository {}

void main() {
  late _MockWatchlistRepository mockRepository;
  late ToggleWatchlistUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const WatchlistItem());
  });

  setUp(() {
    mockRepository = _MockWatchlistRepository();
    useCase = ToggleWatchlistUseCase(mockRepository);
  });

  group('ToggleWatchlistUseCase', () {
    const testItem = WatchlistItem(
      stockCode: '005930',
      targetPrice: 80000,
      alertType: AlertType.both,
    );

    test('isInWatchlist가 true이면 removeItem을 호출해야 한다', () async {
      when(
        () => mockRepository.removeItem(any()),
      ).thenAnswer((_) async {});

      await useCase.call(item: testItem, isInWatchlist: true);

      verify(() => mockRepository.removeItem('005930')).called(1);
      verifyNever(() => mockRepository.addItem(any()));
    });

    test('isInWatchlist가 false이면 addItem을 호출해야 한다', () async {
      when(
        () => mockRepository.addItem(any()),
      ).thenAnswer((_) async {});

      await useCase.call(item: testItem, isInWatchlist: false);

      verify(() => mockRepository.addItem(testItem)).called(1);
      verifyNever(() => mockRepository.removeItem(any()));
    });
  });
}
