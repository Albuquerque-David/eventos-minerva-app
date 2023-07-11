import 'package:flutter/material.dart';
import 'package:eventos_minerva/event_schedule.dart';

class EventPage extends StatefulWidget {
  final String nome;
  final String data;
  final String url;

  EventPage({required this.nome, required this.data, required this.url});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool favoritado = false;

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
              child: Image(
                width: double.infinity,
                height: 200.0,
                fit: BoxFit.cover,
                image: NetworkImage(widget.url),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        widget.nome.toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            favoritado = !favoritado;
                          });
                        },
                        child: Icon(
                          favoritado ? Icons.favorite : Icons.favorite_border,
                          color: favoritado ? Colors.pink : Colors.black87,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Lorem ipsum dolor sit amet...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () => _openProgramming(context),
                    child: const Text('PROGRAMAÇÃO'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                  SizedBox(height: 32),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'INFORMAÇÕES DO EVENTO',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.black87,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.data,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        color: Colors.black87,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Local",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
