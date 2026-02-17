// ============================================================
// SCREEN - dog_list_screen.dart
// Rôle : UI/UX - Liste des chiens à vendre avec filtres
// ============================================================

import 'package:flutter/material.dart';
import '../models/dog_model.dart';
import '../services/dog_api_service.dart';
import '../services/favorites_service.dart';
import '../widgets/dog_card.dart';
import '../widgets/shimmer_card.dart';
import '../utils/app_theme.dart';
import 'dog_detail_screen.dart';

class DogListScreen extends StatefulWidget {
  const DogListScreen({super.key});

  @override
  State<DogListScreen> createState() => _DogListScreenState();
}

class _DogListScreenState extends State<DogListScreen> {
  final DogApiService _apiService = DogApiService();
  final FavoritesService _favoritesService = FavoritesService();

  List<DogBreed> _allDogs = [];
  List<DogBreed> _filteredDogs = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedSize = 'Tous';
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();
  final List<String> _sizes = ['Tous', 'Très Petit', 'Petit', 'Moyen', 'Grand'];

  @override
  void initState() {
    super.initState();
    _loadDogs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDogs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final dogs = await _apiService.buildDogListings();
      final favIds = await _favoritesService.getFavoriteIds();

      final dogsWithFav = dogs
          .where((d) => d.category == 'sell')
          .map((d) => d.copyWith(isFavorite: favIds.contains(d.id)))
          .toList();

      if (mounted) {
        setState(() {
          _allDogs = dogsWithFav;
          _filteredDogs = dogsWithFav;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Impossible de charger les données.\nVérifiez votre connexion Internet.';
        });
      }
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredDogs = _allDogs.where((d) {
        final matchesSize =
            _selectedSize == 'Tous' || d.size == _selectedSize;
        final matchesSearch = _searchQuery.isEmpty ||
            d.name.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesSize && matchesSearch;
      }).toList();
    });
  }

 Future<void> _toggleFavorite(DogBreed dog) async {
  print('🐕 DEBUG: Toggle favori pour ${dog.id}'); // ← AJOUTEZ
  final newState = await _favoritesService.toggleFavorite(dog.id);
  print('🐕 DEBUG: Nouveau state = $newState'); // ← AJOUTEZ
  setState(() {
    final idx = _allDogs.indexWhere((d) => d.id == dog.id);
    if (idx != -1) _allDogs[idx] = _allDogs[idx].copyWith(isFavorite: newState);
    final idx2 = _filteredDogs.indexWhere((d) => d.id == dog.id);
    if (idx2 != -1) _filteredDogs[idx2] = _filteredDogs[idx2].copyWith(isFavorite: newState);
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ───
            _buildHeader(),
            // ─── Contenu ───
            Expanded(
              child: _isLoading
                  ? _buildShimmerGrid()
                  : _errorMessage != null
                      ? _buildError()
                      : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Text('🐕', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 6),
                    Text(
                      'DOGS App',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.textMedium),
                onPressed: _loadDogs,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Trouvez votre\ncompagnon idéal 🐾',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          // ─── Barre de recherche ───
          TextField(
            controller: _searchController,
            onChanged: (v) {
              _searchQuery = v;
              _applyFilters();
            },
            decoration: InputDecoration(
              hintText: 'Rechercher une race...',
              prefixIcon:
                  const Icon(Icons.search, color: AppTheme.primary),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchQuery = '';
                        _applyFilters();
                      },
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          // ─── Filtres taille ───
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _sizes.length,
              itemBuilder: (_, i) {
                final s = _sizes[i];
                final selected = _selectedSize == s;
                return GestureDetector(
                  onTap: () {
                    _selectedSize = s;
                    _applyFilters();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppTheme.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        color: selected ? Colors.white : AppTheme.textMedium,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '${_filteredDogs.length} chien(s) disponible(s)',
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.72,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const ShimmerCard(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: AppTheme.error),
            const SizedBox(height: 16),
            const Text(
              'Connexion impossible',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textMedium, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadDogs,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_filteredDogs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🔍', style: TextStyle(fontSize: 48)),
            SizedBox(height: 12),
            Text(
              'Aucun chien trouvé',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.72,
        ),
        itemCount: _filteredDogs.length,
        itemBuilder: (_, i) {
          final dog = _filteredDogs[i];
          return DogCard(
            dog: dog,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DogDetailScreen(dog: dog),
                ),
              );
              _loadDogs(); // Refresh pour les favoris
            },
            onFavoriteToggle: () => _toggleFavorite(dog),
          );
        },
      ),
    );
  }
}