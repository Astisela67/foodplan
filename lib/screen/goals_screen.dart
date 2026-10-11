import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../util/ui_helpers.dart';
import '../widget/primary_button.dart';

/// Tujuan & Target: target nutrisi harian yang dipakai di Beranda.
class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late final TextEditingController _cal;
  late final TextEditingController _pro;
  late final TextEditingController _carb;
  late final TextEditingController _fat;
  String? _error;

  @override
  void initState() {
    super.initState();
    final s = context.read<AppState>();
    _cal = TextEditingController(text: '${s.target('cal')}');
    _pro = TextEditingController(text: '${s.target('pro')}');
    _carb = TextEditingController(text: '${s.target('carb')}');
    _fat = TextEditingController(text: '${s.target('fat')}');
  }

  @override
  void dispose() {
    _cal.dispose();
    _pro.dispose();
    _carb.dispose();
    _fat.dispose();
    super.dispose();
  }

  void _reset() {
    _cal.text = '2000';
    _pro.text = '100';
    _carb.text = '250';
    _fat.text = '70';
  }

  void _save() {
    final c = int.tryParse(_cal.text), p = int.tryParse(_pro.text);
    final k = int.tryParse(_carb.text), f = int.tryParse(_fat.text);
    if (c == null || p == null || k == null || f == null || c <= 0 || p <= 0 || k <= 0 || f <= 0) {
      setState(() => _error = 'Semua target harus berupa angka lebih dari 0');
      return;
    }
    context.read<AppState>().setTargets(c, p, k, f);
    Navigator.of(context).pop();
    showSnack(context, 'Target nutrisi disimpan');
  }

  Widget _field(String label, TextEditingController c, String unit) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: label,
            suffixText: unit,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tujuan & Target')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Atur target nutrisi harianmu. Target ini dipakai pada progres nutrisi di Beranda.',
                style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
            const SizedBox(height: 16),
            _field('Kalori', _cal, 'kkal'),
            _field('Protein', _pro, 'g'),
            _field('Karbohidrat', _carb, 'g'),
            _field('Lemak', _fat, 'g'),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _reset,
              child: const Text('Kembalikan ke standar (2000 kkal)', style: TextStyle(color: kGreen)),
            ),
            const SizedBox(height: 8),
            PrimaryButton(label: 'Simpan', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
