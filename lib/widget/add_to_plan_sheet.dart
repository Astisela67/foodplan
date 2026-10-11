import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/recipe.dart';
import '../state/app_state.dart';
import '../util/date_util.dart';
import 'primary_button.dart';

/// Bottom sheet untuk memilih tanggal & waktu makan sebelum resep
/// ditambahkan ke rencana menu (UC-05/UC-06). Mengembalikan true jika disimpan.
Future<bool> showAddToPlanSheet(
  BuildContext context,
  Recipe recipe, {
  DateTime? date,
  String? mealType,
}) async {
  final res = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _AddToPlanSheet(
      recipe: recipe,
      date: date ?? DateTime.now(),
      mealType: mealType ?? recipe.category,
    ),
  );
  return res ?? false;
}

class _AddToPlanSheet extends StatefulWidget {
  final Recipe recipe;
  final DateTime date;
  final String mealType;
  const _AddToPlanSheet({required this.recipe, required this.date, required this.mealType});

  @override
  State<_AddToPlanSheet> createState() => _AddToPlanSheetState();
}

class _AddToPlanSheetState extends State<_AddToPlanSheet> {
  late DateTime _date = dateOnly(widget.date);
  late String _type = widget.mealType;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 2, 12, 31),
    );
    if (picked != null) setState(() => _date = dateOnly(picked));
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);
    final existing = context.read<AppState>().mealAt(_date, _type);

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Tambah "${widget.recipe.name}"',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Tanggal', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_month_rounded, size: 18),
              label: Text(formatLong(_date)),
              style: OutlinedButton.styleFrom(
                foregroundColor: green,
                side: const BorderSide(color: green),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Waktu makan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: mealTypes.map((t) {
              final active = t == _type;
              return ChoiceChip(
                label: Text(t, style: TextStyle(fontSize: 12, color: active ? Colors.white : Colors.black87)),
                selected: active,
                showCheckmark: false,
                onSelected: (_) => setState(() => _type = t),
                selectedColor: green,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              );
            }).toList(),
          ),
          if (existing != null) ...[
            const SizedBox(height: 10),
            Text('Akan menggantikan "${existing.name}" pada slot ini.',
                style: const TextStyle(color: Colors.orange, fontSize: 12)),
          ],
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Simpan ke Rencana Menu',
            onPressed: () {
              final s = context.read<AppState>();
              s.setMeal(_date, _type, widget.recipe);
              s.selectPlanDate(_date);
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }
}
