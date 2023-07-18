import 'package:eventos_minerva/api_client.dart';
import 'package:eventos_minerva/config_page.dart';
import 'package:eventos_minerva/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
                accountName: Text(''),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo ao aplicativo Eventos Minerva!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Este aplicativo permite que você explore e participe de eventos promovidos pela Universidade Federal do Rio de Janeiro. Aqui você encontrará informações sobre os eventos, sua programação e poderá favoritar os eventos de seu interesse.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _sendEmail,
              child: Text('Entre em Contato Conosco'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xffd08c22),
                textStyle: TextStyle(
                  color: Colors.black87
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getUserEmailFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email') ?? '';
    });

  }

  void _sendEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'contato@eventosminerva.com',
      query: 'subject=Dúvida sobre o aplicativo Eventos Minerva',
    );
    final String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Não foi possível abrir o aplicativo de e-mail.'),
      ));
    }
  }
}
