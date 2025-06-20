import 'package:flutter/material.dart';
import '../theme.dart';
import 'pomodoro_screen.dart';
import 'stats_screen.dart';
import 'todo_screen.dart';
import 'quote_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<_DashboardItem> items = [
      _DashboardItem(
        title: 'Pomodoro Sayacı',
        subtitle: 'Odaklanma zamanı',
        icon: Icons.timer_outlined,
        gradient: AppTheme.primaryGradient,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PomodoroScreen()),
        ),
      ),
      _DashboardItem(
        title: 'İstatistikler',
        subtitle: 'Performansınızı takip edin',
        icon: Icons.analytics_outlined,
        gradient: AppTheme.successGradient,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StatsScreen()),
        ),
      ),
      _DashboardItem(
        title: 'Yapılacaklar',
        subtitle: 'Görevlerinizi yönetin',
        icon: Icons.task_alt_outlined,
        gradient: AppTheme.warningGradient,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TodoScreen()),
        ),
      ),
      _DashboardItem(
        title: 'Günün Sözü',
        subtitle: 'Motivasyon için',
        icon: Icons.format_quote_outlined,
        gradient: AppTheme.errorGradient,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => QuoteScreen()),
        ),
      ),
      _DashboardItem(
        title: 'Ayarlar',
        subtitle: 'Uygulama ayarları',
        icon: Icons.settings_outlined,
        gradient: [AppTheme.primaryColor, AppTheme.accentColor],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SettingsScreen()),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Modern App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: theme.colorScheme.background,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Pomodoro App',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onBackground,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(height: 1, color: const Color(0xFFE2E8F0)),
              ),
            ),

            // Welcome Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hoş geldiniz! 👋',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onBackground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bugün odaklanmaya hazır mısınız?',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Dashboard Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _DashboardCard(item: items[index]),
                  childCount: items.length,
                ),
              ),
            ),

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  _DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
}

class _DashboardCard extends StatelessWidget {
  final _DashboardItem item;

  const _DashboardCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: item.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: item.gradient.first.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(item.icon, color: Colors.white, size: 28),
              ),

              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
