// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_tick_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockTickMessage _$StockTickMessageFromJson(Map<String, dynamic> json) =>
    _StockTickMessage(
      type: json['type'] as String? ?? '',
      stockCode: json['stockCode'] as String? ?? '',
      currentPrice: (json['currentPrice'] as num?)?.toInt() ?? 0,
      changeRate: (json['changeRate'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] == null
          ? const ConstDateTime(0)
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$StockTickMessageToJson(_StockTickMessage instance) =>
    <String, dynamic>{
      'type': instance.type,
      'stockCode': instance.stockCode,
      'currentPrice': instance.currentPrice,
      'changeRate': instance.changeRate,
      'timestamp': instance.timestamp.toIso8601String(),
    };
