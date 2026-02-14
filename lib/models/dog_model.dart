// ============================================================
// MODELS - dog_model.dart
// Rôle : Couche Data - Définition des modèles + JSON parsing
// ============================================================

class DogBreed {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final double price;
  final String size;
  final String temperament;
  final bool isAvailable;
  final int ageMonths;
  final String category; // 'sell' ou 'adopt'
  bool isFavorite;

  DogBreed({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.size,
    required this.temperament,
    required this.isAvailable,
    required this.ageMonths,
    required this.category,
    this.isFavorite = false,
  });

  factory DogBreed.fromJson(Map<String, dynamic> json) {
    return DogBreed(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      size: json['size'] ?? 'Medium',
      temperament: json['temperament'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      ageMonths: json['ageMonths'] ?? 6,
      category: json['category'] ?? 'sell',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'price': price,
      'size': size,
      'temperament': temperament,
      'isAvailable': isAvailable,
      'ageMonths': ageMonths,
      'category': category,
      'isFavorite': isFavorite,
    };
  }

  DogBreed copyWith({bool? isFavorite}) {
    return DogBreed(
      id: id,
      name: name,
      imageUrl: imageUrl,
      description: description,
      price: price,
      size: size,
      temperament: temperament,
      isAvailable: isAvailable,
      ageMonths: ageMonths,
      category: category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class CareTip {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final String category;

  CareTip({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.category,
  });

  factory CareTip.fromJson(Map<String, dynamic> json) {
    return CareTip(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      emoji: json['emoji'] ?? '🐾',
      category: json['category'] ?? 'general',
    );
  }
}