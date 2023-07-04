import 'dart:async';

import 'package:dio/dio.dart';
import 'package:eventos_minerva/login_page.dart';
import 'package:eventos_minerva/main_page.dart';
import 'package:eventos_minerva/user_data_bloc.dart';
import 'package:flutter/material.dart';

import 'api_client.dart';


class HomePage extends StatelessWidget {
  final ApiClient _apiClient = ApiClient();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
        stream: userDataBloc.stream,
        builder: (context, snapshot){
          if ( snapshot.hasData && snapshot.data.toString() == "Deslogado") {
            return LoginPage();
          } else if ( snapshot.hasData && snapshot.data.toString() == "Logado" ) {
            return MainPage();
          }
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
