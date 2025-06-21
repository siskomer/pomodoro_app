import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../theme.dart';
import '../providers/theme_mode_provider.dart';
import '../../main.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);

    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Modern App Bar
            SliverAppBar(
              expandedHeight: 80,
              floating: false,
              pinned: true,
              backgroundColor: theme.colorScheme.background,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: theme.colorScheme.onBackground,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'settings'.tr(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  height: 1,
                  color: theme.dividerColor.withOpacity(0.5),
                ),
              ),
            ),

            // Settings Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pomodoro Duration Setting
                    AppTheme.modernCard(
                      backgroundColor: theme.cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.timer_outlined,
                                  color: theme.colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'pomodoro_duration'.tr(),
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      'focus_period_subtitle'.tr(),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppTheme.accentColor,
                              inactiveTrackColor:
                                  theme.colorScheme.surfaceVariant,
                              thumbColor: AppTheme.accentColor,
                              overlayColor: AppTheme.accentColor.withOpacity(
                                0.1,
                              ),
                              valueIndicatorColor: AppTheme.accentColor,
                              valueIndicatorTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Slider(
                              value: settings.pomodoroMinutes.toDouble(),
                              min: 10,
                              max: 60,
                              divisions: 10,
                              label:
                                  '${settings.pomodoroMinutes} ${"minutes".tr()}',
                              onChanged: (value) => settingsNotifier
                                  .setPomodoroMinutes((value ~/ 5) * 5),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '10${"min_suffix".tr()}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              Text(
                                '${settings.pomodoroMinutes} ${"minutes".tr()}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '60${"min_suffix".tr()}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Break Duration Setting
                    AppTheme.modernCard(
                      backgroundColor: theme.cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.successColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.coffee_outlined,
                                  color: theme.colorScheme.secondary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'break_duration'.tr(),
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      'break_period_subtitle'.tr(),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppTheme.accentColor,
                              inactiveTrackColor:
                                  theme.colorScheme.surfaceVariant,
                              thumbColor: AppTheme.accentColor,
                              overlayColor: AppTheme.accentColor.withOpacity(
                                0.1,
                              ),
                              valueIndicatorColor: AppTheme.accentColor,
                              valueIndicatorTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Slider(
                              value: settings.breakMinutes.toDouble(),
                              min: 5,
                              max: 30,
                              divisions: 5,
                              label:
                                  '${settings.breakMinutes} ${"minutes".tr()}',
                              onChanged: (value) => settingsNotifier
                                  .setBreakMinutes((value ~/ 5) * 5),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '5${"min_suffix".tr()}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              Text(
                                '${settings.breakMinutes} ${"minutes".tr()}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '30${"min_suffix".tr()}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Focus Mode Setting
                    AppTheme.modernCard(
                      backgroundColor: theme.cardColor,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.fullscreen_outlined,
                              color: theme.colorScheme.secondary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'full_focus_mode'.tr(),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'full_focus_mode_subtitle'.tr(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: settings.fullFocusMode,
                            onChanged: (value) => ref
                                .read(settingsProvider.notifier)
                                .setFullFocusMode(value),
                            activeColor: AppTheme.accentColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Tema Seçimi
                    AppTheme.modernCard(
                      backgroundColor: theme.cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.brightness_6_rounded,
                                color: theme.colorScheme.primary,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'theme'.tr(),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          RadioListTile<AppThemeMode>(
                            value: AppThemeMode.system,
                            groupValue: themeMode,
                            onChanged: (v) =>
                                themeModeNotifier.setTheme(AppThemeMode.system),
                            title: Text('use_system_theme'.tr()),
                          ),
                          RadioListTile<AppThemeMode>(
                            value: AppThemeMode.light,
                            groupValue: themeMode,
                            onChanged: (v) =>
                                themeModeNotifier.setTheme(AppThemeMode.light),
                            title: Text('light_theme'.tr()),
                          ),
                          RadioListTile<AppThemeMode>(
                            value: AppThemeMode.dark,
                            groupValue: themeMode,
                            onChanged: (v) =>
                                themeModeNotifier.setTheme(AppThemeMode.dark),
                            title: Text('dark_theme'.tr()),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Info Section
                    AppTheme.modernCard(
                      backgroundColor: theme.cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: theme.colorScheme.secondary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'information'.tr(),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'pomodoro_info_text'.tr(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Notification Setting
                    AppTheme.modernCard(
                      backgroundColor: theme.cardColor,
                      child: ListTile(
                        title: Text('enable_notifications'.tr()),
                        trailing: Switch(
                          value: settings.notificationEnabled ?? true,
                          onChanged: (value) async {
                            await ref
                                .read(settingsProvider.notifier)
                                .setNotificationEnabled(value);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Keep Screen On Setting
                    AppTheme.modernCard(
                      backgroundColor: theme.cardColor,
                      child: ListTile(
                        title: Text('keep_screen_on'.tr()),
                        trailing: Switch(
                          value: settings.keepScreenOn ?? false,
                          onChanged: (value) async {
                            await ref
                                .read(settingsProvider.notifier)
                                .setKeepScreenOn(value);
                          },
                        ),
                      ),
                    ),

                    // Language Setting Card
                    const SizedBox(height: 16),
                    AppTheme.modernCard(
                      backgroundColor: theme.cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'language'.tr(),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SegmentedButton<Locale>(
                            segments: <ButtonSegment<Locale>>[
                              ButtonSegment<Locale>(
                                value: const Locale('en', 'US'),
                                label: Text(
                                  'English',
                                  style: TextStyle(
                                    color:
                                        context.locale ==
                                            const Locale('en', 'US')
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              ButtonSegment<Locale>(
                                value: const Locale('tr', 'TR'),
                                label: Text(
                                  'Türkçe',
                                  style: TextStyle(
                                    color:
                                        context.locale ==
                                            const Locale('tr', 'TR')
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                            selected: <Locale>{context.locale},
                            onSelectionChanged: (Set<Locale> newSelection) {
                              context.setLocale(newSelection.first);
                            },
                            style: SegmentedButton.styleFrom(
                              backgroundColor: theme.colorScheme.surfaceVariant,
                              foregroundColor: theme.colorScheme.onSurface,
                              selectedBackgroundColor:
                                  theme.colorScheme.primary,
                              selectedForegroundColor:
                                  theme.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
