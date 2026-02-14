// ============================================================
// SCREEN - adopt_screen.dart
// Rôle : UI/UX - Écran adoption (filtré catégorie 'adopt')
// ============================================================

import 'package:flutter/material.dart';
import '../models/dog_model.dart';
import '../services/dog_api_service.dart';
import '../services/favorites_service.dart';
import '../widgets/dog_card.dart';
import '../widgets/shimmer_card.dart';
import '../utils/app_theme.dart';
import 'dog_detail_screen.dart';

class AdoptScreen extends StatefulWidget {
  const AdoptScreen({super.key});

  @override
  State<AdoptScreen> createState() => _AdoptScreenState();
}

class _AdoptScreenState extends State<AdoptScreen> {
  final DogApiService _apiService = DogApiService();
  final FavoritesService _favoritesService = FavoritesService();

  List<DogBreed> _dogs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final all = await _apiService.buildDogListings();
      final favIds = await _favoritesService.getFavoriteIds();
      final adoptDogs = all
          .where((d) => d.category == 'adopt')
          .map((d) => d.copyWith(isFavorite: favIds.contains(d.id)))
          .toList();
      if (mounted) setState(() { _dogs = adoptDogs; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _error = e.toString(); });
    }
  }

  Future<void> _toggleFavorite(DogBreed dog) async {
    final newState = await _favoritesService.toggleFavorite(dog.id);
    setState(() {
      final i = _dogs.indexWhere((d) => d.id == dog.id);
      if (i != -1) _dogs[i] = _dogs[i].copyWith(isFavorite: newState);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ───
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.adoptColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🏠', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 6),
                        Text(
                          'Adoption',
                          style: TextStyle(
                            color: AppTheme.adoptColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Donnez un foyer\nà un chien 💜',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ces chiens cherchent une famille aimante.\nL\'adoption est gratuite!',
                    style: TextStyle(
                      color: AppTheme.textMedium,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Banner info
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.adoptColor.withOpacity(0.15),
                          AppTheme.adoptColor.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.adoptColor.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Text('💜', style: TextStyle(fontSize: 22)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Adopter un chien sauve une vie.\nProcess: formulaire → entretien → accueil.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.adoptColor,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // ─── Liste ───
            Expanded(
              child: _isLoading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: 4,
                        itemBuilder: (_, __) => const ShimmerCard(),
                      ),
                    )
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 48, color: AppTheme.error),
                              const SizedBox(height: 12),
                              const Text('Erreur de chargement',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                  onPressed: _load,
                                  child: const Text('Réessayer')),
                            ],
                          ),
                        )
                      : Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: _dogs.length,
                            itemBuilder: (_, i) {
                              final dog = _dogs[i];
                              return DogCard(
                                dog: dog,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DogDetailScreen(dog: dog),
                                    ),
                                  );
                                  _load();
                                },
                                onFavoriteToggle: () =>
                                    _toggleFavorite(dog),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}