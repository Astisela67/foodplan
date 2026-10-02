import 'package:flutter/material.dart';
import '../widget/recipe_card.dart';

/// Halaman Resep — FR-10, FR-11, FR-12.
/// Dibuka dari tombol "Tambah Menu" pada Rencana Menu (UC-05/UC-06).
/// Memilih resep akan menutup halaman ini dan mengembalikan nama resep
/// terpilih ke halaman sebelumnya.
class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String _selectedCategory = 'Semua';
  final _searchController = TextEditingController();

  static const categories = ['Semua', 'Sarapan', 'Makan Siang', 'Makan Malam'];

  static const allRecipes = [
    {'name': 'Oatmeal Buah', 'category': 'Sarapan', 'time': 15, 'calories': 320, 'rating': 4.8, 'color': Color(0xFFFFE082)},
    {'name': 'Ayam Panggang', 'category': 'Makan Siang', 'time': 30, 'calories': 520, 'rating': 4.9, 'color': Color(0xFFEF9A9A)},
    {'name': 'Sup Sayur', 'category': 'Makan Malam', 'time': 20, 'calories': 260, 'rating': 4.7, 'color': Color(0xFFA5D6A7)},
    {'name': 'Salad Sayur', 'category': 'Makan Siang', 'time': 15, 'calories': 200, 'rating': 4.6, 'color': Color(0xFFA5D6A7)},
  ];

  List<Map<String, dynamic>> get _filtered {
    final query = _searchController.text.trim().toLowerCase();
    return allRecipes.where((r) {
      final matchCategory = _selectedCategory == 'Semua' || r['category'] == _selectedCategory;
      final matchQuery = query.isEmpty || (r['name'] as String).toLowerCase().contains(query);
      return matchCategory && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
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
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    final active = cat == _selectedCategory;
                    return ChoiceChip(
                      label: Text(cat, style: TextStyle(fontSize: 12, color: active ? Colors.white : Colors.black87)),
                      selected: active,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                      selectedColor: const Color(0xFF2E7D32),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: results.isEmpty
                    ? Center(
                        child: Text('Resep tidak ditemukan', style: TextStyle(color: Colors.grey.shade600)),
                      )
                    : ListView(
                        children: results
                            .map((r) => RecipeCard(
                                  name: r['name'] as String,
                                  color: r['color'] as Color,
                                  cookTime: r['time'] as int,
                                  calories: r['calories'] as int,
                                  rating: r['rating'] as double,
                                  onTap: () => Navigator.of(context).pop(r['name']),
                                ))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}