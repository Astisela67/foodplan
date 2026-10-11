import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../util/ui_helpers.dart';
import '../widget/settings_tile.dart';
import 'edit_profile_screen.dart';
import 'goals_screen.dart';

/// Halaman Pengaturan — FR-20.
/// Fitur pengingat/notifikasi (F-13) sudah dihapus dari lingkup SRD 1.5,
/// sehingga bagian NOTIFIKASI diganti dengan bagian DATA.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _push(BuildContext context, Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _sectionLabel('AKUN'),
            SettingsTile(
                icon: Icons.person_outline_rounded,
                label: 'Informasi Akun',
                onTap: () => _push(context, const EditProfileScreen())),
            _sectionLabel('PREFERENSI'),
            SettingsTile(
                icon: Icons.flag_outlined,
                label: 'Tujuan & Target',
                onTap: () => _push(context, const GoalsScreen())),
            const Divider(height: 1),
            SettingsTile(
              icon: Icons.restaurant_menu_rounded,
              label: 'Hanya resep vegetarian',
              trailing: Switch(
                value: s.vegOnly,
                activeColor: kGreen,
                onChanged: (v) => s.setVegOnly(v),
              ),
            ),
            _sectionLabel('DATA'),
            SettingsTile(
              icon: Icons.delete_sweep_outlined,
              label: 'Hapus Semua Rencana Menu',
              onTap: () async {
                final ok = await showConfirm(context, 'Hapus Rencana',
                    'Semua rencana menu akan dihapus dan tidak bisa dikembalikan. Lanjutkan?',
                    confirmLabel: 'Hapus', danger: true);
                if (ok && context.mounted) {
                  s.clearPlan();
                  showSnack(context, 'Semua rencana menu dihapus');
                }
              },
            ),
            _sectionLabel('LAINNYA'),
            SettingsTile(
              icon: Icons.info_outline_rounded,
              label: 'Tentang FoodPlan',
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'FoodPlan',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.ramen_dining_rounded, color: kGreen, size: 36),
                children: const [
                  SizedBox(height: 8),
                  Text('Aplikasi perencana menu sehat: susun menu mingguan, pantau nutrisi harian, '
                      'dan buat daftar belanja otomatis.'),
                ],
              ),
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
