// ============================================================
// SERVICE - favorites_service.dart
// Rôle : Couche Data - Stockage local avec SharedPreferences
// ============================================================

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites_ids';

  // ─── Ajouter aux favoris ───
  Future<void> addFavorite(String dogId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (!favorites.contains(dogId)) {
      favorites.add(dogId);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  // ─── Retirer des favoris ───
  Future<void> removeFavorite(String dogId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.remove(dogId);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  // ─── Vérifier si favori ───
  Future<bool> isFavorite(String dogId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.contains(dogId);
  }

  // ─── Récupérer tous les IDs favoris ───
  Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // ─── Basculer l'état favori ───
  Future<bool> toggleFavorite(String dogId) async {
    final fav = await isFavorite(dogId);
    if (fav) {
      await removeFavorite(dogId);
      return false;
    } else {
      await addFavorite(dogId);
      return true;
    }
  }

  // ─── Effacer tous les favoris ───
  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }
}