// ============================================================
// MAIN - main.dart
// Rôle : Point d'entrée de l'application DOGS App
// Équipe : Groupe DOGS
//   - Membre 1 : UI/UX + Navigation
//   - Membre 2 : Couche Data (API, modèles, stockage)
//   - Membre 3 : Features & Tests
// API : Dog CEO (https://dog.ceo/api)
// Stockage : SharedPreferences
// ============================================================

import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/dog_list_screen.dart';
import 'screens/dog_detail_screen.dart';
import 'screens/adopt_screen.dart';
import 'screens/care_tips_screen.dart';
import 'screens/favorites_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DogsApp());
}

class DogsApp extends StatelessWidget {
  const DogsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOGS App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/dogs': (context) => const DogListScreen(),
        '/adopt': (context) => const AdoptScreen(),
        '/care': (context) => const CareTipsScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}