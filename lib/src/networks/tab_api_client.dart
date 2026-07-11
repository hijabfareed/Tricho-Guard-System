
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:retrofit/http.dart';

import 'general_response_model.dart';


part 'tab_api_client.g.dart';

@RestApi()
abstract class TabApiClient{

  @factoryMethod
  factory TabApiClient(Dio dio, {String baseUrl}) = _TabApiClient;

  // @POST("auth/register")
  // Future<GeneralResponseModel> registerUser(@Body() Map<String, dynamic> queries);


}