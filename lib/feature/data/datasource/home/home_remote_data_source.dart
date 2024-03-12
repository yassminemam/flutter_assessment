import 'package:dio/dio.dart';

abstract class HomeRemoteDataSource {
  Future<dynamic> getWhoAmIRequest();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future getWhoAmIRequest() {
    // TODO: implement getWhoAmIRequest
    throw UnimplementedError();
  }
}