// ============================================================
// SCREEN - favorites_screen.dart
// Rôle : UI/UX + Data - Affichage des chiens favoris
//        Utilise SharedPreferences via FavoritesService
// ============================================================

import 'package:flutter/material.dart';
import '../models/dog_model.dart';
import '../services/dog_api_service.dart';
import '../services/favorites_service.dart';
import '../widgets/dog_card.dart';
import '../utils/app_theme.dart';
import 'dog_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with AutomaticKeepAliveClientMixin {
  final DogApiService _apiService = DogApiService();
  final FavoritesService _favoritesService = FavoritesService();

  List<DogBreed> _favoriteDogs = [];
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => false; // Refresh à chaque visite

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }

 Future<void> _loadFavorites() async {
  setState(() => _isLoading = true);
  try {
    final all = await _apiService.buildDogListings();
    final favIds = await _favoritesService.getFavoriteIds();
    
    // ← NOUVEAU : Conversion en String pour comparaison
    final favIdStrings = favIds.map((id) => id.toString()).toSet();
    
    final favs = all
        .where((d) => favIdStrings.contains(d.id.toString()))  // ← MODIFIÉ
        .map((d) => d.copyWith(isFavorite: true))
        .toList();
        
    if (mounted) setState(() { _favoriteDogs = favs; _isLoading = false; });
  } catch (_) {
    if (mounted) setState(() => _isLoading = false);
  }
}

  Future<void> _removeFavorite(DogBreed dog) async {
    await _favoritesService.removeFavorite(dog.id);
    setState(() => _favoriteDogs.removeWhere((d) => d.id == dog.id));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${dog.name} retiré des favoris'),
          backgroundColor: AppTheme.textMedium,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'Annuler',
            textColor: Colors.white,
            onPressed: () async {
              await _favoritesService.addFavorite(dog.id);
              _loadFavorites();
            },
          ),
        ),
      );
    }
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Vider les favoris'),
        content: const Text(
            'Voulez-vous retirer tous les chiens de vos favoris ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Vider'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _favoritesService.clearFavorites();
      setState(() => _favoriteDogs.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ───
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mes Favoris ❤️',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_favoriteDogs.length} chien(s) sauvegardé(s)',
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_favoriteDogs.isNotEmpty)
                    TextButton.icon(
                      onPressed: _clearAll,
                      icon: const Icon(Icons.delete_outline,
                          color: AppTheme.error, size: 18),
                      label: const Text('Vider',
                          style: TextStyle(color: AppTheme.error)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ─── Contenu ───
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primary))
                  : _favoriteDogs.isEmpty
                      ? _buildEmpty()
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
                            itemCount: _favoriteDogs.length,
                            itemBuilder: (_, i) {
                              final dog = _favoriteDogs[i];
                              return DogCard(
                                dog: dog,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            DogDetailScreen(dog: dog)),
                                  );
                                  _loadFavorites();
                                },
                                onFavoriteToggle: () =>
                                    _removeFavorite(dog),
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

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_border,
                size: 64, color: Colors.red),
          ),
          const SizedBox(height: 20),
          const Text(
            'Aucun favori pour l\'instant',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Appuyez sur ❤️ sur un chien\npour l\'ajouter ici',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textMedium, height: 1.5),
          ),
        ],
      ),
    );
  }
}