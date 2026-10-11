import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widget/app_text_field.dart';
import '../widget/primary_button.dart';
import 'login_screen.dart';

/// Halaman Registrasi (Daftar) — FR-02, FR-04. Berbasis username (SRD 1.5).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _errorText;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validate() {
    final username = _usernameController.text.trim();
    if (_nameController.text.trim().isEmpty) return 'Nama lengkap wajib diisi';
    if (username.isEmpty) return 'Username wajib diisi';
    if (username.length < 3) return 'Username minimal 3 karakter';
    if (!RegExp(r'^[a-zA-Z0-9_.]+$').hasMatch(username)) {
      return 'Username hanya boleh huruf, angka, titik, dan garis bawah';
    }
    if (_passwordController.text.length < 6) return 'Kata sandi minimal 6 karakter';
    if (_passwordController.text != _confirmController.text) return 'Konfirmasi kata sandi tidak cocok';
    return null;
  }

  Future<void> _handleRegister() async {
    final err = _validate();
    if (err != null) {
      setState(() => _errorText = err);
      return;
    }
    setState(() {
      _errorText = null;
      _loading = true;
    });
    final res = await context.read<AppState>().register(
          _nameController.text,
          _usernameController.text,
          _passwordController.text,
        );
    if (!mounted) return;
    if (res != null) {
      setState(() {
        _errorText = res;
        _loading = false;
      });
      return;
    }
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              const Text('Daftar', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Buat akun baru untuk memulai perjalanan sehatmu!',
                  style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 24),
              AppTextField(
                  hint: 'Nama Lengkap',
                  icon: Icons.person_outline_rounded,
                  controller: _nameController,
                  textInputAction: TextInputAction.next),
              const SizedBox(height: 14),
              AppTextField(
                  hint: 'Username',
                  icon: Icons.alternate_email_rounded,
                  controller: _usernameController,
                  textInputAction: TextInputAction.next),
              const SizedBox(height: 14),
              AppTextField(
                  hint: 'Kata Sandi (min. 6 karakter)',
                  icon: Icons.lock_outline_rounded,
                  obscure: true,
                  controller: _passwordController,
                  textInputAction: TextInputAction.next),
              const SizedBox(height: 14),
              AppTextField(
                  hint: 'Konfirmasi Kata Sandi',
                  icon: Icons.lock_outline_rounded,
                  obscure: true,
                  controller: _confirmController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleRegister()),
              if (_errorText != null) ...[
                const SizedBox(height: 10),
                Text(_errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ],
              const SizedBox(height: 20),
              PrimaryButton(label: 'Daftar', onPressed: _handleRegister, loading: _loading),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                      children: [
                        TextSpan(text: 'Sudah punya akun? '),
                        TextSpan(
                          text: 'Masuk',
                          style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
