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

  Future register(String name, String email, String password, BuildContext context) async {
    // Simulating a registration process
    await Future.delayed(Duration(seconds: 2));

    // Returning a successful response
    return {
      'success': true,
      'message': 'Registration successful!',
    };
  }

  Future<Response> checkFavorite(String id, BuildContext context) async {
    try {
      Response response = await _dio.get(
          'https://eventos-minerva-api.vercel.app/checkFavorite/$id');
      print("aaaaaaaaaa\n");
      print(response.data);
      print("aaaaaaaaaa\n");
      return response;

    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return e.response!.data;
    }
  }

  Future<Response> Favorite(String id, BuildContext context) async {
    try {
      Response response = await _dio.post(
          'https://eventos-minerva-api.vercel.app/favorite/$id');

      return response;

    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return e.response!.data;
    }
  }

  Future<Response> UnFavorite(String id, BuildContext context) async {
    try {
      Response response = await _dio.delete(
          'https://eventos-minerva-api.vercel.app/unfavorite/$id');

      return response;

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

  Future<Response?> fetchFavoriteEvents(BuildContext context) async {
    try {
      Response response = await _dio.get(
        'https://eventos-minerva-api.vercel.app/favorites',
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