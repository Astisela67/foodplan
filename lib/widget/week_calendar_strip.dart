import 'package:flutter/material.dart';

/// Strip kalender Sen–Min pada halaman Rencana Menu (FR-07).
/// Titik kecil di bawah tanggal menandai hari yang sudah punya menu.
class WeekCalendarStrip extends StatelessWidget {
  final List<String> dayNames;
  final List<int> dayNumbers;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Set<int> marked;
  final int? todayIndex;

  const WeekCalendarStrip({
    super.key,
    required this.dayNames,
    required this.dayNumbers,
    required this.selectedIndex,
    required this.onSelect,
    this.marked = const {},
    this.todayIndex,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);
    return Row(
      children: List.generate(dayNames.length, (i) {
        final active = i == selectedIndex;
        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onSelect(i),
            child: Column(
              children: [
                Text(
                  dayNames[i],
                  style: TextStyle(
                    fontSize: 12,
                    color: active ? green : Colors.grey,
                    fontWeight: active ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? green : Colors.transparent,
                    border: (!active && todayIndex == i) ? Border.all(color: green) : null,
                  ),
                  child: Text(
                    '${dayNumbers[i]}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: marked.contains(i) ? green : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
