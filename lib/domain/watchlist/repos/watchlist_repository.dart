import 'package:flutter_coding_test/domain/watchlist/entities/watchlist_item.dart';

abstract interface class WatchlistRepository {
  Future<List<WatchlistItem>> getWatchlist();
  Future<void> addItem(WatchlistItem item);
  Future<void> removeItem(String stockCode);
  Future<void> updateItem(WatchlistItem item);
}
