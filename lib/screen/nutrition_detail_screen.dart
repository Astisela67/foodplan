import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../util/date_util.dart';
import '../util/ui_helpers.dart';

/// Detail nutrisi — FR-06: progres hari ini + kalori per hari minggu ini.
class NutritionDetailScreen extends StatelessWidget {
  const NutritionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final today = dateOnly(DateTime.now());
    final n = s.nutritionFor(today);
    final week = List.generate(7, (i) => addDays(startOfWeek(today), i));
    final calTarget = s.target('cal');

    final rows = [
      ['Kalori', 'cal', 'kkal'],
      ['Protein', 'pro', 'g'],
      ['Karbohidrat', 'carb', 'g'],
      ['Lemak', 'fat', 'g'],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Nutrisi')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(formatLong(today), style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 12),
            for (final r in rows) _bar(r[0], n[r[1]]!, s.target(r[1]), r[2]),
            const SizedBox(height: 20),
            const Text('Kalori Minggu Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            for (final d in week)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 52,
                      child: Text(dayName(d),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSameDay(d, today) ? FontWeight.bold : FontWeight.normal)),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: calTarget == 0
                              ? 0
                              : (s.nutritionFor(d)['cal']! / calTarget).clamp(0.0, 1.0).toDouble(),
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE8F5E9),
                          valueColor: const AlwaysStoppedAnimation(kGreen),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: Text('${s.nutritionFor(d)['cal']} kkal',
                          textAlign: TextAlign.right, style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _bar(String label, int current, int target, String unit) {
    final p = target == 0 ? 0.0 : (current / target).clamp(0.0, 1.0).toDouble();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('$current / $target $unit', style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: p,
              minHeight: 8,
              backgroundColor: const Color(0xFFE8F5E9),
              valueColor: const AlwaysStoppedAnimation(kGreen),
            ),
          ),
        ],
      ),
    );
  }
}
