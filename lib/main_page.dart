import 'package:dio/dio.dart';
import 'package:eventos_minerva/config_page.dart';
import 'package:eventos_minerva/event_page.dart';
import 'package:eventos_minerva/api_client.dart';
import 'package:eventos_minerva/help_page.dart';
import 'package:eventos_minerva/home_page.dart';
import 'package:eventos_minerva/user_data_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Dio _dio = Dio();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class CardExample extends StatelessWidget {
  final String id;
  final String nome;
  final String data;
  final String url;
  final String description;
  final List<Schedule> schedules;

  const CardExample({
    Key? key,
    required this.id,
    required this.nome,
    required this.data,
    required this.description,
    required this.url,
    required this.schedules,
  }) : super(key: key);

  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final String formattedDate =
        '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    final String formattedTime =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$formattedTime $formattedDate';
  }

  void _openNewPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventPage(
          id: id,
          nome: nome,
          description: description,
          data: data,
          url: url,
          schedules: schedules,
        ),
      ),
    ).then((value) {
      if (value != null && value is bool) {
        // Recarrega a página principal quando voltar da página de evento
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(16.0),
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
              image: NetworkImage(url),
            ),
            ListTile(
              title: Text(nome),
              subtitle: Text(formatDate(data)),
            ),
          ],
        ),
      ),
    );
  }
}

class Schedule {
  final String scheduleName;
  final String scheduleHour;
  final String scheduleDescription;

  Schedule({
    required this.scheduleName,
    required this.scheduleHour,
    required this.scheduleDescription,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleName: json['name'],
      scheduleHour: json['hour'],
      scheduleDescription: json['description'],
    );
  }
}

List<Schedule> schedules1 = [
  Schedule(
    scheduleName: 'test1',
    scheduleHour: '2023-05-05 23:15:54.590',
    scheduleDescription: 'test schedule 1',
  ),
  Schedule(
    scheduleName: 'test2',
    scheduleHour: '2023-05-05 23:30:00.000',
    scheduleDescription: 'test schedule 2',
  ),
];

class Evento {
  final String id;
  final String name;
  final String description;
  final String date;
  final String image;
  final List<Schedule> schedules;

  Evento({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.image,
    required this.schedules,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    List<dynamic> schedulesJson = json['schedule'];
    List<Schedule> schedules = schedulesJson
        .map((item) => Schedule.fromJson(item))
        .toList();

    return Evento(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: json['date'],
      image: json['image'],
      schedules: schedules,
    );
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final ApiClient _apiClient = ApiClient();
  late TabController _tabController;
  late String userEmail = '';
  String searchQuery = '';
  List<Evento> eventos = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getUserEmailFromSharedPreferences();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventos Minerva"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Color(0xffd08c22)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Pesquisar',
            onPressed: () {
              showSearch(
                context: context,
                delegate: EventSearchDelegate(
                  eventos: eventos,
                  onSearchChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                ),
              );
            },
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: "Todos",
            ),
            Tab(
              text: "Favoritos",
            ),
          ],
          indicatorColor: const Color(0xffd08c22),
          labelColor: Colors.black,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              child: UserAccountsDrawerHeader(
                accountName: Text(''),
                accountEmail: Text(userEmail),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://kb.rspca.org.au/wp-content/uploads/2021/07/collie-beach-bokeh.jpg'),
                ),
                decoration: const BoxDecoration(
                  color: Color(0xffd08c22), // Cor de fundo amarelo
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ConfigPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_center),
              title: const Text('Ajuda'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HelpPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                await _apiClient.logout(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: FutureBuilder<Response<dynamic>?>(
              future: _apiClient.fetchEvents(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    heightFactor: 5,
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final jsonData = snapshot.data?.data;
                  eventos = (jsonData as List<dynamic>)
                      .map((item) => Evento.fromJson(item))
                      .toList();
                  List<Evento> filteredEvents = eventos.where((evento) {
                    return evento.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                  }).toList();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: filteredEvents
                        .map(
                          (evento) => CardExample(
                        id: evento.id,
                        nome: evento.name,
                        description: evento.description,
                        data: evento.date,
                        url: evento.image,
                        schedules: evento.schedules,
                      ),
                    )
                        .toList(),
                  );
                } else {
                  return const Text('No events found.');
                }
              },
            ),
          ),
          SingleChildScrollView(
            child: FutureBuilder<Response<dynamic>?>(
              future: _apiClient.fetchFavoriteEvents(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    heightFactor: 5,
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final jsonData = snapshot.data?.data;
                  eventos = (jsonData as List<dynamic>)
                      .map((item) => Evento.fromJson(item))
                      .toList();
                  List<Evento> filteredEvents = eventos.where((evento) {
                    return evento.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                  }).toList();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: filteredEvents
                        .map(
                          (evento) => CardExample(
                        id: evento.id,
                        nome: evento.name,
                        description: evento.description,
                        data: evento.date,
                        url: evento.image,
                        schedules: evento.schedules,
                      ),
                    )
                        .toList(),
                  );
                } else {
                  return const Text('No events found.');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getUserEmailFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email') ?? '';
    });
  }
}

class EventSearchDelegate extends SearchDelegate<String> {
  final List<Evento> eventos;
  final ValueChanged<String> onSearchChanged;

  EventSearchDelegate({
    required this.eventos,
    required this.onSearchChanged,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearchChanged(query);
          close(context, '');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Evento> filteredEvents = eventos.where((evento) {
      return evento.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        final Evento evento = filteredEvents[index];

        return CardExample(
          id: evento.id,
          nome: evento.name,
          description: evento.description,
          data: evento.date,
          url: evento.image,
          schedules: evento.schedules,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Evento> filteredEvents = eventos.where((evento) {
      return evento.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        final Evento evento = filteredEvents[index];

        return ListTile(
          title: Text(evento.name),
          onTap: () {
            close(context, evento.name);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(
                  id: evento.id,
                  nome: evento.name,
                  description: evento.description,
                  data: evento.date,
                  url: evento.image,
                  schedules: evento.schedules,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
