import 'package:flutter/material.dart';
import '../model/recipe.dart';

/// Kartu slot menu (Sarapan / Makan Siang / Makan Malam) di Beranda.
/// - Sudah diisi  : tampil foto resep (assets/images/<id>.jpg)
/// - Belum diisi  : tampil foto default per waktu makan
///   (assets/images/meal_sarapan.jpg, meal_siang.jpg, meal_malam.jpg)
/// Kalau file foto belum ada, otomatis jatuh ke warna abu-abu.
class MealSlotCard extends StatelessWidget {
  final String mealType;
  final Recipe? recipe;
  final VoidCallback onTap;

  const MealSlotCard({
    super.key,
    required this.mealType,
    required this.recipe,
    required this.onTap,
  });

  String get _defaultImage {
    switch (mealType) {
      case 'Sarapan':
        return 'assets/images/meal_sarapan.jpg';
      case 'Makan Siang':
        return 'assets/images/meal_siang.jpg';
      default:
        return 'assets/images/meal_malam.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filled = recipe != null;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 110,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    filled ? recipe!.imagePath : _defaultImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: filled ? recipe!.color : const Color(0xFFEEEEEE)),
                  ),
                  // gradasi gelap supaya teks putih terbaca
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00000000), Color(0xCC000000)],
                      ),
                    ),
                  ),
                  if (!filled)
                    const Center(
                      child: Icon(Icons.add_circle_outline_rounded, color: Colors.white70, size: 30),
                    ),
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(mealType,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(
                          filled ? recipe!.name : 'Belum diisi',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
