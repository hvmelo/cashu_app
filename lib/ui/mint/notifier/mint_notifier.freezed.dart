// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mint_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MintState {
  int get amount => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get invoice => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of MintState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MintStateCopyWith<MintState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MintStateCopyWith<$Res> {
  factory $MintStateCopyWith(MintState value, $Res Function(MintState) then) =
      _$MintStateCopyWithImpl<$Res, MintState>;
  @useResult
  $Res call({int amount, bool isLoading, String? invoice, String? error});
}

/// @nodoc
class _$MintStateCopyWithImpl<$Res, $Val extends MintState>
    implements $MintStateCopyWith<$Res> {
  _$MintStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MintState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? isLoading = null,
    Object? invoice = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      invoice: freezed == invoice
          ? _value.invoice
          : invoice // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MintStateImplCopyWith<$Res>
    implements $MintStateCopyWith<$Res> {
  factory _$$MintStateImplCopyWith(
          _$MintStateImpl value, $Res Function(_$MintStateImpl) then) =
      __$$MintStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int amount, bool isLoading, String? invoice, String? error});
}

/// @nodoc
class __$$MintStateImplCopyWithImpl<$Res>
    extends _$MintStateCopyWithImpl<$Res, _$MintStateImpl>
    implements _$$MintStateImplCopyWith<$Res> {
  __$$MintStateImplCopyWithImpl(
      _$MintStateImpl _value, $Res Function(_$MintStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MintState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? isLoading = null,
    Object? invoice = freezed,
    Object? error = freezed,
  }) {
    return _then(_$MintStateImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      invoice: freezed == invoice
          ? _value.invoice
          : invoice // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MintStateImpl extends _MintState {
  _$MintStateImpl(
      {required this.amount,
      required this.isLoading,
      required this.invoice,
      required this.error})
      : super._();

  @override
  final int amount;
  @override
  final bool isLoading;
  @override
  final String? invoice;
  @override
  final String? error;

  @override
  String toString() {
    return 'MintState(amount: $amount, isLoading: $isLoading, invoice: $invoice, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MintStateImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.invoice, invoice) || other.invoice == invoice) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, amount, isLoading, invoice, error);

  /// Create a copy of MintState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MintStateImplCopyWith<_$MintStateImpl> get copyWith =>
      __$$MintStateImplCopyWithImpl<_$MintStateImpl>(this, _$identity);
}

abstract class _MintState extends MintState {
  factory _MintState(
      {required final int amount,
      required final bool isLoading,
      required final String? invoice,
      required final String? error}) = _$MintStateImpl;
  _MintState._() : super._();

  @override
  int get amount;
  @override
  bool get isLoading;
  @override
  String? get invoice;
  @override
  String? get error;

  /// Create a copy of MintState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MintStateImplCopyWith<_$MintStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
