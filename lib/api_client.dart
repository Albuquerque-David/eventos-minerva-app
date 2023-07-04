import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<Response> signUp(String email, String password) async {
    try {
      Response response = await _dio.post(
          'http://192.168.0.73:3000/signup',
          data: {
            'email': email,
            'password': password
          });
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Response?> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        'http://192.168.0.73:3000/login',
        data: {
          'email': email,
          'password': password
        },
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response> getUserProfileData() async {
    try {
      Response response = await _dio.get(
        'http://192.168.0.73:3000/getUserData',
      );
      return response;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }


  Future<Response> logout() async {
    try {
      Response response = await _dio.post(
        'http://192.168.0.73:3000/logout',
      );
      return response;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }
}