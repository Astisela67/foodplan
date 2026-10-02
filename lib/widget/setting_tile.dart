import 'package:flutter/material.dart';

/// Strip kalender Sen–Min pada halaman Rencana Menu (FR-07).
class WeekCalendarStrip extends StatelessWidget {
  final List<String> dayNames;
  final List<int> dayNumbers;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const WeekCalendarStrip({
    super.key,
    required this.dayNames,
    required this.dayNumbers,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(dayNames.length, (i) {
        final active = i == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(i),
            child: Column(
              children: [
                Text(
                  dayNames[i],
                  style: TextStyle(
                    fontSize: 12,
                    color: active ? const Color(0xFF2E7D32) : Colors.grey,
                    fontWeight: active ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 6),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: active ? const Color(0xFF2E7D32) : Colors.transparent,
                  child: Text(
                    '${dayNumbers[i]}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : Colors.black87,
                    ),
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