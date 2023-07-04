import 'package:dio/dio.dart';
import 'package:eventos_minerva/api_client.dart';
import 'package:eventos_minerva/user_data_bloc.dart';
import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ApiClient _apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder<Response<dynamic>?> (
              future: _apiClient.getUserProfileData(),
              builder: (context, snapshot) {
                String email = "Carregando...";
                if(snapshot.hasData) {
                  email = snapshot.data?.data;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Estou logado como: " + email!),
                    MaterialButton(
                        onPressed: () async {
                          await _apiClient.logout();
                          userDataBloc.sendDataToStream("Deslogado");
                        },
                        color: const Color(0xffd08c22),
                        child: Text('Sair'))
                  ],
                );
              }
          )),
    );
  }
}
