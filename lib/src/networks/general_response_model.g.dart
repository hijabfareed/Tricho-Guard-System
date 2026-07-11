// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeneralResponseImpl _$$GeneralResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GeneralResponseImpl(
      status: json['status'] as int?,
      token: json['token'] as String?,
      server_encryption_public_key:
          json['server_encryption_public_key'] as String?,
      random_string: json['random_string'] as String?,
      sign: json['sign'] as String?,
      enc: json['enc'] as String?,
    );

Map<String, dynamic> _$$GeneralResponseImplToJson(
        _$GeneralResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'token': instance.token,
      'server_encryption_public_key': instance.server_encryption_public_key,
      'random_string': instance.random_string,
      'sign': instance.sign,
      'enc': instance.enc,
    };

_$GeneralResponseModelImpl _$$GeneralResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GeneralResponseModelImpl(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : GeneralResponse.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GeneralResponseModelImplToJson(
        _$GeneralResponseModelImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
