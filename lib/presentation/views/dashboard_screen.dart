import 'package:flutter/material.dart';
import 'pomodoro_screen.dart';
import 'stats_screen.dart';
import 'todo_screen.dart';
import 'quote_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_DashboardItem> items = [
      _DashboardItem(
        title: 'Pomodoro Sayacı',
        icon: Icons.timer,
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PomodoroScreen()),
        ),
      ),
      _DashboardItem(
        title: 'İstatistikler',
        icon: Icons.bar_chart,
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StatsScreen()),
        ),
      ),
      _DashboardItem(
        title: 'Yapılacaklar',
        icon: Icons.check_circle,
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TodoScreen()),
        ),
      ),
      _DashboardItem(
        title: 'Günün Sözü',
        icon: Icons.format_quote,
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => QuoteScreen()),
        ),
      ),
      _DashboardItem(
        title: 'Ayarlar',
        icon: Icons.settings,
        color: Colors.grey,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SettingsScreen()),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro App'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          children: items.map((item) => _DashboardCard(item: item)).toList(),
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _DashboardItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _DashboardCard extends StatelessWidget {
  final _DashboardItem item;
  const _DashboardCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: item.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: item.color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: item.color, size: 48),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: TextStyle(
                color: item.color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
