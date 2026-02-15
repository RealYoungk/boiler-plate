// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_tick_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockTickMessage {

 String get type; String get stockCode; int get currentPrice; double get changeRate; DateTime get timestamp;
/// Create a copy of StockTickMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockTickMessageCopyWith<StockTickMessage> get copyWith => _$StockTickMessageCopyWithImpl<StockTickMessage>(this as StockTickMessage, _$identity);

  /// Serializes this StockTickMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockTickMessage&&(identical(other.type, type) || other.type == type)&&(identical(other.stockCode, stockCode) || other.stockCode == stockCode)&&(identical(other.currentPrice, currentPrice) || other.currentPrice == currentPrice)&&(identical(other.changeRate, changeRate) || other.changeRate == changeRate)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,stockCode,currentPrice,changeRate,timestamp);

@override
String toString() {
  return 'StockTickMessage(type: $type, stockCode: $stockCode, currentPrice: $currentPrice, changeRate: $changeRate, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $StockTickMessageCopyWith<$Res>  {
  factory $StockTickMessageCopyWith(StockTickMessage value, $Res Function(StockTickMessage) _then) = _$StockTickMessageCopyWithImpl;
@useResult
$Res call({
 String type, String stockCode, int currentPrice, double changeRate, DateTime timestamp
});




}
/// @nodoc
class _$StockTickMessageCopyWithImpl<$Res>
    implements $StockTickMessageCopyWith<$Res> {
  _$StockTickMessageCopyWithImpl(this._self, this._then);

  final StockTickMessage _self;
  final $Res Function(StockTickMessage) _then;

/// Create a copy of StockTickMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? stockCode = null,Object? currentPrice = null,Object? changeRate = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,stockCode: null == stockCode ? _self.stockCode : stockCode // ignore: cast_nullable_to_non_nullable
as String,currentPrice: null == currentPrice ? _self.currentPrice : currentPrice // ignore: cast_nullable_to_non_nullable
as int,changeRate: null == changeRate ? _self.changeRate : changeRate // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StockTickMessage].
extension StockTickMessagePatterns on StockTickMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockTickMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockTickMessage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockTickMessage value)  $default,){
final _that = this;
switch (_that) {
case _StockTickMessage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockTickMessage value)?  $default,){
final _that = this;
switch (_that) {
case _StockTickMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String stockCode,  int currentPrice,  double changeRate,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockTickMessage() when $default != null:
return $default(_that.type,_that.stockCode,_that.currentPrice,_that.changeRate,_that.timestamp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String stockCode,  int currentPrice,  double changeRate,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _StockTickMessage():
return $default(_that.type,_that.stockCode,_that.currentPrice,_that.changeRate,_that.timestamp);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String stockCode,  int currentPrice,  double changeRate,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _StockTickMessage() when $default != null:
return $default(_that.type,_that.stockCode,_that.currentPrice,_that.changeRate,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockTickMessage implements StockTickMessage {
  const _StockTickMessage({this.type = '', this.stockCode = '', this.currentPrice = 0, this.changeRate = 0.0, this.timestamp = const ConstDateTime(0)});
  factory _StockTickMessage.fromJson(Map<String, dynamic> json) => _$StockTickMessageFromJson(json);

@override@JsonKey() final  String type;
@override@JsonKey() final  String stockCode;
@override@JsonKey() final  int currentPrice;
@override@JsonKey() final  double changeRate;
@override@JsonKey() final  DateTime timestamp;

/// Create a copy of StockTickMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockTickMessageCopyWith<_StockTickMessage> get copyWith => __$StockTickMessageCopyWithImpl<_StockTickMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockTickMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockTickMessage&&(identical(other.type, type) || other.type == type)&&(identical(other.stockCode, stockCode) || other.stockCode == stockCode)&&(identical(other.currentPrice, currentPrice) || other.currentPrice == currentPrice)&&(identical(other.changeRate, changeRate) || other.changeRate == changeRate)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,stockCode,currentPrice,changeRate,timestamp);

@override
String toString() {
  return 'StockTickMessage(type: $type, stockCode: $stockCode, currentPrice: $currentPrice, changeRate: $changeRate, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$StockTickMessageCopyWith<$Res> implements $StockTickMessageCopyWith<$Res> {
  factory _$StockTickMessageCopyWith(_StockTickMessage value, $Res Function(_StockTickMessage) _then) = __$StockTickMessageCopyWithImpl;
@override @useResult
$Res call({
 String type, String stockCode, int currentPrice, double changeRate, DateTime timestamp
});




}
/// @nodoc
class __$StockTickMessageCopyWithImpl<$Res>
    implements _$StockTickMessageCopyWith<$Res> {
  __$StockTickMessageCopyWithImpl(this._self, this._then);

  final _StockTickMessage _self;
  final $Res Function(_StockTickMessage) _then;

/// Create a copy of StockTickMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? stockCode = null,Object? currentPrice = null,Object? changeRate = null,Object? timestamp = null,}) {
  return _then(_StockTickMessage(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,stockCode: null == stockCode ? _self.stockCode : stockCode // ignore: cast_nullable_to_non_nullable
as String,currentPrice: null == currentPrice ? _self.currentPrice : currentPrice // ignore: cast_nullable_to_non_nullable
as int,changeRate: null == changeRate ? _self.changeRate : changeRate // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
