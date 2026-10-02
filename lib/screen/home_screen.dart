import 'package:flutter/material.dart';
import '../widget/meal_slot_card.dart';
import '../widget/nutrition_stat_card.dart';

/// Halaman Beranda (Home) — sesuai UR-02, FR-05, FR-06 pada SRD.
/// Menampilkan sapaan pengguna, ringkasan menu hari ini, dan ringkasan
/// nutrisi harian. Data pada berkas ini masih dummy (statis); pada
/// implementasi lanjutan sebaiknya dipindahkan ke HomeViewModel/Provider
/// yang mengambil data dari Repository (lihat SRD bagian 3.1 dan 5.2).
///
/// Catatan: berkas ini TIDAK memiliki Scaffold sendiri, karena Beranda
/// adalah salah satu tab yang ditampilkan di dalam MainShell bersama
/// bottom navigation dan tombol tambah (FAB).
class HomeScreen extends StatelessWidget {
  final VoidCallback onLihatSemuaMenu;

  const HomeScreen({super.key, required this.onLihatSemuaMenu});

  // ---- Data sementara (dummy) ----
  static const String userName = 'Asti';
  static const String todayLabel = 'Rabu, 20 Mei 2026';

  static const List<Map<String, dynamic>> meals = [
    {'type': 'Sarapan', 'name': 'Oatmeal Buah', 'color': Color(0xFFFFE082)},
    {'type': 'Makan Siang', 'name': 'Ayam Panggang', 'color': Color(0xFFEF9A9A)},
    {'type': 'Makan Malam', 'name': 'Sup Sayur', 'color': Color(0xFFA5D6A7)},
  ];

  static const List<Map<String, dynamic>> nutrition = [
    {'label': 'Kalori', 'current': 1600, 'target': 2000, 'unit': 'kkal'},
    {'label': 'Protein', 'current': 65, 'target': 100, 'unit': 'g'},
    {'label': 'Karbo', 'current': 180, 'target': 250, 'unit': 'g'},
    {'label': 'Lemak', 'current': 45, 'target': 70, 'unit': 'g'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(context),
            const SizedBox(height: 20),
            _buildMenuHariIni(context),
            const SizedBox(height: 16),
            _buildReminderBanner(),
            const SizedBox(height: 20),
            _buildNutrisiHariIni(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hai, $userName! 👋',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Yuk, rencanakan menu sehat hari ini!',
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Belum ada notifikasi baru')),
            );
          },
          icon: const Icon(Icons.notifications_none_rounded, size: 24),
          color: Colors.black87,
        ),
      ],
    );
  }

  /// Banner pengingat singkat, mis. ajakan minum air putih. Bersifat
  /// statis untuk saat ini.
  Widget _buildReminderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        '💧 Jangan lupa minum air putih, 8 gelas per hari ya!',
        style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w600, fontSize: 13, height: 1.4),
      ),
    );
  }

  Widget _buildMenuHariIni(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
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
            child: const Text(todayLabel,
                style: TextStyle(color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          Row(
            children: meals
                .map((m) => MealSlotCard(
                      mealType: m['type'] as String,
                      recipeName: m['name'] as String?,
                      color: m['color'] as Color,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrisiHariIni(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Nutrisi Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Halaman detail nutrisi belum dibuat')),
                  );
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text('Lihat Detail', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: nutrition
                .map((n) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: NutritionStatCard(
                          label: n['label'] as String,
                          current: n['current'] as num,
                          target: n['target'] as num,
                          unit: n['unit'] as String,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}