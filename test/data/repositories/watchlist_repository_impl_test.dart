import 'dart:io';

import 'package:flutter_coding_test/data/local/local.dart';
import 'package:flutter_coding_test/data/repositories/watchlist_repository_impl.dart';
import 'package:flutter_coding_test/domain/watchlist/watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

void main() {
  late Directory tempDir;
  late Box<WatchlistItemModel> box;
  late WatchlistRepositoryImpl repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);

    try {
      Hive.registerAdapter(WatchlistItemModelAdapter());
    } catch (_) {}

    box = await Hive.openBox<WatchlistItemModel>(
      WatchlistDataSourceLocal.boxName,
    );
    repository = WatchlistRepositoryImpl(WatchlistDataSourceLocal(box));
  });

  tearDown(() async {
    await box.clear();
    await box.close();
    await tempDir.delete(recursive: true);
  });

  group('WatchlistRepositoryImpl', () {
    group('getWatchlist', () {
      test('빈 상태에서 빈 리스트를 반환해야 한다', () async {
        final result = await repository.getWatchlist();
        expect(result, isEmpty);
      });

      test('저장된 항목을 도메인 엔티티로 변환하여 반환해야 한다', () async {
        await repository.addItem(
          const WatchlistItem(
            stockCode: '005930',
            targetPrice: 75000,
            alertType: AlertType.upper,
          ),
        );

        final result = await repository.getWatchlist();
        expect(result, hasLength(1));
        expect(result.first.stockCode, '005930');
        expect(result.first.targetPrice, 75000);
        expect(result.first.alertType, AlertType.upper);
      });
    });

    group('addItem', () {
      test('도메인 엔티티를 저장할 수 있어야 한다', () async {
        await repository.addItem(
          const WatchlistItem(
            stockCode: '005930',
            targetPrice: 80000,
            alertType: AlertType.both,
          ),
        );

        final result = await repository.getWatchlist();
        expect(result, hasLength(1));
        expect(result.first.stockCode, '005930');
        expect(result.first.targetPrice, 80000);
        expect(result.first.alertType, AlertType.both);
      });
    });

    group('removeItem', () {
      test('항목을 삭제할 수 있어야 한다', () async {
        await repository.addItem(const WatchlistItem(stockCode: '005930'));
        expect((await repository.getWatchlist()), hasLength(1));

        await repository.removeItem('005930');
        expect((await repository.getWatchlist()), isEmpty);
      });
    });

    group('updateItem', () {
      test('항목을 업데이트할 수 있어야 한다', () async {
        await repository.addItem(
          const WatchlistItem(
            stockCode: '005930',
            targetPrice: 75000,
            alertType: AlertType.both,
          ),
        );

        await repository.updateItem(
          const WatchlistItem(
            stockCode: '005930',
            targetPrice: 80000,
            alertType: AlertType.upper,
          ),
        );

        final result = await repository.getWatchlist();
        expect(result, hasLength(1));
        expect(result.first.targetPrice, 80000);
        expect(result.first.alertType, AlertType.upper);
      });
    });

    group('AlertType 매핑', () {
      test('모든 AlertType이 정상적으로 저장 및 복원되어야 한다', () async {
        for (final type in AlertType.values) {
          await repository.addItem(
            WatchlistItem(stockCode: type.name, alertType: type),
          );
        }

        final result = await repository.getWatchlist();
        expect(result, hasLength(AlertType.values.length));

        for (final type in AlertType.values) {
          final item = result.firstWhere((i) => i.stockCode == type.name);
          expect(item.alertType, type);
        }
      });
    });
  });
}
