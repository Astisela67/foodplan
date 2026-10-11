import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/recipe.dart';
import '../state/app_state.dart';
import '../widget/recipe_card.dart';
import 'recipe_detail_screen.dart';

/// Halaman Resep — FR-10, FR-11, FR-12.
/// Dibuka dari tombol "Tambah Menu". Memilih resep -> membuka detail,
/// lalu tombol "Pilih Resep Ini" menutup halaman dan mengembalikan [Recipe].
class RecipeScreen extends StatefulWidget {
  final String? initialCategory;
  const RecipeScreen({super.key, this.initialCategory});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late String _selectedCategory = widget.initialCategory ?? 'Semua';
  final _searchController = TextEditingController();
  late bool _vegOnly = context.read<AppState>().vegOnly;

  static const categories = ['Semua', ...mealTypes];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Recipe> get _filtered {
    final query = _searchController.text.trim().toLowerCase();
    return allRecipes.where((r) {
      final matchCategory = _selectedCategory == 'Semua' || r.category == _selectedCategory;
      final matchQuery = query.isEmpty || r.name.toLowerCase().contains(query);
      final matchVeg = !_vegOnly || r.vegetarian;
      return matchCategory && matchQuery && matchVeg;
    }).toList();
  }

  Future<void> _open(Recipe r) async {
    final picked = await Navigator.of(context).push<Recipe>(
      MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: r, pickMode: true)),
    );
    if (picked != null && mounted) Navigator.of(context).pop(picked);
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;
    const green = Color(0xFF2E7D32);

    return Scaffold(
      appBar: AppBar(title: const Text('Resep')),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari resep sehat...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () => setState(_searchController.clear),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    if (i == categories.length) {
                      return FilterChip(
                        label: Text('🌱 Vegetarian',
                            style: TextStyle(fontSize: 12, color: _vegOnly ? Colors.white : Colors.black87)),
                        selected: _vegOnly,
                        showCheckmark: false,
                        onSelected: (v) => setState(() => _vegOnly = v),
                        selectedColor: green,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                    }
                    final cat = categories[i];
                    final active = cat == _selectedCategory;
                    return ChoiceChip(
                      label: Text(cat, style: TextStyle(fontSize: 12, color: active ? Colors.white : Colors.black87)),
                      selected: active,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                      selectedColor: green,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: results.isEmpty
                    ? Center(child: Text('Resep tidak ditemukan', style: TextStyle(color: Colors.grey.shade600)))
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 16),
                        children: results.map((r) => RecipeCard(recipe: r, onTap: () => _open(r))).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
