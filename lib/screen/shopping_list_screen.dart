import 'package:flutter/material.dart';
import '../widget/shopping_item_tile.dart';

/// Halaman Daftar Belanja — FR-14, FR-15, FR-16, FR-17.
/// Merupakan salah satu tab pada MainShell, sehingga tidak memiliki
/// Scaffold sendiri; tombol Checkout diletakkan langsung di bagian
/// bawah konten (bukan bottomNavigationBar) agar tidak bertumpuk
/// dengan bottom navigation utama aplikasi.
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  String _filter = 'Semua';

  final List<Map<String, dynamic>> _items = [
    {'category': 'Sayuran', 'name': 'Brokoli', 'qty': '200 gr', 'color': const Color(0xFFA5D6A7), 'purchased': true},
    {'category': 'Sayuran', 'name': 'Wortel', 'qty': '2 buah', 'color': const Color(0xFFFFCC80), 'purchased': true},
    {'category': 'Sayuran', 'name': 'Bayam', 'qty': '1 ikat', 'color': const Color(0xFFA5D6A7), 'purchased': false},
    {'category': 'Protein', 'name': 'Dada Ayam', 'qty': '250 gr', 'color': const Color(0xFFEF9A9A), 'purchased': true},
    {'category': 'Protein', 'name': 'Tahu', 'qty': '2 potong', 'color': const Color(0xFFFFE082), 'purchased': false},
    {'category': 'Lainnya', 'name': 'Oatmeal', 'qty': '1 bungkus', 'color': const Color(0xFFE0E0E0), 'purchased': false},
  ];

  List<Map<String, dynamic>> get _visibleItems {
    if (_filter == 'Belum Dibeli') return _items.where((i) => i['purchased'] == false).toList();
    if (_filter == 'Sudah Dibeli') return _items.where((i) => i['purchased'] == true).toList();
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    final categories = {for (final i in _visibleItems) i['category'] as String}.toList();
    final purchasedCount = _items.where((i) => i['purchased'] == true).length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('Daftar Belanja', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 14),
            Row(
              children: ['Semua', 'Belum Dibeli', 'Sudah Dibeli'].map((f) {
                final active = f == _filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f, style: TextStyle(fontSize: 12, color: active ? Colors.white : Colors.black87)),
                    selected: active,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: const Color(0xFF2E7D32),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                children: [
                  for (final cat in categories) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 14, bottom: 4),
                      child: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    for (final item in _visibleItems.where((i) => i['category'] == cat))
                      ShoppingItemTile(
                        color: item['color'] as Color,
                        name: item['name'] as String,
                        quantity: item['qty'] as String,
                        isPurchased: item['purchased'] as bool,
                        onChanged: (val) {
                          setState(() {
                            _items.firstWhere((i) => i['name'] == item['name'])['purchased'] = val ?? false;
                          });
                        },
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checkout belum terhubung ke backend')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('Checkout ($purchasedCount)', style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}