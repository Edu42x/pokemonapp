import 'package:flutter/material.dart';
import 'package:pokemonapp/src/pages/home.dart';
import 'package:pokemonapp/src/pages/pokemon_favorios_page.dart';
import 'package:pokemonapp/src/pages/pokemon_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PokemonApp",
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const Home(),
        '/pokemon': (context) => const PokemonPage(),
        '/favorites': (context) => const FavoritesPokemonPage()
      },
    );
  }
}
