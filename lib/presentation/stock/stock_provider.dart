import 'package:flutter/foundation.dart';
import 'package:flutter_coding_test/domain/stock/stock.dart';
import 'package:flutter_coding_test/domain/watchlist/watchlist.dart';

class StockProvider extends ChangeNotifier {
  final StockRepository _stockRepository;
  final WatchlistRepository _watchlistRepository;

  StockProvider({
    required StockRepository stockRepository,
    required WatchlistRepository watchlistRepository,
  })  : _stockRepository = stockRepository,
        _watchlistRepository = watchlistRepository;

  List<String> get sectionTitles => const ['가격', '요약', '입력', '확장 패널', '기타'];

  StockRepository get stockRepository => _stockRepository;
  WatchlistRepository get watchlistRepository => _watchlistRepository;
}
