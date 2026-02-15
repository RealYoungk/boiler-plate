import 'package:const_date_time/const_date_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_tick_message.freezed.dart';
part 'stock_tick_message.g.dart';

@freezed
abstract class StockTickMessage with _$StockTickMessage {
  const factory StockTickMessage({
    @Default('') String type,
    @Default('') String stockCode,
    @Default(0) int currentPrice,
    @Default(0.0) double changeRate,
    @Default(ConstDateTime(0)) DateTime timestamp,
  }) = _StockTickMessage;

  factory StockTickMessage.fromJson(Map<String, dynamic> json) =>
      _$StockTickMessageFromJson(json);
}
