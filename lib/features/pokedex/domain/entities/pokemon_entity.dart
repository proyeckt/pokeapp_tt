class PokemonEntity {
  final int id;
  final String name;
  final String imageUrl;

  const PokemonEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory PokemonEntity.fromJson(Map<String, dynamic> json) => PokemonEntity(
        id: json['id'] as int,
        name: json['name'] as String,
        imageUrl: json['imageUrl'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
      };
}
