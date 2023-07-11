import 'package:dio/dio.dart';
import 'package:eventos_minerva/event_page.dart';
import 'package:eventos_minerva/api_client.dart';
import 'package:eventos_minerva/home_page.dart';
import 'package:eventos_minerva/user_data_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

final Dio _dio = Dio();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class CardExample extends StatelessWidget {
  final String nome;
  final String data;
  final String url;

  const CardExample({
    Key? key,
    required this.nome,
    required this.data,
    required this.url,
  }) : super(key: key);

  void _openNewPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventPage(nome: this.nome, data: this.data, url: this.url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.all(16.0),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => _openNewPage(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image(
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,
              image: NetworkImage(this.url),
            ),
            ListTile(
              title: Text(this.nome),
              subtitle: Text(this.data),
            ),
          ],
        ),
      ),
    );
  }
}

class Evento {
  final int id;
  final String nome;
  final String data;

  Evento({required this.id, required this.nome, required this.data});

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      nome: json['nome'],
      data: json['data'],
    );
  }
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  final ApiClient _apiClient = ApiClient();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos Minerva"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Pesquisar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a search')),
              );
            },
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Todos",
            ),
            Tab(
              text: "Favoritos",
            ),
            Tab(
              text: "Usuário",
            )
          ],
          indicatorColor: Color(0xffd08c22),
          labelColor: Colors.black,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: FutureBuilder<Response<dynamic>?>(
              future: _apiClient.fetchEvents(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<Evento> eventos = snapshot.data as List<Evento>;
                  print('a1-----\n');
                  print(eventos);
                  print(snapshot);
                  print('b1-----\n');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: eventos!.map((evento) {
                      return CardExample(
                        nome: evento.nome,
                        data: evento.data,
                        url: 'https://example.com/image.jpg',
                      );
                    }).toList(),
                  );
                } else {
                  print('a-----\n');
                  print(snapshot);
                  print('b-----\n');
                  return Text('No events found.');
                }
              },
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardExample(
                  nome: 'Semana da Computação',
                  data: '25/07 à 28/07',
                  url: 'https://i.ibb.co/rFdb0Xf/im3.png',
                ),
                CardExample(
                  nome: 'Hackton do Minervas',
                  data: '05/03 à 14/04',
                  url: 'https://i.ibb.co/QnB7kWj/im2.png',
                ),

              ],
            ),
          ),
          SingleChildScrollView(
            child: FutureBuilder<Response<dynamic>?>(
              future: _apiClient.getUserProfileData(),
              builder: (context, snapshot) {
                String email = "Carregando...";
                if (snapshot.hasData) {
                  email = snapshot.data?.data;
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Estou logado como: " + email),
                    MaterialButton(
                      onPressed: () async {
                        await _apiClient.logout();
                        userDataBloc.sendDataToStream("Deslogado");
                      },
                      color: const Color(0xffd08c22),
                      child: Text('Sair'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
