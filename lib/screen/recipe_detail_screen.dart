import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/recipe.dart';
import '../state/app_state.dart';
import '../util/ui_helpers.dart';
import '../widget/add_to_plan_sheet.dart';
import '../widget/primary_button.dart';
import '../widget/recipe_image.dart';

/// Detail resep — FR-11/FR-12: deskripsi, nutrisi, bahan, dan langkah.
/// [pickMode]: tombol mengembalikan resep ke halaman pemanggil.
/// [allowAdd]: tampilkan tombol tambah ke rencana menu.
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  final bool pickMode;
  final bool allowAdd;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    this.pickMode = false,
    this.allowAdd = true,
  });

  Future<void> _onAdd(BuildContext context) async {
    if (pickMode) {
      Navigator.of(context).pop(recipe);
      return;
    }
    final s = context.read<AppState>();
    final ok = await showAddToPlanSheet(context, recipe,
        date: s.selectedPlanDate, mealType: recipe.category);
    if (ok && context.mounted) {
      showSnack(context, '"${recipe.name}" ditambahkan ke rencana menu');
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = recipe;
    return Scaffold(
      appBar: AppBar(title: Text(r.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          RecipeImage(recipe: r, height: 200, radius: 16, iconSize: 56),
          const SizedBox(height: 14),
          Text(r.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _pill(r.category),
              _pill('${r.time} menit'),
              _pill('⭐ ${r.rating}'),
              if (r.vegetarian) _pill('🌱 Vegetarian'),
            ],
          ),
          const SizedBox(height: 12),
          Text(r.description, style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
          const SizedBox(height: 16),
          const Text('Informasi Nutrisi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Row(
            children: [
              _nutri('${r.calories}', 'kkal'),
              _nutri('${r.protein} g', 'Protein'),
              _nutri('${r.carbs} g', 'Karbo'),
              _nutri('${r.fat} g', 'Lemak'),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Bahan-bahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          for (final ing in r.ingredients)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: categoryColor(ing.category), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(ing.name)),
                  Text(formatQty(ing.amount, ing.unit), style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
          const SizedBox(height: 18),
          const Text('Langkah Memasak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          for (int i = 0; i < r.steps.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: kGreen,
                    child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(r.steps[i], style: const TextStyle(height: 1.4))),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: allowAdd || pickMode
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: PrimaryButton(
                  label: pickMode ? 'Pilih Resep Ini' : 'Tambah ke Rencana Menu',
                  icon: Icons.add,
                  onPressed: () => _onAdd(context),
                ),
              ),
            )
          : null,
    );
  }

  Widget _pill(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
        child: Text(t, style: const TextStyle(color: kGreen, fontSize: 12, fontWeight: FontWeight.w600)),
      );

  Widget _nutri(String value, String label) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Column(
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
        ),
      );
}
