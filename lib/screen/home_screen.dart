import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/recipe.dart';
import '../state/app_state.dart';
import '../util/date_util.dart';
import '../widget/meal_slot_card.dart';
import '../widget/nutrition_stat_card.dart';
import '../widget/recipe_card.dart';
import 'nutrition_detail_screen.dart';
import 'recipe_detail_screen.dart';

/// Halaman Beranda — UR-02, FR-05, FR-06.
/// Sapaan pengguna, ringkasan menu hari ini, ringkasan nutrisi harian,
/// dan rekomendasi resep. Semua data diambil dari AppState.
class HomeScreen extends StatelessWidget {
  final VoidCallback onLihatSemuaMenu;
  final void Function(DateTime date, String? mealType) onTambahMenu;

  const HomeScreen({super.key, required this.onLihatSemuaMenu, required this.onTambahMenu});

  static const _card = 16.0;

  BoxDecoration get _cardDeco => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_card),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 8, offset: const Offset(0, 2))],
      );

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final today = dateOnly(DateTime.now());

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(s),
            const SizedBox(height: 20),
            _buildMenuHariIni(context, s, today),
            const SizedBox(height: 16),
            _buildReminderBanner(),
            const SizedBox(height: 20),
            _buildNutrisiHariIni(context, s, today),
            const SizedBox(height: 20),
            _buildRekomendasi(context, s),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(AppState s) {
    final first = s.name.trim().isEmpty ? 'Teman' : s.name.trim().split(' ').first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hai, $first! 👋', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Yuk, rencanakan menu sehat hari ini!', style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildReminderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(14)),
      child: const Text(
        '💧 Jangan lupa minum air putih, 8 gelas per hari ya!',
        style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w600, fontSize: 13, height: 1.4),
      ),
    );
  }

  Widget _buildMenuHariIni(BuildContext context, AppState s, DateTime today) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Menu Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextButton(
                onPressed: onLihatSemuaMenu,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 12)),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10, top: 2),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
            child: Text(formatLong(today),
                style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          Row(
            children: mealTypes.map((t) {
              final r = s.mealAt(today, t);
              return MealSlotCard(
                mealType: t,
                recipe: r,
                onTap: () {
                  if (r != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipe: r, allowAdd: false)));
                  } else {
                    onTambahMenu(today, t);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrisiHariIni(BuildContext context, AppState s, DateTime today) {
    final n = s.nutritionFor(today);
    final items = [
      ['Kalori', 'cal', 'kkal'],
      ['Protein', 'pro', 'g'],
      ['Karbo', 'carb', 'g'],
      ['Lemak', 'fat', 'g'],
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Nutrisi Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const NutritionDetailScreen())),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text('Lihat Detail', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: items
                .map((it) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: NutritionStatCard(
                          label: it[0],
                          current: n[it[1]]!,
                          target: s.target(it[1]),
                          unit: it[2],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRekomendasi(BuildContext context, AppState s) {
    final recs = ([...allRecipes]..sort((a, b) => b.rating.compareTo(a.rating)))
        .where((r) => !s.vegOnly || r.vegetarian)
        .take(3)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rekomendasi Resep', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 10),
        ...recs.map((r) => RecipeCard(
              recipe: r,
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: r))),
            )),
      ],
    );
  }
}
