import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stats_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:easy_localization/easy_localization.dart';

enum StatsPeriod { daily, weekly, monthly }

class StatsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  StatsPeriod _selectedPeriod = StatsPeriod.daily;

  DateTimeRange getRange(StatsPeriod period) {
    final now = DateTime.now();
    if (period == StatsPeriod.daily) {
      return DateTimeRange(
        start: DateTime(now.year, now.month, now.day),
        end: now.add(const Duration(days: 1)),
      );
    } else if (period == StatsPeriod.weekly) {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      return DateTimeRange(
        start: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
        end: now.add(const Duration(days: 1)),
      );
    } else {
      return DateTimeRange(
        start: DateTime(now.year, now.month, 1),
        end: now.add(const Duration(days: 1)),
      );
    }
  }

  List<BarChartGroupData> getDailyBarChartData(stats) {
    final now = DateTime.now();
    final hours = List.generate(
      24,
      (i) => DateTime(now.year, now.month, now.day, i),
    );
    return List.generate(24, (i) {
      final from = hours[i];
      final to = from.add(const Duration(hours: 1));
      final count = stats.records
          .where((r) => !r.date.isBefore(from) && r.date.isBefore(to))
          .length;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(toY: count.toDouble(), color: Colors.blue, width: 8),
        ],
      );
    });
  }

  List<BarChartGroupData> getWeeklyBarChartData(stats) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final day = startOfWeek.add(Duration(days: i));
      final nextDay = day.add(const Duration(days: 1));
      final count = stats.getPomodorosFor(day, nextDay);
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(toY: count.toDouble(), color: Colors.blue, width: 18),
        ],
      );
    });
  }

  List<BarChartGroupData> getMonthlyBarChartData(stats) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    return List.generate(daysInMonth, (i) {
      final day = DateTime(now.year, now.month, i + 1);
      final nextDay = day.add(const Duration(days: 1));
      final count = stats.getPomodorosFor(day, nextDay);
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(toY: count.toDouble(), color: Colors.blue, width: 8),
        ],
      );
    });
  }

  Widget buildBarChart(stats) {
    if (_selectedPeriod == StatsPeriod.daily) {
      final bars = getDailyBarChartData(stats);
      return SizedBox(
        height: 180,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: bars.length * 20,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 3 == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${value.toInt()}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: bars,
              ),
            ),
          ),
        ),
      );
    } else if (_selectedPeriod == StatsPeriod.weekly) {
      final bars = getWeeklyBarChartData(stats);
      return SizedBox(
        height: 220,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: bars.length * 40,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final days = [
                          'monday_short'.tr(),
                          'tuesday_short'.tr(),
                          'wednesday_short'.tr(),
                          'thursday_short'.tr(),
                          'friday_short'.tr(),
                          'saturday_short'.tr(),
                          'sunday_short'.tr(),
                        ];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: bars,
              ),
            ),
          ),
        ),
      );
    } else {
      final bars = getMonthlyBarChartData(stats);
      return SizedBox(
        height: 220,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: bars.length * 16,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if ((value.toInt() + 1) % 5 == 0 ||
                            value.toInt() == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${value.toInt() + 1}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: bars,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = ref.watch(statsProvider);
    final statsViewModel = ref.read(statsProvider.notifier);
    final range = getRange(_selectedPeriod);
    final pomodoros = stats.getPomodorosFor(range.start, range.end);
    final focusMinutes = stats.getFocusMinutesFor(range.start, range.end);
    final breakMinutes = stats.getBreakMinutesFor(range.start, range.end);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text('stats'.tr()),
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onBackground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedButton<StatsPeriod>(
                segments: <ButtonSegment<StatsPeriod>>[
                  ButtonSegment(
                    value: StatsPeriod.daily,
                    label: Text('daily'.tr()),
                  ),
                  ButtonSegment(
                    value: StatsPeriod.weekly,
                    label: Text('weekly'.tr()),
                  ),
                  ButtonSegment(
                    value: StatsPeriod.monthly,
                    label: Text('monthly'.tr()),
                  ),
                ],
                selected: <StatsPeriod>{_selectedPeriod},
                onSelectionChanged: (Set<StatsPeriod> newSelection) {
                  setState(() {
                    _selectedPeriod = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 32),
              buildBarChart(stats),
              const SizedBox(height: 32),
              StatCard(
                title: 'total_pomodoros'.tr(),
                value: pomodoros.toString(),
                icon: Icons.timer,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              StatCard(
                title: 'total_focus_time'.tr(),
                value: '$focusMinutes min',
                icon: Icons.access_time,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              StatCard(
                title: 'total_break_time'.tr(),
                value: '$breakMinutes min',
                icon: Icons.coffee,
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
