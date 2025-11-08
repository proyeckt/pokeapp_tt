class PokemonEntity {
  final String name;
  final String imageUrl;

  const PokemonEntity({required this.name, required this.imageUrl});

  int get id {
    final parts = imageUrl.split('/');
    return int.tryParse(parts[parts.length - 2]) ?? 0;
  }
}
