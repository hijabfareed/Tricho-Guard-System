// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'general_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GeneralResponse _$GeneralResponseFromJson(Map<String, dynamic> json) {
  return _GeneralResponse.fromJson(json);
}

/// @nodoc
mixin _$GeneralResponse {
  int? get status => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  String? get server_encryption_public_key =>
      throw _privateConstructorUsedError;
  String? get random_string => throw _privateConstructorUsedError;
  String? get sign => throw _privateConstructorUsedError;
  String? get enc => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GeneralResponseCopyWith<GeneralResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneralResponseCopyWith<$Res> {
  factory $GeneralResponseCopyWith(
          GeneralResponse value, $Res Function(GeneralResponse) then) =
      _$GeneralResponseCopyWithImpl<$Res, GeneralResponse>;
  @useResult
  $Res call(
      {int? status,
      String? token,
      String? server_encryption_public_key,
      String? random_string,
      String? sign,
      String? enc});
}

/// @nodoc
class _$GeneralResponseCopyWithImpl<$Res, $Val extends GeneralResponse>
    implements $GeneralResponseCopyWith<$Res> {
  _$GeneralResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? token = freezed,
    Object? server_encryption_public_key = freezed,
    Object? random_string = freezed,
    Object? sign = freezed,
    Object? enc = freezed,
  }) {
    return _then(_value.copyWith(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      server_encryption_public_key: freezed == server_encryption_public_key
          ? _value.server_encryption_public_key
          : server_encryption_public_key // ignore: cast_nullable_to_non_nullable
              as String?,
      random_string: freezed == random_string
          ? _value.random_string
          : random_string // ignore: cast_nullable_to_non_nullable
              as String?,
      sign: freezed == sign
          ? _value.sign
          : sign // ignore: cast_nullable_to_non_nullable
              as String?,
      enc: freezed == enc
          ? _value.enc
          : enc // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeneralResponseImplCopyWith<$Res>
    implements $GeneralResponseCopyWith<$Res> {
  factory _$$GeneralResponseImplCopyWith(_$GeneralResponseImpl value,
          $Res Function(_$GeneralResponseImpl) then) =
      __$$GeneralResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? status,
      String? token,
      String? server_encryption_public_key,
      String? random_string,
      String? sign,
      String? enc});
}

/// @nodoc
class __$$GeneralResponseImplCopyWithImpl<$Res>
    extends _$GeneralResponseCopyWithImpl<$Res, _$GeneralResponseImpl>
    implements _$$GeneralResponseImplCopyWith<$Res> {
  __$$GeneralResponseImplCopyWithImpl(
      _$GeneralResponseImpl _value, $Res Function(_$GeneralResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? token = freezed,
    Object? server_encryption_public_key = freezed,
    Object? random_string = freezed,
    Object? sign = freezed,
    Object? enc = freezed,
  }) {
    return _then(_$GeneralResponseImpl(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      server_encryption_public_key: freezed == server_encryption_public_key
          ? _value.server_encryption_public_key
          : server_encryption_public_key // ignore: cast_nullable_to_non_nullable
              as String?,
      random_string: freezed == random_string
          ? _value.random_string
          : random_string // ignore: cast_nullable_to_non_nullable
              as String?,
      sign: freezed == sign
          ? _value.sign
          : sign // ignore: cast_nullable_to_non_nullable
              as String?,
      enc: freezed == enc
          ? _value.enc
          : enc // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeneralResponseImpl implements _GeneralResponse {
  const _$GeneralResponseImpl(
      {this.status,
      this.token,
      this.server_encryption_public_key,
      this.random_string,
      this.sign,
      this.enc});

  factory _$GeneralResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeneralResponseImplFromJson(json);

  @override
  final int? status;
  @override
  final String? token;
  @override
  final String? server_encryption_public_key;
  @override
  final String? random_string;
  @override
  final String? sign;
  @override
  final String? enc;

  @override
  String toString() {
    return 'GeneralResponse(status: $status, token: $token, server_encryption_public_key: $server_encryption_public_key, random_string: $random_string, sign: $sign, enc: $enc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneralResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.server_encryption_public_key,
                    server_encryption_public_key) ||
                other.server_encryption_public_key ==
                    server_encryption_public_key) &&
            (identical(other.random_string, random_string) ||
                other.random_string == random_string) &&
            (identical(other.sign, sign) || other.sign == sign) &&
            (identical(other.enc, enc) || other.enc == enc));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, status, token,
      server_encryption_public_key, random_string, sign, enc);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneralResponseImplCopyWith<_$GeneralResponseImpl> get copyWith =>
      __$$GeneralResponseImplCopyWithImpl<_$GeneralResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeneralResponseImplToJson(
      this,
    );
  }
}

