import 'package:flutter_coding_test/domain/stock/entities/stock.dart';

abstract interface class StockRepository {
  Stream<Stock> getPriceStream();
  Future<Stock?> getStock(String code);
}
