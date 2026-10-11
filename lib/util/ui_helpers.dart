import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

const kGreen = Color(0xFF2E7D32);

Future<bool> showConfirm(
  BuildContext context,
  String title,
  String message, {
  String confirmLabel = 'Ya',
  bool danger = false,
}) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel, style: TextStyle(color: danger ? Colors.red : kGreen)),
        ),
      ],
    ),
  );
  return res ?? false;
}

Future<void> confirmLogout(BuildContext context) async {
  final state = context.read<AppState>();
  final ok = await showConfirm(context, 'Keluar', 'Yakin ingin keluar dari akun?',
      confirmLabel: 'Keluar', danger: true);
  if (!ok || !context.mounted) return;
  Navigator.of(context).popUntil((r) => r.isFirst);
  await state.logout();
}

void showSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));
}
