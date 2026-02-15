import 'package:const_date_time/const_date_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_model.freezed.dart';
part 'stock_model.g.dart';

@freezed
abstract class StockModel with _$StockModel {
  const factory StockModel({
    @Default('') String code,
    @Default('') String name,
    @Default('') String logoUrl,
    @Default(0.0) double changeRate,
    @Default([]) List<int> priceHistory,
    @Default(ConstDateTime(0)) DateTime updatedAt,
  }) = _StockModel;

  factory StockModel.fromJson(Map<String, dynamic> json) =>
      _$StockModelFromJson(json);
}
