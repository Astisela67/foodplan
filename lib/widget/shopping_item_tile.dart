import 'package:flutter/material.dart';

/// Satu baris bahan pada halaman Daftar Belanja (FR-16).
class ShoppingItemTile extends StatelessWidget {
  final Color color;
  final String name;
  final String quantity;
  final bool isPurchased;
  final ValueChanged<bool?> onChanged;

  const ShoppingItemTile({
    super.key,
    required this.color,
    required this.name,
    required this.quantity,
    required this.isPurchased,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isPurchased),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      decoration: isPurchased ? TextDecoration.lineThrough : null,
                      color: isPurchased ? Colors.grey : Colors.black87,
                    ),
                  ),
                  Text(quantity, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Checkbox(
              value: isPurchased,
              onChanged: onChanged,
              activeColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }
}
