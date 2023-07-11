import 'package:dio/dio.dart';

import 'main_page.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<Response> signUp(String email, String password) async {
    try {
      Response response = await _dio.post(
          'https://eventos-minerva-api.vercel.app/signup',
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
        'https://eventos-minerva-api.vercel.app/login',
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
  Future<Response?> fetchEvents() async {
    try {
      Response response = await _dio.get(
        'https://eventos-minerva-api.vercel.app/events',
      );
      print(response);
      List<dynamic> jsonList = response.data;
      List<Evento> eventos = jsonList.map((jsonObject) => Evento.fromJson(jsonObject)).toList();
      print(eventos);
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }



  Future<Response> getUserProfileData() async {
    try {
      Response response = await _dio.get(
        'https://eventos-minerva-api.vercel.app/getUserData',
      );
      return response;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }


  Future<Response> logout() async {
    try {
      Response response = await _dio.post(
        'https://eventos-minerva-api.vercel.app/logout',
      );
      return response;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }
}