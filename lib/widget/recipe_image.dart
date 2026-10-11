import 'package:flutter/material.dart';
import '../model/recipe.dart';

/// Gambar resep. Memakai foto dari assets/images/<id>.jpg;
/// kalau file belum ada, otomatis tampil placeholder warna + ikon.
class RecipeImage extends StatelessWidget {
  final Recipe recipe;
  final double? width;
  final double height;
  final double radius;
  final double iconSize;

  const RecipeImage({
    super.key,
    required this.recipe,
    this.width,
    required this.height,
    this.radius = 10,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      color: recipe.color,
      child: Center(child: Icon(Icons.restaurant_rounded, color: Colors.white70, size: iconSize)),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: Image.asset(
          recipe.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      ),
    );
  }
}
