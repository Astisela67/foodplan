import 'package:flutter/material.dart';
import '../widget/week_calendar_strip.dart';

/// Halaman Rencana Menu — FR-07, FR-08, FR-09.
/// Kalender mingguan dan daftar menu per waktu makan.
class MealPlanScreen extends StatefulWidget {
  final VoidCallback onTambahMenu;

  const MealPlanScreen({super.key, required this.onTambahMenu});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int _selectedDay = 2; // Rabu aktif, sesuai wireframe

  static const dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  static const dayNumbers = [18, 19, 20, 21, 22, 23, 24];

  static const meals = [
    {'type': 'Sarapan', 'time': '07.00', 'name': 'Oatmeal Buah', 'detail': '320 kkal', 'color': Color(0xFFFFE082)},
    {'type': 'Makan Siang', 'time': '12.00', 'name': 'Ayam Panggang', 'detail': 'Nasi Merah, Tumis Brokoli · 520 kkal', 'color': Color(0xFFEF9A9A)},
    {'type': 'Makan Malam', 'time': '19.00', 'name': 'Sup Sayur', 'detail': 'Tahu, Wortel, Bayam · 260 kkal', 'color': Color(0xFFA5D6A7)},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('Rencana Menu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            WeekCalendarStrip(
              dayNames: dayNames,
              dayNumbers: dayNumbers,
              selectedIndex: _selectedDay,
              onSelect: (i) => setState(() => _selectedDay = i),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  for (final m in meals) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(m['type'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(m['time'] as String, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: m['color'] as Color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                Text(m['detail'] as String, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: widget.onTambahMenu,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Tambah Menu', style: TextStyle(fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 70), // ruang untuk FAB & bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}