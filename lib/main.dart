import 'package:flutter/material.dart';

void main() {
  runApp(const PokemonApp());
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.catching_pokemon_outlined, size: 120, color: Colors.red),
            SizedBox(height: 10),
            Text(
              'PokeApp',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
