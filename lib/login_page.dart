import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eventos_minerva/user_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';
import 'home_page.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController() ;
  final ApiClient _apiClient = ApiClient();

  Future signIn() async {
    try {
      var response = await _apiClient.login(_emailController.text.trim(), _passwordController.text.trim(), context);
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.airplane_ticket_sharp,
                color: const Color(0xffd08c22),
                size: 80,
              ),
              SizedBox(height: 65),
              Text(
                'Eventos Minerva',
                style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                    color: const Color(0xffd08c22)
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Seja bem-vindo!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Senha',
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: () async {
                    bool signed = await signIn();
                    if (signed) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage())
                      );
                    }

                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xffd08c22),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Entrar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Não possui conta? ',
                      style: TextStyle(

                      )),
                  Text('Cadastre-se aqui!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ))
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
