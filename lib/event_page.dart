import 'package:flutter/material.dart';
import 'package:eventos_minerva/event_schedule.dart';
import 'package:eventos_minerva/api_client.dart';
import 'package:flutter/services.dart';
import 'main_page.dart';

class EventPage extends StatefulWidget {
  final String id;
  final String nome;
  final String description;
  final String data;
  final String url;
  final List<Schedule> schedules;

  EventPage({
    required this.id,
    required this.nome,
    required this.description,
    required this.data,
    required this.url,
    required this.schedules,
  });

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool favoritado = false;
  bool isFavoriteStatusLoaded = false;
  final ApiClient _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    _initializeFavoriteStatus();
  }

  Future<void> _initializeFavoriteStatus() async {
    try {
      final response = await _apiClient.checkFavorite(widget.id, context);
      setState(() {
        favoritado = response.data == "true";
        isFavoriteStatusLoaded = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking favorite status'),
        ),
      );
    }
  }

  void _openProgramming(BuildContext context, List<Schedule> s) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProgrammingPage(schedules: s)),
    );
  }

  Future<void> _toggleFavoriteStatus() async {
    try {
      if (favoritado) {
        await _apiClient.UnFavorite(widget.id, context);
      } else {
        await _apiClient.Favorite(widget.id, context);
      }
      setState(() {
        favoritado = !favoritado;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error toggling favorite status'),
        ),
      );
    }
  }

  String formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final String formattedDate =
        '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    final String formattedTime =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$formattedTime $formattedDate';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    if (!isFavoriteStatusLoaded) {
      // Exibir um widget de carregamento enquanto aguarda a resposta da requisição
      return Scaffold(
        appBar: AppBar(
          title: Text('Eventos Minerva'),
          systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: Color(0xffd08c22)),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        // Recarregar eventos favoritados
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Eventos Minerva'),
          systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: Color(0xffd08c22)),
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
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.nome.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleFavoriteStatus,
                          child: Icon(
                            favoritado ? Icons.favorite : Icons.favorite_border,
                            color: favoritado ? Colors.red : Colors.black87,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.description.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 16),
                    FilledButton.tonal(
                      key: const Key("scheduleButton"),
                      onPressed: () =>
                          _openProgramming(context, widget.schedules),
                      child: const Text('PROGRAMAÇÃO'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Color(0xffd08c22),
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
                          formatDateTime(widget.data),
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
      ),
    );
  }
}
