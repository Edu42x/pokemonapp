import 'package:flutter/material.dart';
import 'package:pokemonapp/src/database/database.dart';
import 'package:pokemonapp/src/models/favorite_pokemon_model.dart';
import 'package:pokemonapp/src/pages/pokemon_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritesPokemonPage extends StatefulWidget {
  const FavoritesPokemonPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPokemonPage> createState() => _FavoritesPokemonPageState();
}

class _FavoritesPokemonPageState extends State<FavoritesPokemonPage> {
  List<FavoritePokemon> favorites = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favoritos'),
        ),
        body: builFavorites());
  }

  Widget builFavorites() {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: favorites.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 1,
          childAspectRatio: 1.2,
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          final favorite = favorites[index];
          return InkWell(
            child: Card(
              elevation: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl: favorite.front_default.toString(),
                    placeholder: (context, url) =>
                        Image.asset("assets/pokemon.png"),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/pokemon.png"),
                  ),
                  Text(
                    favorite.name.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PokemonPage(
                        name: favorite.name,
                      )));
            },
          );
        });
  }

  Future getFavorites() async {
    setState(() => isLoading = true);

    favorites = await DBProvider.db.getAllFavorites();

    setState(() => isLoading = false);
  }
}
