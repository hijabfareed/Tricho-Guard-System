import 'package:al_hair_app/src/common/translations/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';



class DioExceptionError implements Exception {
  // late DioError dioError;

  static String fromDioErrorCustom(DioException dioError, BuildContext context) {
    String errorMessage =S.of(context).oopsSomethingWrong;
    switch (dioError.type) {
      case DioExceptionType.cancel:
        errorMessage =  S.of(context).requestCancelled;
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = S.of(context).connectionTimedOut;
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = S.of(context).receivingTimeout;
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = S.of(context).requestTimeout;
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(dioError.response?.statusCode, context, dioError.response);
        break;
      case DioExceptionType.unknown:
        // if (dioError.message!.contains('SocketException')) {
                 if (dioError.message?.contains('SocketException')??false) {
          errorMessage = S.of(context).noInternet;
          break;
        }
        errorMessage = S.of(context).unexpectedError;
        break;
      default:
        errorMessage = S.of(context).somethingWrong;
        break;
    }
    return errorMessage;
  }

  static String _handleStatusCode(int? statusCode, BuildContext context, Response<dynamic>? response) {
    switch (statusCode) {
      case 400:
        var msgs = response?.data["message"];
        if(msgs!=null && msgs.length>0){
          return msgs;
        }
        return S.of(context).badRequest;
      case 401:
        return S.of(context).authenticationFailed;
      case 403:
        return S.of(context).authenticatedUserNotAllowed;
      case 404:
        var msgs = response?.data["message"];
        if(msgs!=null && msgs.length>0){
          return msgs;
        }
        return S.of(context).resourceNotExist;
      case 405:
        return S.of(context).methodNotAllowed;
      case 415:
        return S.of(context).unsupportedMediaType;
      case 422:
        return S.of(context).dataValidationFailed;
      case 429:
        return S.of(context).tooManyRequests;
      case 500:

        if(null!=response?.data && response?.data['err']!=null && response?.data['err']['message']){
          return response!.data['err']['message'];
        }
        return S.of(context).internalServerError;
      default:
        return S.of(context).oopsSomethingWrong;
    }
  }

  // @override
  // String toString() => errorMessage;

  // @override
  // Widget build(BuildContext context) {
  //   DioException.fromDioError(dioError, context);
  //   return Text(errorMessage);
  // }

}