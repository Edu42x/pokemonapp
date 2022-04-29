class FavoritePokemonFields {
  static final List<String> values = [id, name, front_default, back_default];

  static final String id = 'id';

  static final String name = 'name';
  static final String front_default = 'front_default';
  static final String back_default = 'back_default';
}

class FavoritePokemon {
  int? id;
  String? name;
  String? front_default;
  String? back_default;

  FavoritePokemon({this.name, this.front_default, this.back_default, this.id});
  FavoritePokemon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    front_default = json['front_default'];
    back_default = json['back_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['front_default'] = this.front_default;
    data['back_default'] = this.back_default;
    return data;
  }

  FavoritePokemon copy({
    int? id,
    String? name,
    String? front_default,
    String? back_default,
  }) =>
      FavoritePokemon(
          id: id ?? this.id,
          name: name ?? this.name,
          front_default: front_default ?? this.front_default,
          back_default: back_default ?? this.back_default);
}
