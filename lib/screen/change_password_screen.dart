import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../util/ui_helpers.dart';
import '../widget/app_text_field.dart';
import '../widget/primary_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _old = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _old.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_old.text.isEmpty) {
      setState(() => _error = 'Kata sandi lama wajib diisi');
      return;
    }
    if (_new.text.length < 6) {
      setState(() => _error = 'Kata sandi baru minimal 6 karakter');
      return;
    }
    if (_new.text != _confirm.text) {
      setState(() => _error = 'Konfirmasi kata sandi tidak cocok');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final err = await context.read<AppState>().changePassword(_old.text, _new.text);
    if (!mounted) return;
    if (err != null) {
      setState(() {
        _loading = false;
        _error = err;
      });
      return;
    }
    Navigator.of(context).pop();
    showSnack(context, 'Kata sandi berhasil diubah');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubah Kata Sandi')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppTextField(hint: 'Kata sandi lama', icon: Icons.lock_outline_rounded, obscure: true, controller: _old),
            const SizedBox(height: 14),
            AppTextField(hint: 'Kata sandi baru', icon: Icons.lock_reset_rounded, obscure: true, controller: _new),
            const SizedBox(height: 14),
            AppTextField(
                hint: 'Konfirmasi kata sandi baru',
                icon: Icons.lock_reset_rounded,
                obscure: true,
                controller: _confirm),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ],
            const SizedBox(height: 20),
            PrimaryButton(label: 'Simpan', onPressed: _save, loading: _loading),
          ],
        ),
      ),
    );
  }
}
