import 'package:flutter/material.dart';
import 'package:eventos_minerva/programming_page.dart';

class EventPage extends StatelessWidget {
  final String nome;
  final String data;
  final String url;

  EventPage({required this.nome, required this.data, required this.url});

  void _openProgramming(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProgrammingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos Minerva'),
      ),
      body: SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Align(
            alignment: Alignment.topCenter,
            child:Image(
              width: double.infinity,
              height: 300.0,
              fit: BoxFit.cover,
              image: NetworkImage(this.url),
            ),
          ),
            SizedBox(height: 16),
            Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  this.nome.toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ),
            SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet. Et iusto aliquid est dicta omnis est tempora pariatur qui commodi assumenda qui nemo dolore. In voluptatem perferendis sit quia nobis At omnis dolorem ut quam perspiciatis est nisi illo. Sit illo minima qui voluptate quia et consequuntur atque aut ipsam quis 33 laudantium minima et alias provident.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                    'INFORMAÇÕES DO EVENTO',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            FilledButton.tonal(
                onPressed: () => _openProgramming(context),
                child: const Text('PROGRAMAÇÃO')),
          ],
        ),
      ),
    );
  }
}
