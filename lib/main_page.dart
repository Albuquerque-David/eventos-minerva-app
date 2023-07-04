import 'package:eventos_minerva/home_page.dart';
import 'package:eventos_minerva/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


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

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.all(16.0),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          debugPrint('Card tapped.');
        },
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

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser!;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: Text("Minerva Eventos"),
          actions: <Widget>[ IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Show Snackbar',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a snackbar')));
          },
        )],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Todos",
            ),
            Tab(
              text: "Favoritos",
            ),
          ],
          indicatorColor: Color(0xffd08c22),
            labelColor: Colors.black,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardExample(
                  nome: 'Semana da Computação',
                  data: '25/07 à 28/07',
                  url: 'https://i.ibb.co/Cz7XRkr/ufrj1.jpg',
                ),
                CardExample(
                  nome: 'Hackton do Minervas',
                  data: '05/03 à 14/04',
                  url: 'https://i.ibb.co/bzd35Fm/img1.jpg',
                ),
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
        ],
      ),
    );
  }
}