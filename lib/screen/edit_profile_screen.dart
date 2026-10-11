import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../model/recipe.dart';
import '../state/app_state.dart';
import '../util/ui_helpers.dart';
import '../widget/primary_button.dart';

/// Ubah data profil: nama, usia, berat, tinggi, dan tujuan (FR-18/FR-19).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _age;
  late final TextEditingController _weight;
  late final TextEditingController _height;
  late String _goal;
  String? _error;

  @override
  void initState() {
    super.initState();
    final s = context.read<AppState>();
    _name = TextEditingController(text: s.name);
    _age = TextEditingController(text: s.age?.toString() ?? '');
    _weight = TextEditingController(text: s.weight?.toString() ?? '');
    _height = TextEditingController(text: s.height?.toString() ?? '');
    _goal = goalOptions.contains(s.goal) ? s.goal : goalOptions.first;
  }

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  String? _check(String text, int min, int max, String label) {
    if (text.trim().isEmpty) return null;
    final v = int.tryParse(text.trim());
    if (v == null || v < min || v > max) return '$label harus antara $min–$max';
    return null;
  }

  void _save() {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Nama tidak boleh kosong');
      return;
    }
    final err = _check(_age.text, 5, 120, 'Usia') ??
        _check(_weight.text, 20, 300, 'Berat badan') ??
        _check(_height.text, 80, 250, 'Tinggi badan');
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    context.read<AppState>().updateProfile(
          _name.text,
          int.tryParse(_age.text.trim()),
          int.tryParse(_weight.text.trim()),
          int.tryParse(_height.text.trim()),
          _goal,
        );
    Navigator.of(context).pop();
    showSnack(context, 'Profil berhasil disimpan');
  }

  Widget _field(String label, TextEditingController c, {bool number = false, String? suffix}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        inputFormatters: number ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informasi Akun')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field('Nama Lengkap', _name),
            _field('Usia', _age, number: true, suffix: 'tahun'),
            _field('Berat Badan', _weight, number: true, suffix: 'kg'),
            _field('Tinggi Badan', _height, number: true, suffix: 'cm'),
            DropdownButtonFormField<String>(
              value: _goal,
              decoration: InputDecoration(
                labelText: 'Tujuan',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: goalOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => setState(() => _goal = v ?? _goal),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ],
            const SizedBox(height: 20),
            PrimaryButton(label: 'Simpan', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
