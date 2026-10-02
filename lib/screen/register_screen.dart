import 'package:flutter/material.dart';
import '../widget/app_text_field.dart';
import '../widget/primary_button.dart';
import 'login_screen.dart';
import 'main_shell.dart';

/// Halaman Registrasi (Daftar) — FR-02, FR-04.
/// Mengikuti SRD (autentikasi berbasis username), bukan field Email pada
/// wireframe — sesuaikan jika kelas memutuskan tetap memakai Email.
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

  void _handleRegister() {
    // FR-04: validasi input akun sebelum data dikirim.
    if (_usernameController.text.trim().isEmpty) {
      setState(() => _errorText = 'Username wajib diisi');
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      setState(() => _errorText = 'Konfirmasi kata sandi tidak cocok');
      return;
    }
    setState(() => _errorText = null);

    // TODO: ganti dengan pemanggilan AuthRepository/REST API sungguhan.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
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
              AppTextField(hint: 'Nama Lengkap', icon: Icons.person_outline_rounded, controller: _nameController),
              const SizedBox(height: 14),
              AppTextField(hint: 'Username', icon: Icons.alternate_email_rounded, controller: _usernameController),
              const SizedBox(height: 14),
              AppTextField(hint: 'Kata Sandi', icon: Icons.lock_outline_rounded, obscure: true, controller: _passwordController),
              const SizedBox(height: 14),
              AppTextField(hint: 'Konfirmasi Kata Sandi', icon: Icons.lock_outline_rounded, obscure: true, controller: _confirmController),
              if (_errorText != null) ...[
                const SizedBox(height: 10),
                Text(_errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ],
              const SizedBox(height: 20),
              PrimaryButton(label: 'Daftar', onPressed: _handleRegister),
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