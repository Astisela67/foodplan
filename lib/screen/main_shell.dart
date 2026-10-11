import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/recipe.dart';
import '../state/app_state.dart';
import '../util/ui_helpers.dart';
import '../widget/add_to_plan_sheet.dart';
import '../widget/app_bottom_nav.dart';
import 'home_screen.dart';
import 'meal_plan_screen.dart';
import 'profile_screen.dart';
import 'recipe_screen.dart';
import 'shopping_list_screen.dart';

/// Kerangka utama aplikasi setelah login: 4 tab (Beranda, Rencana Menu,
/// Daftar Belanja, Profil) dengan satu bottom navigation dan satu FAB (NFR04).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _navIndex = 0;

  void _goToTab(int index) => setState(() => _navIndex = index);

  /// Alur tambah menu (UC-05/UC-06): pilih resep -> pilih tanggal & waktu
  /// makan -> simpan ke rencana menu.
  Future<void> _openTambahMenu([DateTime? date, String? mealType]) async {
    final state = context.read<AppState>();
    final recipe = await Navigator.of(context).push<Recipe>(
      MaterialPageRoute(builder: (_) => RecipeScreen(initialCategory: mealType)),
    );
    if (recipe == null || !mounted) return;
    final ok = await showAddToPlanSheet(
      context,
      recipe,
      date: date ?? state.selectedPlanDate,
      mealType: mealType ?? recipe.category,
    );
    if (ok && mounted) {
      showSnack(context, '"${recipe.name}" ditambahkan ke rencana menu');
      setState(() => _navIndex = 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(onLihatSemuaMenu: () => _goToTab(1), onTambahMenu: _openTambahMenu),
      MealPlanScreen(onTambahMenu: _openTambahMenu),
      const ShoppingListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _navIndex, children: tabs),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        onPressed: () => _openTambahMenu(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNav(currentIndex: _navIndex, onTap: _goToTab),
    );
  }
}
