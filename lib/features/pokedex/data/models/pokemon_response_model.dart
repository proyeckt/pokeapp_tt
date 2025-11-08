import 'package:freezed_annotation/freezed_annotation.dart';
import 'pokemon_result_model.dart';

part 'pokemon_response_model.freezed.dart';
part 'pokemon_response_model.g.dart';

@freezed
class PokemonResponseModel with _$PokemonResponseModel {
  const factory PokemonResponseModel({
    required int count,
    String? next,
    String? previous,
    required List<PokemonResultModel> results,
  }) = _PokemonResponseModel;

  factory PokemonResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonResponseModelFromJson(json);
}
