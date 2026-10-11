import 'package:flutter/material.dart';

const List<String> mealTypes = ['Sarapan', 'Makan Siang', 'Makan Malam'];
const Map<String, String> mealTimes = {
  'Sarapan': '07.00',
  'Makan Siang': '12.00',
  'Makan Malam': '19.00',
};
const List<String> shoppingCategories = ['Sayuran', 'Protein', 'Karbohidrat', 'Buah', 'Lainnya'];
const List<String> goalOptions = [
  'Hidup Sehat',
  'Menurunkan Berat Badan',
  'Menaikkan Berat Badan',
  'Menjaga Berat Badan',
];

Color categoryColor(String c) {
  switch (c) {
    case 'Sayuran':
      return const Color(0xFFA5D6A7);
    case 'Protein':
      return const Color(0xFFEF9A9A);
    case 'Karbohidrat':
      return const Color(0xFFFFE082);
    case 'Buah':
      return const Color(0xFFFFCC80);
    default:
      return const Color(0xFFE0E0E0);
  }
}

String formatQty(double amount, String unit) {
  final s = amount % 1 == 0 ? amount.toInt().toString() : amount.toStringAsFixed(1);
  return '$s $unit';
}

class Ingredient {
  final String name;
  final double amount;
  final String unit;
  final String category;
  const Ingredient(this.name, this.amount, this.unit, this.category);
}

class Recipe {
  final String id;
  final String name;
  final String category;
  final String description;
  final int time;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final double rating;
  final Color color;
  final bool vegetarian;
  final List<Ingredient> ingredients;
  final List<String> steps;

  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.time,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.rating,
    required this.color,
    required this.vegetarian,
    required this.ingredients,
    required this.steps,
  });

  /// Lokasi foto: assets/images/<id>.jpg (contoh: assets/images/r1.jpg)
  String get imagePath => 'assets/images/$id.jpg';
}

Recipe? recipeById(String id) {
  for (final r in allRecipes) {
    if (r.id == id) return r;
  }
  return null;
}

