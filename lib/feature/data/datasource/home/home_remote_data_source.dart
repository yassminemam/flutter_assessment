import 'package:dio/dio.dart';
import 'package:flutter_assessment/feature/data/model/home/countries_response_model.dart';

import '../../../../config/end_poits.dart';
import '../../../../core/error/app_server_error.dart';
import '../../../../core/error/exception.dart';

abstract class HomeRemoteDataSource {
  Future<dynamic> getCountries({int? pageIndex});
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
      throw AppException(error?.toString() ?? "Unknown Server Error");
    }
    return null;
  }
}
