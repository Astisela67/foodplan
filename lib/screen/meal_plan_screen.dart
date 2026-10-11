import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/recipe.dart';
import '../widget/recipe_image.dart';
import '../state/app_state.dart';
import '../util/date_util.dart';
import '../util/ui_helpers.dart';
import '../widget/week_calendar_strip.dart';
import 'recipe_detail_screen.dart';

/// Halaman Rencana Menu — FR-07, FR-08, FR-09.
/// Kalender mingguan (bisa pindah minggu) dan menu per waktu makan.
class MealPlanScreen extends StatelessWidget {
  final void Function(DateTime date, String? mealType) onTambahMenu;

  const MealPlanScreen({super.key, required this.onTambahMenu});

  static const _dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final sel = s.selectedPlanDate;
    final weekStart = startOfWeek(sel);
    final days = List.generate(7, (i) => addDays(weekStart, i));
    final today = dateOnly(DateTime.now());
    final todayIdx = days.indexWhere((d) => isSameDay(d, today));
    final totalCal = s.nutritionFor(sel)['cal']!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('Rencana Menu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: () => s.selectPlanDate(addDays(sel, -7)),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(
                  child: Center(
                    child: Text(monthYear(sel), style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                IconButton(
                  onPressed: () => s.selectPlanDate(addDays(sel, 7)),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            WeekCalendarStrip(
              dayNames: _dayNames,
              dayNumbers: days.map((d) => d.day).toList(),
              selectedIndex: sel.weekday - 1,
              todayIndex: todayIdx >= 0 ? todayIdx : null,
              marked: {for (int i = 0; i < 7; i++) if (s.hasPlan(days[i])) i},
              onSelect: (i) => s.selectPlanDate(days[i]),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatLong(sel), style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                if (!isSameDay(sel, today))
                  TextButton(
                    onPressed: () => s.selectPlanDate(today),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 24)),
                    child: const Text('Hari ini', style: TextStyle(color: kGreen, fontSize: 12)),
                  )
                else
                  Text('Total $totalCal kkal',
                      style: const TextStyle(color: kGreen, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
            if (!isSameDay(sel, today))
              Text('Total $totalCal kkal',
                  style: const TextStyle(color: kGreen, fontSize: 12, fontWeight: FontWeight.w600)),
            Expanded(
              child: ListView(
                children: [
                  for (final t in mealTypes) ..._buildSlot(context, s, sel, t),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => onTambahMenu(sel, null),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Tambah Menu', style: TextStyle(fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 90), // ruang untuk FAB & bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSlot(BuildContext context, AppState s, DateTime date, String type) {
    final r = s.mealAt(date, type);
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(mealTimes[type]!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
      ),
      if (r == null)
        InkWell(
          onTap: () => onTambahMenu(date, type),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBDBDBD)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_circle_outline_rounded, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text('Tambah $type', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        )
      else
        InkWell(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: r, allowAdd: false))),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                RecipeImage(recipe: r, width: 48, height: 48, iconSize: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('${r.calories} kkal · ${r.time} menit',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Hapus',
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 22),
                  onPressed: () {
                    s.removeMeal(date, type);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text('"${r.name}" dihapus dari rencana'),
                        action: SnackBarAction(label: 'Batalkan', onPressed: () => s.setMeal(date, type, r)),
                      ));
                  },
                ),
              ],
            ),
          ),
        ),
    ];
  }
}
