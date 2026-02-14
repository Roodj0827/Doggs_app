// ============================================================
// SERVICE - dog_api_service.dart
// Rôle : Couche Data - Appels API + Cache local
// API utilisée : Dog CEO API (https://dog.ceo/api)
// ============================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dog_model.dart';

class DogApiService {
  static const String _baseUrl = 'https://dog.ceo/api';
  static const String _cacheKeyImages = 'cached_dog_images';
  static const String _cacheTimestamp = 'cache_timestamp';

  // ─── Récupère plusieurs images aléatoires depuis l'API ───
  Future<List<String>> fetchDogImages({int count = 12}) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_cacheTimestamp) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final isCacheValid = (now - timestamp) < 3600000;

    if (isCacheValid) {
      final cached = prefs.getStringList(_cacheKeyImages);
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
    }

    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/breeds/image/random/$count'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final images = List<String>.from(data['message']);
        await prefs.setStringList(_cacheKeyImages, images);
        await prefs.setInt(_cacheTimestamp, now);
        return images;
      }
    } catch (e) {
      final cached = prefs.getStringList(_cacheKeyImages);
      if (cached != null && cached.isNotEmpty) return cached;
      rethrow;
    }
    return [];
  }

  // ─── Construit la liste locale des annonces chiens ───
  Future<List<DogBreed>> buildDogListings() async {
    final images = await fetchDogImages(count: 12);

    final rawData = <Map<String, dynamic>>[
      {
        'id': '1',
        'name': 'Golden Retriever',
        'description': 'Chien doux, intelligent et loyal. Parfait pour les familles avec enfants. Très sociable et facile à dresser.',
        'price': 800.0,
        'size': 'Grand',
        'temperament': 'Amical, Fiable, Digne de confiance',
        'isAvailable': true,
        'ageMonths': 3,
        'category': 'sell',
      },
      {
        'id': '2',
        'name': 'French Bulldog',
        'description': 'Petit chien espiègle ne nécessitant pas beaucoup d\'espace. Idéal pour les appartements en ville.',
        'price': 1200.0,
        'size': 'Petit',
        'temperament': 'Adaptable, Joueur, Intelligent',
        'isAvailable': true,
        'ageMonths': 4,
        'category': 'sell',
      },
      {
        'id': '3',
        'name': 'Labrador Retriever',
        'description': 'Chien affectueux avec beaucoup d\'énergie. Excellent pour les familles actives. À adopter !',
        'price': 0.0,
        'size': 'Grand',
        'temperament': 'Sociable, Actif, Amical',
        'isAvailable': true,
        'ageMonths': 6,
        'category': 'adopt',
      },
      {
        'id': '4',
        'name': 'Berger Allemand',
        'description': 'Chien intelligent et protecteur. Excellent pour la sécurité et le dressage avancé.',
        'price': 900.0,
        'size': 'Grand',
        'temperament': 'Courageux, Confiant, Intelligent',
        'isAvailable': true,
        'ageMonths': 8,
        'category': 'sell',
      },
      {
        'id': '5',
        'name': 'Caniche',
        'description': 'Chien hypoallergénique et très intelligent. Convient à toute la famille. À adopter !',
        'price': 0.0,
        'size': 'Moyen',
        'temperament': 'Intelligent, Actif, Alerte',
        'isAvailable': true,
        'ageMonths': 5,
        'category': 'adopt',
      },
      {
        'id': '6',
        'name': 'Beagle',
        'description': 'Chien curieux et joyeux. Parfait pour les enfants. Bon flair pour les activités outdoor.',
        'price': 500.0,
        'size': 'Petit',
        'temperament': 'Joyeux, Amical, Curieux',
        'isAvailable': true,
        'ageMonths': 7,
        'category': 'sell',
      },
      {
        'id': '7',
        'name': 'Husky Sibérien',
        'description': 'Chien magnifique aux yeux bleus. Très énergique, parfait pour les personnes actives.',
        'price': 1100.0,
        'size': 'Grand',
        'temperament': 'Loyal, Doux, Espiègle',
        'isAvailable': true,
        'ageMonths': 4,
        'category': 'sell',
      },
      {
        'id': '8',
        'name': 'Chihuahua',
        'description': 'Le plus petit chien du monde. Très affectueux et courageux malgré sa petite taille.',
        'price': 600.0,
        'size': 'Tres Petit',
        'temperament': 'Charmant, Gracieux, Courageux',
        'isAvailable': false,
        'ageMonths': 10,
        'category': 'sell',
      },
      {
        'id': '9',
        'name': 'Border Collie',
        'description': 'Le chien le plus intelligent du monde. Excellent pour les sports canins.',
        'price': 850.0,
        'size': 'Moyen',
        'temperament': 'Energique, Intelligent, Loyal',
        'isAvailable': true,
        'ageMonths': 3,
        'category': 'sell',
      },
      {
        'id': '10',
        'name': 'Shih Tzu',
        'description': 'Chien affectueux et doux. Magnifique pelage. À adopter, cherche famille aimante.',
        'price': 0.0,
        'size': 'Petit',
        'temperament': 'Affectueux, Joueur, Doux',
        'isAvailable': true,
        'ageMonths': 18,
        'category': 'adopt',
      },
      {
        'id': '11',
        'name': 'Rottweiler',
        'description': 'Chien robuste et loyal. Excellent gardien. Dressage recommandé dès le jeune âge.',
        'price': 700.0,
        'size': 'Grand',
        'temperament': 'Loyal, Confiant, Courageux',
        'isAvailable': true,
        'ageMonths': 5,
        'category': 'sell',
      },
      {
        'id': '12',
        'name': 'Dalmatien',
        'description': 'Chien unique aux taches noires. Très actif et joueur. Idéal pour les familles sportives.',
        'price': 750.0,
        'size': 'Grand',
        'temperament': 'Vif, Joueur, Sensible',
        'isAvailable': true,
        'ageMonths': 6,
        'category': 'adopt',
      },
    ];

    return List<DogBreed>.generate(rawData.length, (int i) {
      final Map<String, dynamic> item = Map<String, dynamic>.from(rawData[i]);
      item['imageUrl'] = i < images.length
          ? images[i]
          : 'https://images.dog.ceo/breeds/husky/n02110185_10047.jpg';
      return DogBreed.fromJson(item);
    });
  }

  // ─── Conseils de soin locaux ───
  List<CareTip> getCareTips() {
    return <CareTip>[
      CareTip(
        id: '1',
        title: 'Alimentation equilibree',
        description: 'Donnez a votre chien une nourriture adaptee a sa taille et son age. '
            'Fractionnez les repas en 2 fois par jour. Evitez les aliments comme le chocolat, '
            'les raisins et les oignons qui sont toxiques pour les chiens.',
        emoji: '🍖',
        category: 'nutrition',
      ),
      CareTip(
        id: '2',
        title: 'Exercice quotidien',
        description: 'Tous les chiens ont besoin d exercice regulier. Les grandes races ont besoin '
            'd au moins 1-2 heures de marche par jour. Les petites races peuvent se contenter '
            'de 30 minutes. L exercice previent l obesite et les problemes comportementaux.',
        emoji: '🏃',
        category: 'exercise',
      ),
      CareTip(
        id: '3',
        title: 'Visites veterinaires',
        description: 'Prevoyez au moins une visite annuelle chez le veterinaire. '
            'Maintenez les vaccinations a jour (rage, parvovirose, etc.). '
            'Traitez regulierement contre les puces, tiques et vers.',
        emoji: '🏥',
        category: 'health',
      ),
      CareTip(
        id: '4',
        title: 'Toilettage regulier',
        description: 'Brossez votre chien selon sa race (quotidien pour les longs poils, '
            'hebdomadaire pour les courts). Nettoyez les oreilles, coupez les griffes et '
            'brossez les dents 2-3 fois par semaine pour eviter les caries.',
        emoji: '✂️',
        category: 'grooming',
      ),
      CareTip(
        id: '5',
        title: 'Socialisation',
        description: 'Exposez votre chiot a diverses personnes, animaux et environnements '
            'des le plus jeune age (3-14 semaines). Un chien bien socialise est '
            'moins stresse et plus equilibre tout au long de sa vie.',
        emoji: '🤝',
        category: 'behavior',
      ),
      CareTip(
        id: '6',
        title: 'Dressage positif',
        description: 'Utilisez le renforcement positif : recompensez les bons comportements '
            'avec des friandises ou des felicitations. Ne punissez jamais physiquement. '
            'Commencez l apprentissage des ordres de base des 8 semaines.',
        emoji: '🎓',
        category: 'training',
      ),
      CareTip(
        id: '7',
        title: 'Hydratation',
        description: 'Assurez-vous que votre chien a toujours acces a de l eau fraiche et propre. '
            'Un chien de 10 kg a besoin d environ 500ml d eau par jour. '
            'Changez l eau au moins deux fois par jour.',
        emoji: '💧',
        category: 'nutrition',
      ),
      CareTip(
        id: '8',
        title: 'Securite a la maison',
        description: 'Securisez votre maison : rangez les produits chimiques, medicaments et '
            'plantes toxiques hors de portee. Utilisez une laisse en promenade. '
            'Pucez votre chien et mettez-lui un collier avec vos coordonnees.',
        emoji: '🔒',
        category: 'safety',
      ),
    ];
  }
}