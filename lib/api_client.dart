import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiClient {
  final Dio _dio = Dio();

  Future<Response> signUp(String email, String password, BuildContext context) async {
    try {
      Response response = await _dio.post(
          'https://eventos-minerva-api.vercel.app/signup',
          data: {
            'email': email,
            'password': password
          });
      return response.data;
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return e.response!.data;
    }
  }

  Future<Response> login(String email, String password, BuildContext context) async {
    try {
      Response response = await _dio.post(
        'https://eventos-minerva-api.vercel.app/login',
        data: {
          'email': email,
          'password': password
        },
      );
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String loggedEmail = response.data['email'];
      String token = response.data['token'];
      await sharedPreferences.setString('email', loggedEmail);
      await sharedPreferences.setString('token', token);
      return response;
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarInvalidLogin);
      return e.response!.data;
    }
  }

  Future getEventImage(BuildContext context, String imagePath) async {
    try {
      Response response = await _dio.post(
        'https://eventos-minerva-api.vercel.app/event/image',
        data: {
          'imageName': imagePath,
        },
      );
      String imageUrl = response.data['imageURL'];
      return imageUrl;
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return e.response!.data;
    }
  }

  Future<Response?> fetchEvents(BuildContext context) async {
    try {
      Response response = await _dio.get(
        'https://eventos-minerva-api.vercel.app/events',
      );

      await Future.forEach(response.data as List<dynamic>, (event) async {
        var imageURL = await getEventImage(context, (event as Map<String, dynamic>)["image"]);
        (event)["image"] = imageURL;
      });

      return response;
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return e.response!.data;
    }
  }

  Future<Response> getUserProfileData(BuildContext context) async {
    try {
      Response response = await _dio.get(
        'https://eventos-minerva-api.vercel.app/getUserData',
      );
      return response;
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return e.response!.data;
    }
  }


  Future<Response> logout(BuildContext context) async {
    try {
      Response response = await _dio.post(
        'https://eventos-minerva-api.vercel.app/logout',
      );
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.clear();
      return response;
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return e.response!.data;
    }
  }

  final snackBar = const SnackBar(content: Text(
    'Ocorreu um erro!', textAlign: TextAlign.center,
  ), backgroundColor: Colors.redAccent);

  final snackBarInvalidLogin = const SnackBar(content: Text(
    'Usuário ou senha inválidos!', textAlign: TextAlign.center,
  ), backgroundColor: Colors.redAccent);
}