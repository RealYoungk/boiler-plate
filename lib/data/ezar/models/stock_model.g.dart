// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockModel _$StockModelFromJson(Map<String, dynamic> json) => _StockModel(
  code: json['code'] as String? ?? '',
  name: json['name'] as String? ?? '',
  logoUrl: json['logoUrl'] as String? ?? '',
  currentPrice: (json['currentPrice'] as num?)?.toInt() ?? 0,
  changeRate: (json['changeRate'] as num?)?.toDouble() ?? 0.0,
  updatedAt: json['updatedAt'] == null
      ? const ConstDateTime(0)
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$StockModelToJson(_StockModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'currentPrice': instance.currentPrice,
      'changeRate': instance.changeRate,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
