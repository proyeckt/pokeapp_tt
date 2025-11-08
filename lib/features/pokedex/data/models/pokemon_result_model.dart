import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_result_model.freezed.dart';
part 'pokemon_result_model.g.dart';

@freezed
class PokemonResultModel with _$PokemonResultModel {
  const factory PokemonResultModel({
    required String name,
    required String url,
  }) = _PokemonResultModel;

  factory PokemonResultModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonResultModelFromJson(json);
}
