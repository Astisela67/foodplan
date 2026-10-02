import 'package:flutter/material.dart';

/// Kartu berwarna untuk satu slot waktu makan pada ringkasan Menu Hari Ini.
/// Sesuai UR-02 / FR-05: ringkasan menu hari ini pada halaman Beranda.
class MealSlotCard extends StatelessWidget {
  final String mealType;
  final String? recipeName;
  final Color color;
  final VoidCallback? onTap;

  const MealSlotCard({
    super.key,
    required this.mealType,
    required this.color,
    this.recipeName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 72,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.bottomLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                mealType,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              Text(
                recipeName ?? 'Belum diisi',
                style: const TextStyle(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}