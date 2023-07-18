import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiClient {
  final Dio _dio = Dio();

  Future signUp(String email, String password, BuildContext context) async {
    try {
      Response response = await _dio.post(
          'https://eventos-minerva-api.vercel.app/signup',
          data: {
            'email': email,
            'password': password
          });
      ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
      return;
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return e.response!.data;
    }
  }

  Future<Response> checkFavorite(String id, BuildContext context) async {
    try {
      //print(id);
      String token = await getToken();
      Response response = await _dio.get(
          'https://eventos-minerva-api.vercel.app/checkFavorite/$id',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
      ));
      print("check:\n");
      print(response);
      print("\n----\n");
      return response;

    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return e.response!.data;
    }
  }

  Future<Response> Favorite(String id, BuildContext context) async {
    try {
      String token = await getToken();
      Response response = await _dio.post(
          'https://eventos-minerva-api.vercel.app/favorite',
        data: {
          'idEvent': id,
        },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
      ));

      return response;

    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return e.response!.data;
    }
  }

  Future<Response> UnFavorite(String id, BuildContext context) async {
    print("\naaaaaaaaaaaaaaa\n");
    try {
      String token = await getToken();
      Response response = await _dio.delete(
          'https://eventos-minerva-api.vercel.app/unfavorite',
          data: {
            'idEvent': id,
          },
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
              },
      ));

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
      String token = await getToken();
      Response response = await _dio.get(
        'https://eventos-minerva-api.vercel.app/favorites',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        )
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
      String token = await getToken();
      Response response = await _dio.get(
        'https://eventos-minerva-api.vercel.app/getUserData',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        )
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

  Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    if(token!.isEmpty) {
      return '';
    } else {
      return token;
    }
  }

  final snackBar = const SnackBar(content: Text(
    'Ocorreu um erro!', textAlign: TextAlign.center,
  ), backgroundColor: Colors.redAccent);

  final snackBarInvalidLogin = const SnackBar(content: Text(
    'Usuário ou senha inválidos!', textAlign: TextAlign.center,
  ), backgroundColor: Colors.redAccent);

  final snackBarSuccess = const SnackBar(content: Text(
    'Cadastro realizado com sucesso!', textAlign: TextAlign.center,
  ), backgroundColor: Colors.greenAccent);
}