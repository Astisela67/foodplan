import 'package:flutter/material.dart';
import '../widget/settings_tile.dart';

/// Halaman Pengaturan — FR-20.
/// Catatan: bagian NOTIFIKASI mengikuti wireframe, tetapi SRD versi 1.5
/// mencatat fitur pengingat/notifikasi (F-13) telah DIHAPUS dari lingkup.
/// Toggle di bawah ini murni tampilan (belum menyimpan apa pun) sampai
/// keputusan akhir mengenai fitur ini diambil.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminderEat = true;
  bool _reminderDrink = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _sectionLabel('AKUN'),
            SettingsTile(icon: Icons.person_outline_rounded, label: 'Informasi Akun', onTap: () {}),
            const Divider(height: 1),
            SettingsTile(icon: Icons.lock_outline_rounded, label: 'Ubah Kata Sandi', onTap: () {}),
            _sectionLabel('PREFERENSI'),
            SettingsTile(icon: Icons.flag_outlined, label: 'Tujuan & Target', onTap: () {}),
            const Divider(height: 1),
            SettingsTile(icon: Icons.restaurant_menu_rounded, label: 'Preferensi Makanan', onTap: () {}),
            _sectionLabel('NOTIFIKASI'),
            SettingsTile(
              icon: Icons.notifications_none_rounded,
              label: 'Pengingat Makan',
              trailing: Switch(
                value: _reminderEat,
                activeColor: const Color(0xFF2E7D32),
                onChanged: (v) => setState(() => _reminderEat = v),
              ),
            ),
            const Divider(height: 1),
            SettingsTile(
              icon: Icons.water_drop_outlined,
              label: 'Pengingat Minum',
              trailing: Switch(
                value: _reminderDrink,
                activeColor: const Color(0xFF2E7D32),
                onChanged: (v) => setState(() => _reminderDrink = v),
              ),
            ),
            _sectionLabel('LAINNYA'),
            SettingsTile(icon: Icons.info_outline_rounded, label: 'Tentang FoodPlan', onTap: () {}),
            const Divider(height: 1),
            SettingsTile(
              icon: Icons.logout_rounded,
              label: 'Keluar',
              labelColor: Colors.red,
              onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 0.5),
      ),
    );
  }
}
