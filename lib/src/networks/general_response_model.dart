
import 'package:freezed_annotation/freezed_annotation.dart';

part 'general_response_model.freezed.dart';
part 'general_response_model.g.dart';

@Freezed()
class GeneralResponse  with _$GeneralResponse{
  const factory GeneralResponse({
    int? status,
    String? token,
    String? server_encryption_public_key,
    String? random_string,
    String? sign,
    String? enc

  }) = _GeneralResponse;

  factory GeneralResponse.fromJson(Map<String,dynamic> json) => _$GeneralResponseFromJson(json);
}


@Freezed()
class GeneralResponseModel  with _$GeneralResponseModel{
  const factory GeneralResponseModel({
    int? status,
    String? message,
    GeneralResponse? data


  }) = _GeneralResponseModel;

  factory GeneralResponseModel.fromJson(Map<String,dynamic> json) => _$GeneralResponseModelFromJson(json);
}