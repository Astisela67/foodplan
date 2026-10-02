import 'package:flutter/material.dart';

/// Satu baris menu bergaya list (dipakai di Profil dan Pengaturan).
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? labelColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: labelColor ?? Colors.black54),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 14, color: labelColor ?? Colors.black87),
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}