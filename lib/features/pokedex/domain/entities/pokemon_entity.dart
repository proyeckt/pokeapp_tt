class PokemonEntity {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final double height; // meters
  final double weight; // kg
  final int baseExperience;
  final List<String> abilities;
  final String category;
  final String description;
  final double maleRate; // %
  final double femaleRate; // %
  final List<String> weaknesses;

  const PokemonEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.baseExperience,
    required this.abilities,
    required this.category,
    required this.description,
    required this.maleRate,
    required this.femaleRate,
    required this.weaknesses,
  });

  String get formattedId => 'N°${id.toString().padLeft(3, '0')}';
  String get displayHeight => '${height.toStringAsFixed(1)} m';
  String get displayWeight => '${weight.toStringAsFixed(1)} kg';

  factory PokemonEntity.fromJson(Map<String, dynamic> json) {
    return PokemonEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      types:
          (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      baseExperience: json['baseExperience'] as int? ?? 0,
      abilities: (json['abilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      maleRate: (json['maleRate'] as num?)?.toDouble() ?? 0.0,
      femaleRate: (json['femaleRate'] as num?)?.toDouble() ?? 0.0,
      weaknesses: (json['weaknesses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'types': types,
        'height': height,
        'weight': weight,
        'baseExperience': baseExperience,
        'abilities': abilities,
        'category': category,
        'description': description,
        'maleRate': maleRate,
        'femaleRate': femaleRate,
        'weaknesses': weaknesses,
      };
}