abstract class _GeneralResponse implements GeneralResponse {
  const factory _GeneralResponse(
      {final int? status,
      final String? token,
      final String? server_encryption_public_key,
      final String? random_string,
      final String? sign,
      final String? enc}) = _$GeneralResponseImpl;

  factory _GeneralResponse.fromJson(Map<String, dynamic> json) =
      _$GeneralResponseImpl.fromJson;

  @override
  int? get status;
  @override
  String? get token;
  @override
  String? get server_encryption_public_key;
  @override
  String? get random_string;
  @override
  String? get sign;
  @override
  String? get enc;
  @override
  @JsonKey(ignore: true)
  _$$GeneralResponseImplCopyWith<_$GeneralResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GeneralResponseModel _$GeneralResponseModelFromJson(Map<String, dynamic> json) {
  return _GeneralResponseModel.fromJson(json);
}

/// @nodoc
mixin _$GeneralResponseModel {
  int? get status => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  GeneralResponse? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GeneralResponseModelCopyWith<GeneralResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneralResponseModelCopyWith<$Res> {
  factory $GeneralResponseModelCopyWith(GeneralResponseModel value,
          $Res Function(GeneralResponseModel) then) =
      _$GeneralResponseModelCopyWithImpl<$Res, GeneralResponseModel>;
  @useResult
  $Res call({int? status, String? message, GeneralResponse? data});

  $GeneralResponseCopyWith<$Res>? get data;
}

/// @nodoc
class _$GeneralResponseModelCopyWithImpl<$Res,
        $Val extends GeneralResponseModel>
    implements $GeneralResponseModelCopyWith<$Res> {
  _$GeneralResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GeneralResponse?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GeneralResponseCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $GeneralResponseCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GeneralResponseModelImplCopyWith<$Res>
    implements $GeneralResponseModelCopyWith<$Res> {
  factory _$$GeneralResponseModelImplCopyWith(_$GeneralResponseModelImpl value,
          $Res Function(_$GeneralResponseModelImpl) then) =
      __$$GeneralResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? status, String? message, GeneralResponse? data});

  @override
  $GeneralResponseCopyWith<$Res>? get data;
}

/// @nodoc
class __$$GeneralResponseModelImplCopyWithImpl<$Res>
    extends _$GeneralResponseModelCopyWithImpl<$Res, _$GeneralResponseModelImpl>
    implements _$$GeneralResponseModelImplCopyWith<$Res> {
  __$$GeneralResponseModelImplCopyWithImpl(_$GeneralResponseModelImpl _value,
      $Res Function(_$GeneralResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(_$GeneralResponseModelImpl(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GeneralResponse?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeneralResponseModelImpl implements _GeneralResponseModel {
  const _$GeneralResponseModelImpl({this.status, this.message, this.data});

  factory _$GeneralResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeneralResponseModelImplFromJson(json);

  @override
  final int? status;
  @override
  final String? message;
  @override
  final GeneralResponse? data;

  @override
  String toString() {
    return 'GeneralResponseModel(status: $status, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneralResponseModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, status, message, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneralResponseModelImplCopyWith<_$GeneralResponseModelImpl>
      get copyWith =>
          __$$GeneralResponseModelImplCopyWithImpl<_$GeneralResponseModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeneralResponseModelImplToJson(
      this,
    );
  }
}

abstract class _GeneralResponseModel implements GeneralResponseModel {
  const factory _GeneralResponseModel(
      {final int? status,
      final String? message,
      final GeneralResponse? data}) = _$GeneralResponseModelImpl;

  factory _GeneralResponseModel.fromJson(Map<String, dynamic> json) =
      _$GeneralResponseModelImpl.fromJson;

  @override
  int? get status;
  @override
  String? get message;
  @override
  GeneralResponse? get data;
  @override
  @JsonKey(ignore: true)
  _$$GeneralResponseModelImplCopyWith<_$GeneralResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
