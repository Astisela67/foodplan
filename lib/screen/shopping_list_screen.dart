import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/recipe.dart';
import '../state/app_state.dart';
import '../util/ui_helpers.dart';
import '../widget/shopping_item_tile.dart';

/// Halaman Daftar Belanja — FR-14, FR-15, FR-16, FR-17.
/// Bahan dibuat otomatis dari rencana menu (hari ini dan seterusnya),
/// dijumlahkan bila sama, dan bisa ditambah manual.
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  String _filter = 'Semua';

  Future<void> _showAddDialog() async {
    final nameC = TextEditingController();
    final qtyC = TextEditingController();
    String cat = 'Lainnya';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Tambah Bahan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Nama bahan')),
              TextField(
                  controller: qtyC,
                  decoration: const InputDecoration(labelText: 'Jumlah (mis. 2 buah)')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: cat,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: shoppingCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setD(() => cat = v ?? cat),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Tambah', style: TextStyle(color: kGreen)),
            ),
          ],
        ),
      ),
    );
    if (ok == true && nameC.text.trim().isNotEmpty && mounted) {
      context.read<AppState>().addManual(
            nameC.text.trim(),
            qtyC.text.trim().isEmpty ? '1' : qtyC.text.trim(),
            cat,
          );
    }
  }

  Future<void> _checkout(AppState s, int count) async {
    final ok = await showConfirm(
      context,
      'Checkout',
      '$count bahan yang sudah dibeli akan dihapus dari daftar. Lanjutkan?',
      confirmLabel: 'Checkout',
    );
    if (!ok || !mounted) return;
    final n = s.checkout();
    showSnack(context, 'Checkout berhasil: $n bahan selesai dibeli');
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final all = s.shoppingItems;
    final purchasedCount = all.where((i) => i.purchased).length;
    final visible = all.where((i) {
      if (_filter == 'Belum Dibeli') return !i.purchased;
      if (_filter == 'Sudah Dibeli') return i.purchased;
      return true;
    }).toList();
    final cats = shoppingCategories.where((c) => visible.any((i) => i.category == c)).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 48),
                const Expanded(
                  child: Center(
                    child: Text('Daftar Belanja', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                IconButton(
                  tooltip: 'Tambah bahan manual',
                  onPressed: _showAddDialog,
                  icon: const Icon(Icons.add_circle_outline_rounded, color: kGreen),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: ['Semua', 'Belum Dibeli', 'Sudah Dibeli'].map((f) {
                final active = f == _filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f, style: TextStyle(fontSize: 12, color: active ? Colors.white : Colors.black87)),
                    selected: active,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: kGreen,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: visible.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_basket_outlined, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 10),
                            Text(
                              all.isEmpty
                                  ? 'Belum ada bahan.\nTambahkan menu ke rencana atau tambah bahan manual dengan tombol +.'
                                  : 'Tidak ada bahan pada filter ini.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView(
                      children: [
                        for (final cat in cats) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 14, bottom: 4),
                            child: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                          for (final item in visible.where((i) => i.category == cat))
                            item.manual
                                ? Dismissible(
                                    key: ValueKey(item.key),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.red.shade100,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 16),
                                      child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                                    ),
                                    onDismissed: (_) => s.deleteManual(item.key),
                                    child: _tile(s, item),
                                  )
                                : _tile(s, item),
                        ],
                        const SizedBox(height: 8),
                        Text('Geser bahan manual ke kiri untuk menghapus.',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: purchasedCount == 0 ? null : () => _checkout(s, purchasedCount),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFC8E6C9),
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('Checkout ($purchasedCount)', style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 80), // ruang untuk bottom nav
          ],
        ),
      ),
    );
  }

  Widget _tile(AppState s, ShoppingItem item) => ShoppingItemTile(
        color: categoryColor(item.category),
        name: item.name,
        quantity: item.qty,
        isPurchased: item.purchased,
        onChanged: (v) => s.togglePurchased(item, v ?? false),
      );
}
