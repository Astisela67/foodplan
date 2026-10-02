import 'package:flutter/material.dart';
import '../widget/app_text_field.dart';
import '../widget/primary_button.dart';
import 'main_shell.dart';
import 'register_screen.dart';

/// Halaman Masuk (Login) — FR-03.
/// Catatan: wireframe menggunakan field Email, sedangkan SRD versi 1.5
/// menetapkan autentikasi berbasis username tanpa fitur lupa kata sandi.
/// Sesuaikan salah satu acuan sebelum data benar-benar dikirim ke backend.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    // TODO: ganti dengan pemanggilan AuthRepository/REST API sungguhan.
    // Untuk saat ini, tombol Masuk langsung membuka halaman utama (dummy).
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
              const Text('Masuk', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Selamat datang kembali!', style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 24),
              AppTextField(
                hint: 'Username',
                icon: Icons.person_outline_rounded,
                controller: _identifierController,
              ),
              const SizedBox(height: 14),
              AppTextField(
                hint: 'Kata Sandi',
                icon: Icons.lock_outline_rounded,
                obscure: true,
                controller: _passwordController,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur pemulihan kata sandi belum tersedia pada versi ini')),
                    );
                  },
                  child: const Text('Lupa kata sandi?', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 12)),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(label: 'Masuk', onPressed: _handleLogin),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                      children: [
                        TextSpan(text: 'Belum punya akun? '),
                        TextSpan(
                          text: 'Daftar',
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