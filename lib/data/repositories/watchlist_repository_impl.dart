import 'package:flutter_coding_test/data/local/local.dart';
import 'package:flutter_coding_test/domain/watchlist/watchlist.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistDataSourceLocal _localDataSource;

  WatchlistRepositoryImpl(this._localDataSource);

  @override
  Future<List<WatchlistItem>> getWatchlist() async {
    final models = _localDataSource.getAll();
    return models.map(_toEntity).toList();
  }

  @override
  Future<void> addItem(WatchlistItem item) async {
    await _localDataSource.add(_toModel(item));
  }

  @override
  Future<void> removeItem(String stockCode) async {
    await _localDataSource.remove(stockCode);
  }

  @override
  Future<void> updateItem(WatchlistItem item) async {
    await _localDataSource.update(_toModel(item));
  }

  WatchlistItem _toEntity(WatchlistItemModel model) {
    return WatchlistItem(
      stockCode: model.stockCode,
      targetPrice: model.targetPrice,
      alertType: AlertType.values.byName(model.alertTypeName),
      createdAt: model.createdAt,
    );
  }

  WatchlistItemModel _toModel(WatchlistItem entity) {
    return WatchlistItemModel(
      stockCode: entity.stockCode,
      targetPrice: entity.targetPrice,
      alertTypeName: entity.alertType.name,
      createdAt: entity.createdAt,
    );
  }
}
