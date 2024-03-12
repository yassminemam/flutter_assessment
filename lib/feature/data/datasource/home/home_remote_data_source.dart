import 'package:dio/dio.dart';

abstract class HomeRemoteDataSource {
  Future<dynamic> getCoutries();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future getCoutries() {
    // TODO: implement getWhoAmIRequest
    throw UnimplementedError();
  }
}