import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeapp_tt/core/network/dio_client.dart';
import 'package:pokeapp_tt/core/routing/routes.dart';
import 'package:pokeapp_tt/core/theme/theme.dart';
import 'package:pokeapp_tt/features/pokedex/domain/repositories/pokemon_repository_impl.dart';
import 'package:pokeapp_tt/features/pokedex/domain/usecases/get_pokemons_usecase.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/controllers/pokedex_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final dioClient = DioClient.create().dio;
  final repository = PokemonRepositoryImpl(dioClient);
  final getPokemonsUseCase = GetPokemonsUseCase(repository);

  runApp(
    ProviderScope(
      overrides: [
        getPokemonsUseCaseProvider.overrideWithValue(getPokemonsUseCase),
      ],
      child: const PokemonApp(),
    ),
  );
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PokeApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRoutes.router,
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(Icons.catching_pokemon_outlined, size: 120, color: Colors.red),
//             SizedBox(height: 10),
//             Text(
//               'PokeApp',
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
