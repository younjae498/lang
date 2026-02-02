import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../ui/theme/brand_colors.dart';
import '../../ui/theme/metrics.dart';
import '../../ui/theme/playful_icons.dart';
import '../../ui/components/game_top_bar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPure,
      appBar: const GameTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Title
            _buildSectionHeader("QUEST LOG"),
            const SizedBox(height: 16),
            
            // Calendar Card (Neon Pastel Theme)
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: AppColors.successFace.withOpacity(0.1),
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                  weekendStyle: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.energyFace.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.energyFace, width: 2),
                  ),
                  todayTextStyle: const TextStyle(
                    color: AppColors.energyFace,
                    fontWeight: FontWeight.w900,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.successFace,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: AppColors.vividPink,
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false,
                  defaultTextStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                  ),
                  weekendTextStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textMain,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left_rounded, color: AppColors.textMain),
                  rightChevronIcon: Icon(Icons.chevron_right_rounded, color: AppColors.textMain),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Bento Grid for Loot & Stats
            _buildSectionHeader("DAILY ACHIEVEMENTS"),
            const SizedBox(height: 16),
            if (_selectedDay != null)
              _BentoLootGrid(date: _selectedDay!)
            else
              _EmptyLootState(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: AppColors.textSecondary,
        letterSpacing: 2.0,
      ),
    );
  }
}

class _BentoLootGrid extends StatelessWidget {
  const _BentoLootGrid({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Row: One Large + Two Small Stacked
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large Box (Main Stat)
            Expanded(
              flex: 2,
              child: _BentoBox(
                height: 180,
                color: AppColors.successFace,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('🎯', style: TextStyle(fontSize: 40)),
                    SizedBox(height: 12),
                    Text(
                      'QUEST\nMASTER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '3/3 Complete',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Two Stacked Boxes
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _BentoBox(
                    height: 84,
                    color: AppColors.vividPink,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('🔥', style: TextStyle(fontSize: 24)),
                        Text('5 DAYS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _BentoBox(
                    height: 84,
                    color: AppColors.energyFace,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('💎', style: TextStyle(fontSize: 24)),
                        Text('240', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Bottom Row: Three Medium
        Row(
          children: [
            Expanded(child: _buildLootItem('APPLE', 'WORD', Icons.apple_rounded, AppColors.successFace)),
            const SizedBox(width: 12),
            Expanded(child: _buildLootItem('SVO', 'STRUCT', Icons.architecture_rounded, AppColors.duoBlue)),
            const SizedBox(width: 12),
            Expanded(child: _buildLootItem('LEVEL 2', 'RANK', Icons.star_rounded, AppColors.warningFace)),
          ],
        ),
      ],
    );
  }

  Widget _buildLootItem(String label, String category, IconData icon, Color color) {
    return _BentoBox(
      height: 100,
      color: Colors.white,
      border: Border.all(color: color.withOpacity(0.2), width: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            category,
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: color, letterSpacing: 1.0),
          ),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: AppColors.textMain),
          ),
        ],
      ),
    );
  }
}

class _BentoBox extends StatelessWidget {
  const _BentoBox({
    required this.height,
    required this.color,
    required this.child,
    this.border,
  });

  final double height;
  final Color color;
  final Widget child;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: border,
        boxShadow: [
          if (color != Colors.white)
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: child,
    );
  }
}

class _EmptyLootState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          const Text('🦊', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            'NO COMPLETED QUESTS',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pick a stage and start learning!',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
