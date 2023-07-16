import 'dart:async';

import 'package:dio/dio.dart';
import 'package:eventos_minerva/event_page.dart';
import 'package:eventos_minerva/login_page.dart';
import 'package:eventos_minerva/main_page.dart';
import 'package:eventos_minerva/user_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    checkToken().then((value) {
      if(value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage())
        );
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage())
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<bool> checkToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString('token') != null) {
      return true;
    } else {
      return false;
    }
  }
}
