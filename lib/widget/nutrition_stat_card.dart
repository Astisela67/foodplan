import 'package:flutter/material.dart';

/// Kartu kecil untuk menampilkan satu jenis nutrisi (kalori, protein,
/// karbohidrat, atau lemak) beserta progres terhadap target harian.
/// Sesuai FR-06: progres nutrisi harian dalam bentuk indikator terhadap target.
class NutritionStatCard extends StatelessWidget {
  final String label;
  final num current;
  final num target;
  final String unit;

  const NutritionStatCard({
    super.key,
    required this.label,
    required this.current,
    required this.target,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target == 0 ? 0.0 : (current / target).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          Text('$current', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text('/$target $unit', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFFE8F5E9),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF2E7D32)),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}