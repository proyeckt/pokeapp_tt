// lib/core/mappers/pokemon_type_mapper.dart

import 'package:flutter/material.dart';

class PokemonTypeMapper {
  /// Mapper for Pokémon types: English to Spanish names.
  static const Map<String, String> _typeToSpanishMap = {
    'normal': 'Normal',
    'fire': 'Fuego',
    'water': 'Agua',
    'grass': 'Planta',
    'electric': 'Eléctrico',
    'ice': 'Hielo',
    'fighting': 'Lucha',
    'poison': 'Veneno',
    'ground': 'Tierra',
    'flying': 'Volador',
    'psychic': 'Psíquico',
    'bug': 'Bicho',
    'rock': 'Roca',
    'ghost': 'Fantasma',
    'dragon': 'Dragón',
    'dark': 'Siniestro',
    'steel': 'Acero',
    'fairy': 'Hada',
  };

  /// Mapper for Pokémon types: English to color (using official hex codes).
  static const Map<String, Color> _typeToColorMap = {
    'normal': Color(0xFFA8A77A),
    'fire': Color(0xFFEE8130),
    'water': Color(0xFF6390F0),
    'grass': Color(0xFF7AC74C),
    'electric': Color(0xFFF7D02C),
    'ice': Color(0xFF96D9D6),
    'fighting': Color(0xFFC22E28),
    'poison': Color(0xFFA33EA1),
    'ground': Color(0xFFE2BF65),
    'flying': Color(0xFFA98FF3),
    'psychic': Color(0xFFF95587),
    'bug': Color(0xFFA6B91A),
    'rock': Color(0xFFB6A136),
    'ghost': Color(0xFF735797),
    'dragon': Color(0xFF6F35FC),
    'dark': Color(0xFF705746),
    'steel': Color(0xFFB7B7CE),
    'fairy': Color(0xFFD685AD),
  };

  /// Mapper for Pokémon types: English to image asset path.
  static const Map<String, String> _typeToImagePathMap = {
    'normal': 'assets/images/backgrounds/normal_bg.png',
    'fire': 'assets/images/backgrounds/fire_bg.png',
    'water': 'assets/images/backgrounds/water_bg.png',
    'grass': 'assets/images/backgrounds/grass_bg.png',
    'electric': 'assets/images/backgrounds/electric_bg.png',
    'ice': 'assets/images/backgrounds/ice_bg.png',
    'fighting': 'assets/images/backgrounds/fighting_bg.png',
    'poison': 'assets/images/backgrounds/poison_bg.png',
    'ground': 'assets/images/backgrounds/ground_bg.png',
    'flying': 'assets/images/backgrounds/flying_bg.png',
    'psychic': 'assets/images/backgrounds/psychic_bg.png',
    'bug': 'assets/images/backgrounds/bug_bg.png',
    'rock': 'assets/images/backgrounds/rock_bg.png',
    'ghost': 'assets/images/backgrounds/ghost_bg.png',
    'dragon': 'assets/images/backgrounds/dragon_bg.png',
    'dark': 'assets/images/backgrounds/dark_bg.png',
    'steel': 'assets/images/backgrounds/steel_bg.png',
    'fairy': 'assets/images/backgrounds/fairy_bg.png',
  };

  /// Returns the Spanish name for a given original label Pokémon type.
  static String getSpanishType(String englishType) {
    return _typeToSpanishMap[englishType.toLowerCase()] ?? 'Desconocido';
  }

  /// Returns the color for a given original label Pokémon type.
  static Color getTypeColor(String englishType) {
    return _typeToColorMap[englishType.toLowerCase()] ?? Colors.grey;
  }

  /// Returns the image asset path for a given original label Pokémon type. Pokémon type.
  static String getTypeImagePath(String englishType) {
    return _typeToImagePathMap[englishType.toLowerCase()] ?? '';
  }
}
