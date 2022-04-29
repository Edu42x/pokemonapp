import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pokemonapp/src/models/pokemon_model.dart';
import 'package:pokemonapp/src/pages/pokemon_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorites');
              },
              icon: Icon(
                Icons.favorite,
              )),
        ),
        body: futureFetch());
  }
}

Widget futureFetch() {
  return Center(
    child: FutureBuilder<List<Pokemon>>(
      future: fetchPokemon(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Pokemon>? data = snapshot.data;

          return ListView(
            children: listPokemon(context, data!),
          );
        } else if (snapshot.hasError) {
          return const Text("Sin datos");
        }

        return const CircularProgressIndicator();
      },
    ),
  );
}

List<Widget> listPokemon(BuildContext context, List<Pokemon> data) {
  final _random = Random();
  List<Widget> pokemons = [];
  for (var item in data) {
    pokemons.add(ListTile(
      tileColor: Colors.primaries[_random.nextInt(Colors.primaries.length)]
          [_random.nextInt(9) * 100],
      title: Text(
        item.name.toString(),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        size: 30,
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PokemonPage(
                  name: item.name,
                )));
      },
    ));
  }

  return pokemons;
}

Future<List<Pokemon>> fetchPokemon() async {
  final res =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=100'));

  List<Pokemon> pokemon = [];

  if (res.statusCode == 200) {
    String body = utf8.decode(res.bodyBytes);
    final jsonData = jsonDecode(body);

    for (var item in jsonData['results']) {
      pokemon.add(Pokemon(name: item['name'], url: item['url']));
    }

    return pokemon;
  } else {
    throw Exception(res.body);
  }
}
