import 'package:eventos_minerva/home_page.dart';
import 'package:eventos_minerva/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Estou logado como: " + user.email!),
          MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: const Color(0xffd08c22),
              child: Text('Sair'))
        ],
      )),
    );
  }
}
