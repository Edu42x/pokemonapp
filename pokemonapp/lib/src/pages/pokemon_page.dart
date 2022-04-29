import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart ' as http;
import 'package:pokemonapp/src/database/database.dart';
import 'package:pokemonapp/src/models/favorite_pokemon_model.dart';
import 'dart:math';

class PokemonPage extends StatefulWidget {
  final String? name;

  const PokemonPage({Key? key, this.name}) : super(key: key);

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  List abilitesList = [];
  List gamesList = [];
  List imgList = [];
  List<FavoritePokemon> favorites = [];
  final _random = Random();
  bool? isFavorite;
  int? va;

  late Future myFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = fetchPokemon(widget.name.toString());
    getFavorites(widget.name.toString());
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.name.toString();

    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              Colors.primaries[_random.nextInt(Colors.primaries.length)]
                  [_random.nextInt(9) * 100],
          title: const Text("Pokemones"),
          actions: [
            va == 0
                ? IconButton(
                    onPressed: () {
                      addFavoritos(name);
                    },
                    icon: const Icon(Icons.favorite))
                : IconButton(
                    onPressed: () async {
                      await DBProvider.db.delete(name);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    },
                    icon: Icon(Icons.delete))
          ],
        ),
        body: futureFetch(context, name));
  }

  Widget futureFetch(BuildContext context, String name) {
    return Center(
      child: FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data as Map;

            return ListView(
              children: [
                Center(
                  child: Text(
                    data['name'],
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Altura: " +
                          int.parse(data['height'].toString()).toString(),
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Peso: " +
                          int.parse(data['weight'].toString()).toString(),
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                imgLists(),
                const SizedBox(
                  height: 4,
                ),
                abilitiesList(),
                const SizedBox(
                  height: 4,
                ),
                gameList(),
              ],
            );
          } else if (snapshot.hasError) {
            return ListView(
              children: [
                Text(name),
                const SizedBox(
                  height: 4,
                ),
                imgLists()
              ],
            );
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget abilitiesList() {
    return Column(
      children: [
        const Text(
          'Habilidades',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
          child: GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: abilitesList.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 5,
                childAspectRatio: 1.2,
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    color: Colors
                            .primaries[_random.nextInt(Colors.primaries.length)]
                        [_random.nextInt(9) * 100],
                    elevation: 3,
                    child: Center(child: Text(abilitesList[index]['name'])));
              }),
        ),
      ],
    );
  }

  Widget gameList() {
    return Column(
      children: [
        const Text(
          'Apariciones',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
          child: GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gamesList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 5,
                childAspectRatio: 1.2,
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    color: Colors
                            .primaries[_random.nextInt(Colors.primaries.length)]
                        [_random.nextInt(9) * 100],
                    elevation: 3,
                    child: Center(child: Text(gamesList[index])));
              }),
        ),
      ],
    );
  }

  Widget imgLists() {
    return Container(
      height: 100.0,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Card(
                  elevation: 3,
                  child: CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl: imgList[index]['other']['official-artwork']
                        ['front_default'],
                    placeholder: (context, url) =>
                        Image.asset("assets/pokemon.png"),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/pokemon.png"),
                  ),
                ),
                Card(
                  elevation: 3,
                  child: CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl: imgList[index]['back_default'],
                    placeholder: (context, url) =>
                        Image.asset("assets/pokemon.png"),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/pokemon.png"),
                  ),
                ),
                Card(
                  elevation: 3,
                  child: CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl: imgList[index]['front_default'],
                    placeholder: (context, url) =>
                        Image.asset("assets/pokemon.png"),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/pokemon.png"),
                  ),
                ),
                Card(
                  elevation: 3,
                  child: CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl: imgList[index]['back_shiny'],
                    placeholder: (context, url) =>
                        Image.asset("assets/pokemon.png"),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/pokemon.png"),
                  ),
                ),
                Card(
                  elevation: 3,
                  child: CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl: imgList[index]['front_shiny'],
                    placeholder: (context, url) =>
                        Image.asset("assets/pokemon.png"),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/pokemon.png"),
                  ),
                ),
              ],
            );
          },
          itemCount: imgList.length,
        ),
      ),
    );
  }

  Future fetchPokemon(String name) async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));

    Map<String, dynamic> map = json.decode(response.body);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);

    if (response.statusCode == 200) {
      forFunction(jsonData['abilities'], abilitesList, '');

      forFunction(jsonData['game_indices'], gamesList, "version");

      imgList.add(map['sprites']);

      print(map['sprites']['other']);

      return jsonData;
    } else {
      throw Exception(response.body);
    }
  }

  List forFunction(final data, List lista, String type) {
    if (type == "version") {
      for (var item in data) {
        lista.add(item[type]['name']);
      }
    } else {
      for (var item in data) {
        lista.add(item['ability']);
      }
    }

    return lista;
  }

  Future addFavoritos(String name) async {
    final favoritos = FavoritePokemon(
      name: name,
      front_default: imgList[0]['front_default'],
      back_default: imgList[0]['back_default'],
    );

    await DBProvider.db.addFavorite(favoritos);

    Fluttertoast.showToast(
        msg: favoritos.name.toString() + " agregado a favoritos");
  }

  Future getFavorites(String name) async {
    favorites = await DBProvider.db.getAllFavorites();
    List listName = [];
    for (var item in favorites) {
      listName.add(item.name);
    }
    if (listName.contains(name)) {
    } else {
      va = 0;
      setState(() {});
    }
  }
}
