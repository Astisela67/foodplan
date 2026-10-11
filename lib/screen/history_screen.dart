import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/recipe.dart';
import '../state/app_state.dart';
import '../util/date_util.dart';
import '../util/ui_helpers.dart';

/// Riwayat Menu: daftar hari-hari lampau (dan hari ini) yang punya menu.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final dates = s.historyDates;

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Menu')),
      body: SafeArea(
        top: false,
        child: dates.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Belum ada riwayat menu.',
                      style: TextStyle(color: Colors.grey.shade600)),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: dates.length,
                itemBuilder: (context, i) {
                  final d = dates[i];
                  final cal = s.nutritionFor(d)['cal']!;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(formatLong(d),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                            Text('$cal kkal',
                                style: const TextStyle(color: kGreen, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        for (final t in mealTypes)
                          if (s.mealAt(d, t) != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(color: s.mealAt(d, t)!.color, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 90,
                                    child: Text(t, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                  ),
                                  Expanded(child: Text(s.mealAt(d, t)!.name, style: const TextStyle(fontSize: 13))),
                                ],
                              ),
                            ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
