import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokeapp_tt/core/presentation/pages/soon_page.dart';
import 'package:pokeapp_tt/core/theme/colors.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/pages/favorites_page.dart';
import 'package:pokeapp_tt/features/pokedex/presentation/pages/pokedex_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _pages = [
    PokedexPage(),
    SoonPage(),
    FavoritesPage(),
    SoonPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: _pages[_currentIndex],
        bottomNavigationBar: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                    color: AppColors.blackBoxShadowColor,
                    blurRadius: 3,
                    offset: const Offset(0, -1)),
              ],
            ),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: BottomNavigationBar(
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.catching_pokemon),
                    label: 'Pokédex',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.globe),
                    label: 'Regiones',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'Favoritos',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Perfil'),
                ],
                unselectedLabelStyle: TextStyle(
                    color: AppColors.lightBlackColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
                selectedLabelStyle: TextStyle(
                    color: AppColors.tertiaryColor,
                    fontWeight: FontWeight.w700),
              ),
            )));
  }
}
