import 'package:flutter/material.dart';
import '../widget/settings_tile.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

/// Halaman Profil — FR-18, FR-19. Tab pada MainShell.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('Profil Saya', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(Icons.person, size: 36, color: Color(0xFF2E7D32)),
                  ),
                  const SizedBox(height: 10),
                  const Text('Asti Sela', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('asti.sela@email.com', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                children: [
                  _dataRow('Usia', '21 Tahun'),
                  _dataRow('Berat Badan', '50 kg'),
                  _dataRow('Tinggi Badan', '160 cm'),
                  _dataRow('Tujuan', 'Hidup Sehat', isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  SettingsTile(
                    icon: Icons.history_rounded,
                    label: 'Riwayat Menu',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Halaman Riwayat Menu belum dibuat')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.settings_outlined,
                    label: 'Pengaturan',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ),
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Bantuan & Dukungan',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Halaman Bantuan belum dibuat')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.logout_rounded,
                    label: 'Keluar',
                    labelColor: Colors.red,
                    onTap: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}