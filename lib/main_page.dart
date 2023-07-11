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
  final String description;

  const CardExample({
    Key? key,
    required this.nome,
    required this.data,
    required this.description,
    required this.url,
  }) : super(key: key);

  void _openNewPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventPage(nome: this.nome, description: this.description, data: this.data, url: this.url)),
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
  final String id;
  final String name;
  final String description;
  final String date;
  final String image;

  Evento({required this.id, required this.name, required this.description, required this.date, required this.image});

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: json['date'],
      image: json['image']
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
                  final jsonData = snapshot.data?.data;
                  List<Evento> eventos = (jsonData as List<dynamic>)
                      .map((item) => Evento.fromJson(item))
                      .toList();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: eventos!.map((evento) {
                      return CardExample(
                        nome: evento.name,
                        description: evento.description,
                        data: evento.date,
                        url: 'https://i.ibb.co/QnB7kWj/im2.png',
                      );
                    }).toList(),
                  );
                } else {
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
                  description: "dadsada",
                  data: '25/07 à 28/07',
                  url: 'https://i.ibb.co/rFdb0Xf/im3.png',
                ),
                CardExample(
                  nome: 'Hackton do Minervas',
                  description: "dasdsadas",
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
