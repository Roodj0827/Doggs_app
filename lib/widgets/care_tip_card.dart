// ============================================================
// WIDGET - care_tip_card.dart
// Rôle : UI/UX - Carte pour les conseils de soin
// ============================================================

import 'package:flutter/material.dart';
import '../models/dog_model.dart';
import '../utils/app_theme.dart';

class CareTipCard extends StatelessWidget {
  final CareTip tip;

  const CareTipCard({super.key, required this.tip});

  Color _categoryColor() {
    switch (tip.category) {
      case 'nutrition':
        return const Color(0xFF27AE60);
      case 'exercise':
        return const Color(0xFF2980B9);
      case 'health':
        return const Color(0xFFE74C3C);
      case 'grooming':
        return const Color(0xFF9B59B6);
      case 'behavior':
        return const Color(0xFFF39C12);
      case 'training':
        return const Color(0xFF1ABC9C);
      case 'safety':
        return const Color(0xFFE67E22);
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor();
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji + couleur sidebar
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(tip.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 6),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          // Contenu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tip.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textMedium,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}