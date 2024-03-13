import 'package:dio/dio.dart';
import 'package:flutter_assessment/core/constants/strings/app_strings.dart';
import 'package:flutter_assessment/feature/data/model/home/countries_response_model.dart';

import '../../../../config/end_poits.dart';
import '../../../../core/error/app_server_error.dart';
import '../../../../core/error/exception.dart';
import '../../model/home/services_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<CountriesResponseModel?> getCountries({int? pageIndex});

  Future<ServicesResponseModel?> getServices();
  Future<ServicesResponseModel?> getPopularServices();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<CountriesResponseModel?> getCountries({int? pageIndex}) async {
    try {
      Map<String, dynamic>? queryParams =
          pageIndex == null ? null : {"page": pageIndex};
      var response =
          await dio.get(EndPoints.getCountries, queryParameters: queryParams);
      if (response.statusCode == 200) {
        CountriesResponseModel countriesResponseModel =
            CountriesResponseModel.fromJson(response.data);
        return countriesResponseModel;
      }
    } on DioException catch (ex) {
      AppServerError? error =
          AppServerError.fromJson(ex.response?.data ?? ex.message);
      throw AppException(error?.toString() ?? AppStrings.unknownServerError);
    }
    return null;
  }

  @override
  Future<ServicesResponseModel?> getServices() async {
    try {
      var response = await dio.get(EndPoints.getServices);
      if (response.statusCode == 200) {
        ServicesResponseModel servicesResponseModel =
            ServicesResponseModel.fromJson(response.data);
        return servicesResponseModel;
      }
    } on DioException catch (ex) {
      AppServerError? error =
          AppServerError.fromJson(ex.response?.data ?? ex.message);
      throw AppException(error?.toString() ?? AppStrings.unknownServerError);
    }
    return null;
  }
  @override
  Future<ServicesResponseModel?> getPopularServices() async {
    try {
      var response = await dio.get(EndPoints.getPopularServices);
      if (response.statusCode == 200) {
        ServicesResponseModel popServicesResponseModel =
        ServicesResponseModel.fromJson(response.data);
        return popServicesResponseModel;
      }
    } on DioException catch (ex) {
      AppServerError? error =
      AppServerError.fromJson(ex.response?.data ?? ex.message);
      throw AppException(error?.toString() ?? AppStrings.unknownServerError);
    }
    return null;
  }
}