const List<Recipe> allRecipes = [
  // ---------------- SARAPAN ----------------
  Recipe(
    id: 'r1', name: 'Oatmeal Buah', category: 'Sarapan', time: 15, calories: 320,
    protein: 10, carbs: 54, fat: 7, rating: 4.8, color: Color(0xFFFFE082), vegetarian: true,
    description: 'Sarapan hangat kaya serat dengan potongan pisang dan madu alami.',
    ingredients: [
      Ingredient('Oatmeal', 50, 'gr', 'Karbohidrat'),
      Ingredient('Susu', 150, 'ml', 'Lainnya'),
      Ingredient('Pisang', 1, 'buah', 'Buah'),
      Ingredient('Madu', 1, 'sdm', 'Lainnya'),
    ],
    steps: [
      'Panaskan susu hingga hampir mendidih.',
      'Masukkan oatmeal, aduk dan masak 5 menit hingga mengental.',
      'Tuang ke mangkuk, tambahkan irisan pisang dan madu.',
    ],
  ),
  Recipe(
    id: 'r2', name: 'Telur Orak-arik & Roti Gandum', category: 'Sarapan', time: 10, calories: 350,
    protein: 18, carbs: 30, fat: 16, rating: 4.6, color: Color(0xFFFFF59D), vegetarian: true,
    description: 'Sarapan tinggi protein yang cepat dibuat.',
    ingredients: [
      Ingredient('Telur', 2, 'butir', 'Protein'),
      Ingredient('Roti Gandum', 2, 'lembar', 'Karbohidrat'),
      Ingredient('Tomat', 1, 'buah', 'Sayuran'),
      Ingredient('Mentega', 1, 'sdt', 'Lainnya'),
    ],
    steps: [
      'Kocok telur dengan sedikit garam dan lada.',
      'Panaskan mentega, masak telur sambil diaduk hingga matang.',
      'Sajikan dengan roti gandum panggang dan irisan tomat.',
    ],
  ),
  Recipe(
    id: 'r3', name: 'Smoothie Bowl Pisang', category: 'Sarapan', time: 10, calories: 280,
    protein: 8, carbs: 52, fat: 5, rating: 4.5, color: Color(0xFFF8BBD0), vegetarian: true,
    description: 'Mangkuk smoothie segar dengan granola dan stroberi.',
    ingredients: [
      Ingredient('Pisang', 2, 'buah', 'Buah'),
      Ingredient('Yogurt', 150, 'gr', 'Lainnya'),
      Ingredient('Granola', 30, 'gr', 'Karbohidrat'),
      Ingredient('Stroberi', 5, 'buah', 'Buah'),
    ],
    steps: [
      'Blender pisang beku dan yogurt hingga kental.',
      'Tuang ke mangkuk.',
      'Taburi granola dan irisan stroberi.',
    ],
  ),
  Recipe(
    id: 'r4', name: 'Bubur Ayam Sehat', category: 'Sarapan', time: 25, calories: 380,
    protein: 22, carbs: 50, fat: 9, rating: 4.4, color: Color(0xFFFFE0B2), vegetarian: false,
    description: 'Bubur nasi merah dengan suwiran ayam rebus rendah lemak.',
    ingredients: [
      Ingredient('Nasi Merah', 100, 'gr', 'Karbohidrat'),
      Ingredient('Dada Ayam', 100, 'gr', 'Protein'),
      Ingredient('Daun Bawang', 1, 'batang', 'Sayuran'),
      Ingredient('Bawang Putih', 2, 'siung', 'Lainnya'),
    ],
    steps: [
      'Rebus ayam dengan bawang putih, lalu suwir-suwir.',
      'Masak nasi merah dengan air kaldu hingga menjadi bubur.',
      'Sajikan dengan suwiran ayam dan irisan daun bawang.',
    ],
  ),
  // ---------------- MAKAN SIANG ----------------
  Recipe(
    id: 'r5', name: 'Ayam Panggang', category: 'Makan Siang', time: 30, calories: 520,
    protein: 42, carbs: 55, fat: 14, rating: 4.9, color: Color(0xFFEF9A9A), vegetarian: false,
    description: 'Dada ayam panggang bumbu kecap dengan nasi merah dan brokoli.',
    ingredients: [
      Ingredient('Dada Ayam', 250, 'gr', 'Protein'),
      Ingredient('Nasi Merah', 150, 'gr', 'Karbohidrat'),
      Ingredient('Brokoli', 200, 'gr', 'Sayuran'),
      Ingredient('Bawang Putih', 3, 'siung', 'Lainnya'),
      Ingredient('Kecap Manis', 1, 'sdm', 'Lainnya'),
    ],
    steps: [
      'Marinasi ayam dengan bawang putih dan kecap selama 15 menit.',
      'Panggang ayam di oven 200°C selama 20 menit hingga matang.',
      'Tumis atau kukus brokoli sebentar.',
      'Sajikan ayam dengan nasi merah dan brokoli.',
    ],
  ),
  Recipe(
    id: 'r6', name: 'Salad Sayur', category: 'Makan Siang', time: 15, calories: 200,
    protein: 6, carbs: 20, fat: 10, rating: 4.6, color: Color(0xFFC5E1A5), vegetarian: true,
    description: 'Salad segar dengan saus minyak zaitun dan jeruk nipis.',
    ingredients: [
      Ingredient('Selada', 100, 'gr', 'Sayuran'),
      Ingredient('Tomat', 2, 'buah', 'Sayuran'),
      Ingredient('Timun', 1, 'buah', 'Sayuran'),
      Ingredient('Wortel', 1, 'buah', 'Sayuran'),
      Ingredient('Minyak Zaitun', 1, 'sdm', 'Lainnya'),
    ],
    steps: [
      'Cuci dan potong semua sayuran.',
      'Campur dalam mangkuk besar.',
      'Siram dengan minyak zaitun, garam, dan lada, lalu aduk rata.',
    ],
  ),
  Recipe(
    id: 'r7', name: 'Pecel Tahu Tempe', category: 'Makan Siang', time: 25, calories: 430,
    protein: 22, carbs: 48, fat: 16, rating: 4.5, color: Color(0xFFD7CCC8), vegetarian: true,
    description: 'Sayuran rebus, tahu, dan tempe dengan bumbu kacang.',
    ingredients: [
      Ingredient('Tahu', 2, 'potong', 'Protein'),
      Ingredient('Tempe', 100, 'gr', 'Protein'),
      Ingredient('Bayam', 1, 'ikat', 'Sayuran'),
      Ingredient('Kacang Tanah', 50, 'gr', 'Lainnya'),
      Ingredient('Nasi Merah', 150, 'gr', 'Karbohidrat'),
    ],
    steps: [
      'Rebus bayam sebentar, tiriskan.',
      'Goreng/panggang tahu dan tempe.',
      'Haluskan kacang tanah dengan bumbu menjadi sambal pecel.',
      'Sajikan semua dengan nasi merah dan siram sambal.',
    ],
  ),
  Recipe(
    id: 'r8', name: 'Ikan Bakar & Tumis Kangkung', category: 'Makan Siang', time: 35, calories: 480,
    protein: 40, carbs: 40, fat: 15, rating: 4.7, color: Color(0xFFB3E5FC), vegetarian: false,
    description: 'Ikan nila bakar dengan tumis kangkung dan nasi merah.',
    ingredients: [
      Ingredient('Ikan Nila', 300, 'gr', 'Protein'),
      Ingredient('Kangkung', 1, 'ikat', 'Sayuran'),
      Ingredient('Nasi Merah', 150, 'gr', 'Karbohidrat'),
      Ingredient('Jeruk Nipis', 1, 'buah', 'Buah'),
      Ingredient('Bawang Putih', 2, 'siung', 'Lainnya'),
    ],
    steps: [
      'Lumuri ikan dengan jeruk nipis dan garam, diamkan 10 menit.',
      'Bakar ikan hingga matang kecokelatan.',
      'Tumis kangkung dengan bawang putih.',
      'Sajikan bersama nasi merah.',
    ],
  ),
  // ---------------- MAKAN MALAM ----------------
  Recipe(
    id: 'r9', name: 'Sup Sayur', category: 'Makan Malam', time: 20, calories: 260,
    protein: 12, carbs: 30, fat: 8, rating: 4.7, color: Color(0xFFA5D6A7), vegetarian: true,
    description: 'Sup hangat berisi tahu, wortel, dan bayam.',
    ingredients: [
      Ingredient('Tahu', 2, 'potong', 'Protein'),
      Ingredient('Wortel', 2, 'buah', 'Sayuran'),
      Ingredient('Bayam', 1, 'ikat', 'Sayuran'),
      Ingredient('Bawang Putih', 2, 'siung', 'Lainnya'),
    ],
    steps: [
      'Tumis bawang putih hingga harum, tambahkan air.',
      'Masukkan wortel dan didihkan hingga empuk.',
      'Tambahkan tahu dan bayam, masak 3 menit. Bumbui secukupnya.',
    ],
  ),
  Recipe(
    id: 'r10', name: 'Tumis Tahu Brokoli', category: 'Makan Malam', time: 20, calories: 300,
    protein: 18, carbs: 20, fat: 14, rating: 4.4, color: Color(0xFFDCEDC8), vegetarian: true,
    description: 'Tumisan ringan tahu dan brokoli yang mengenyangkan.',
    ingredients: [
      Ingredient('Tahu', 3, 'potong', 'Protein'),
      Ingredient('Brokoli', 200, 'gr', 'Sayuran'),
      Ingredient('Wortel', 1, 'buah', 'Sayuran'),
      Ingredient('Bawang Putih', 2, 'siung', 'Lainnya'),
    ],
    steps: [
      'Goreng sebentar potongan tahu hingga kuning.',
      'Tumis bawang putih, masukkan wortel dan brokoli.',
      'Tambahkan tahu, bumbui, aduk hingga matang.',
    ],
  ),
  Recipe(
    id: 'r11', name: 'Sup Ayam Jagung', category: 'Makan Malam', time: 30, calories: 340,
    protein: 30, carbs: 28, fat: 9, rating: 4.6, color: Color(0xFFFFF176), vegetarian: false,
    description: 'Sup ayam dengan jagung manis, wortel, dan kentang.',
    ingredients: [
      Ingredient('Dada Ayam', 150, 'gr', 'Protein'),
      Ingredient('Jagung', 1, 'buah', 'Sayuran'),
      Ingredient('Wortel', 1, 'buah', 'Sayuran'),
      Ingredient('Kentang', 1, 'buah', 'Karbohidrat'),
      Ingredient('Daun Bawang', 1, 'batang', 'Sayuran'),
    ],
    steps: [
      'Rebus ayam hingga matang, ambil kaldunya.',
      'Masukkan jagung, wortel, dan kentang ke dalam kaldu.',
      'Masak hingga empuk, tambahkan ayam suwir dan daun bawang.',
    ],
  ),
  Recipe(
    id: 'r12', name: 'Capcay Udang', category: 'Makan Malam', time: 20, calories: 310,
    protein: 24, carbs: 22, fat: 12, rating: 4.5, color: Color(0xFFFFCCBC), vegetarian: false,
    description: 'Tumis aneka sayuran dengan udang, rendah kalori dan kaya protein.',
    ingredients: [
      Ingredient('Udang', 150, 'gr', 'Protein'),
      Ingredient('Brokoli', 100, 'gr', 'Sayuran'),
      Ingredient('Wortel', 1, 'buah', 'Sayuran'),
      Ingredient('Kembang Kol', 100, 'gr', 'Sayuran'),
      Ingredient('Bawang Putih', 2, 'siung', 'Lainnya'),
    ],
    steps: [
      'Tumis bawang putih hingga harum, masukkan udang.',
      'Tambahkan wortel, kembang kol, dan brokoli.',
      'Tuang sedikit air, masak hingga sayur matang namun tetap renyah.',
    ],
  ),
];
