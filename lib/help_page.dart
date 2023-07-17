import 'package:eventos_minerva/api_client.dart';
import 'package:eventos_minerva/config_page.dart';
import 'package:eventos_minerva/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage>
    with SingleTickerProviderStateMixin {
  late String userEmail = '';
  final ApiClient _apiClient = ApiClient();
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    _getUserEmailFromSharedPreferences();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventos Minerva"),
        backgroundColor: Colors.white,
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
        systemOverlayStyle:
        const SystemUiOverlayStyle(statusBarColor: Color(0xffd08c22)),
        actions: <Widget>[],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              child: UserAccountsDrawerHeader(
                accountName: Text('Nome do usuário'),
                accountEmail: Text(userEmail),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://kb.rspca.org.au/wp-content/uploads/2021/07/collie-beach-bokeh.jpg'),
                ),
                decoration: const BoxDecoration(
                  color: Color(0xffd08c22),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfigPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_center),
              title: const Text('Ajuda'),
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpPage()),
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
      body: Center(
        child: Text('Página Ajuda!'),
      ),
    );
  }

  Future<void> _getUserEmailFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('email') ?? '';
  }
}
