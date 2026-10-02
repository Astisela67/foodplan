import 'package:flutter/material.dart';

/// Bottom navigation konsisten di seluruh halaman utama.
/// Sesuai NFR04: navigasi utama konsisten (Beranda, Rencana, Belanja, Profil).
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);

    Widget navItem(IconData icon, String label, int index) {
      final active = index == currentIndex;
      return Expanded(
        child: InkWell(
          onTap: () => onTap(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 22, color: active ? green : Colors.grey),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: active ? green : Colors.grey,
                    fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        children: [
          navItem(Icons.home_rounded, 'Beranda', 0),
          navItem(Icons.calendar_month_rounded, 'Rencana', 1),
          const Spacer(), // ruang untuk tombol tambah (FAB) di tengah
          navItem(Icons.shopping_basket_rounded, 'Belanja', 2),
          navItem(Icons.person_rounded, 'Profil', 3),
        ],
      ),
    );
  }
}