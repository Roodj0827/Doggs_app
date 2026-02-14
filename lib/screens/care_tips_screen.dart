// ============================================================
// SCREEN - care_tips_screen.dart
// Rôle : UI/UX - Conseils de soin pour chiens
// ============================================================

import 'package:flutter/material.dart';
import '../models/dog_model.dart';
import '../services/dog_api_service.dart';
import '../widgets/care_tip_card.dart';
import '../utils/app_theme.dart';

class CareTipsScreen extends StatefulWidget {
  const CareTipsScreen({super.key});

  @override
  State<CareTipsScreen> createState() => _CareTipsScreenState();
}

class _CareTipsScreenState extends State<CareTipsScreen> {
  final DogApiService _service = DogApiService();
  List<CareTip> _allTips = [];
  List<CareTip> _filtered = [];
  String _activeCategory = 'Tous';

  final Map<String, String> _categories = {
    'Tous': '🐾',
    'nutrition': '🍖',
    'exercise': '🏃',
    'health': '🏥',
    'grooming': '✂️',
    'behavior': '🤝',
    'training': '🎓',
    'safety': '🔒',
  };

  @override
  void initState() {
    super.initState();
    _allTips = _service.getCareTips();
    _filtered = _allTips;
  }

  void _filterByCategory(String category) {
    setState(() {
      _activeCategory = category;
      if (category == 'Tous') {
        _filtered = _allTips;
      } else {
        _filtered =
            _allTips.where((t) => t.category == category).toList();
      }
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
                      color: const Color(0xFF27AE60).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🏥', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 6),
                        Text(
                          'Conseils & Soins',
                          style: TextStyle(
                            color: Color(0xFF27AE60),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Bien prendre soin\nde votre chien 🐾',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // ─── Filtres catégories ───
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _categories.entries.map((e) {
                        final isActive = _activeCategory == e.key;
                        return GestureDetector(
                          onTap: () => _filterByCategory(e.key),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppTheme.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isActive
                                    ? AppTheme.primary
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              '${e.value} ${e.key == 'Tous' ? 'Tous' : e.key[0].toUpperCase() + e.key.substring(1)}',
                              style: TextStyle(
                                color: isActive
                                    ? Colors.white
                                    : AppTheme.textMedium,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // ─── Liste conseils ───
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filtered.length,
                itemBuilder: (_, i) => CareTipCard(tip: _filtered[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}