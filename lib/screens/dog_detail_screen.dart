// ============================================================
// SCREEN - dog_detail_screen.dart
// Rôle : UI/UX - Détail d'un chien + commande
// ============================================================

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/dog_model.dart';
import '../services/favorites_service.dart';
import '../utils/app_theme.dart';

class DogDetailScreen extends StatefulWidget {
  final DogBreed dog;

  const DogDetailScreen({super.key, required this.dog});

  @override
  State<DogDetailScreen> createState() => _DogDetailScreenState();
}

class _DogDetailScreenState extends State<DogDetailScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.dog.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    final newState = await _favoritesService.toggleFavorite(widget.dog.id);
    setState(() => _isFavorite = newState);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newState
                ? '❤️ Ajouté aux favoris!'
                : '💔 Retiré des favoris',
          ),
          backgroundColor:
              newState ? AppTheme.success : AppTheme.textMedium,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Text('🐶 ', style: TextStyle(fontSize: 24)),
            Expanded(
              child: Text(
                widget.dog.category == 'adopt'
                    ? 'Demande d\'adoption'
                    : 'Commander ce chien',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.dog.category == 'adopt'
                  ? 'Merci pour votre intérêt pour ${widget.dog.name}!'
                  : 'Vous souhaitez acheter ${widget.dog.name} pour \$${widget.dog.price.toStringAsFixed(0)}',
              style: const TextStyle(color: AppTheme.textMedium),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: AppTheme.primary),
                      SizedBox(width: 8),
                      Text('+509 3700-0000',
                          style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.email, size: 16, color: AppTheme.primary),
                      SizedBox(width: 8),
                      Text('contact@dogsapp.com',
                          style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(widget.dog.category == 'adopt'
                      ? '✅ Demande envoyée! Nous vous contacterons bientôt.'
                      : '✅ Commande envoyée! Paiement à la livraison.'),
                  backgroundColor: AppTheme.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: Text(
                widget.dog.category == 'adopt' ? 'Envoyer' : 'Confirmer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dog = widget.dog;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // ─── SliverAppBar avec image ───
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: AppTheme.textDark),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: _toggleFavorite,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : AppTheme.textDark,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: dog.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                          child: CircularProgressIndicator(
                              color: AppTheme.primary)),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.pets,
                          size: 80, color: AppTheme.textLight),
                    ),
                  ),
                  // Gradient bas
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badge catégorie
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: dog.category == 'adopt'
                            ? AppTheme.adoptColor
                            : AppTheme.sellColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        dog.category == 'adopt'
                            ? '🏠 À adopter'
                            : '🛒 À vendre',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Contenu détail ───
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.background,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom + prix
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          dog.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          dog.category == 'adopt'
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.adoptColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'Gratuit',
                                    style: TextStyle(
                                      color: AppTheme.adoptColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : Text(
                                  '\$${dog.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: dog.isAvailable
                                  ? AppTheme.success.withOpacity(0.1)
                                  : AppTheme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              dog.isAvailable
                                  ? '✓ Disponible'
                                  : '✗ Indisponible',
                              style: TextStyle(
                                color: dog.isAvailable
                                    ? AppTheme.success
                                    : AppTheme.error,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Caractéristiques
                  Row(
                    children: [
                      _infoChip(Icons.straighten, dog.size),
                      const SizedBox(width: 10),
                      _infoChip(Icons.cake, '${dog.ageMonths} mois'),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Description
                  const Text(
                    'À propos',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dog.description,
                    style: const TextStyle(
                      color: AppTheme.textMedium,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Tempérament
                  const Text(
                    'Tempérament',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: dog.temperament
                        .split(', ')
                        .map((t) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppTheme.primary
                                        .withOpacity(0.3)),
                              ),
                              child: Text(
                                t,
                                style: const TextStyle(
                                  color: AppTheme.primaryDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 30),

                  // Bouton action
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: dog.isAvailable ? _showContactDialog : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dog.category == 'adopt'
                            ? AppTheme.adoptColor
                            : AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        dog.category == 'adopt'
                            ? '🏠  Demander l\'adoption'
                            : '🛒  Acheter maintenant',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : AppTheme.primary,
                        size: 18,
                      ),
                      label: Text(
                        _isFavorite
                            ? 'Retiré des favoris'
                            : 'Ajouter aux favoris',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}