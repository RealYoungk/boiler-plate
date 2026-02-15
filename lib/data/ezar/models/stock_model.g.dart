// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockModel _$StockModelFromJson(Map<String, dynamic> json) => _StockModel(
  code: json['code'] as String? ?? '',
  name: json['name'] as String? ?? '',
  logoUrl: json['logoUrl'] as String? ?? '',
  changeRate: (json['changeRate'] as num?)?.toDouble() ?? 0.0,
  priceHistory:
      (json['priceHistory'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  updatedAt: json['updatedAt'] == null
      ? const ConstDateTime(0)
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$StockModelToJson(_StockModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'changeRate': instance.changeRate,
      'priceHistory': instance.priceHistory,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
