import 'package:flutter/material.dart';
import '../widget/app_bottom_nav.dart';
import 'home_screen.dart';
import 'meal_plan_screen.dart';
import 'shopping_list_screen.dart';
import 'profile_screen.dart';
import 'recipe_screen.dart';

/// Kerangka utama aplikasi setelah login: menyatukan 4 tab
/// (Beranda, Rencana Menu, Daftar Belanja, Profil) dengan satu
/// bottom navigation dan satu tombol tambah (FAB) yang konsisten
/// di seluruh halaman utama, sesuai NFR04.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _navIndex = 0;

  void _goToTab(int index) => setState(() => _navIndex = index);

  /// Membuka halaman Resep untuk memilih menu (UC-05/UC-06), lalu
  /// menampilkan info singkat kalau ada resep yang dipilih.
  Future<void> _openTambahMenu() async {
    final selected = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const RecipeScreen()),
    );
    if (selected != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$selected" ditambahkan ke rencana menu')),
      );
      setState(() => _navIndex = 1); // pindah ke tab Rencana Menu
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(onLihatSemuaMenu: () => _goToTab(1)),
      MealPlanScreen(onTambahMenu: _openTambahMenu),
      const ShoppingListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _navIndex, children: tabs),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        onPressed: _openTambahMenu,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: _goToTab,
      ),
    );
  }
}