import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_app/domain/entities/pomodoro.dart';
import '../viewmodels/pomodoro_viewmodel.dart';
import '../providers/pomodoro_provider.dart';
import '../providers/stats_provider.dart';
import '../providers/settings_provider.dart';
import '../theme.dart';

class PomodoroScreen extends ConsumerWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final pomodoro = ref.watch(pomodoroViewModelProvider(settings));
    final viewModel = ref.read(pomodoroViewModelProvider(settings).notifier);
    final statsViewModel = ref.read(statsProvider.notifier);
    final theme = Theme.of(context);

    // Pomodoro tamamlandığında istatistiklere kayıt ekle
    ref.listen<Pomodoro>(pomodoroViewModelProvider(settings), (previous, next) {
      if (next.remaining == 0 && next.isRunning == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final focusMinutes = (viewModel.pomodoroDuration / 60).round();
          final breakMinutes = (viewModel.breakDuration / 60).round();
          statsViewModel.addRecord(
            focusMinutes: focusMinutes,
            breakMinutes: breakMinutes,
          );
        });
      }
    });

    if (settings.fullFocusMode) {
      // TAM ODAKLANMA MODU: Siyah ekran, sadece sayaç ve dokunarak çıkış
      return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            // Settings'i de güncelle
            ref.read(settingsProvider.notifier).setFullFocusMode(false);
          },
          child: SafeArea(
            child: Stack(
              children: [
                // Ana sayaç
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Timer Circle
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 280,
                              height: 280,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                  begin: 1.0,
                                  end: pomodoro.remaining / pomodoro.duration,
                                ),
                                duration: const Duration(milliseconds: 500),
                                builder: (context, value, child) {
                                  return CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 8,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.1,
                                    ),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                  );
                                },
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  formatTime(pomodoro.remaining),
                                  style: const TextStyle(
                                    fontSize: 72,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    letterSpacing: 4,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Odaklanma Zamanı',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.8),
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Bilgilendirme yazısı
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Çıkmak için dokunun',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Üst bilgi
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Tam Odaklanma Modu',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Normal mod
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
                  'Pomodoro Sayacı',
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
                child: Container(height: 1, color: const Color(0xFFE2E8F0)),
              ),
            ),

            // Timer Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Timer Circle
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: AppTheme.primaryGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 240,
                            height: 240,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 1.0,
                                end: pomodoro.remaining / pomodoro.duration,
                              ),
                              duration: const Duration(milliseconds: 500),
                              builder: (context, value, child) {
                                return CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 6,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.2,
                                  ),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                );
                              },
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatTime(pomodoro.remaining),
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Odaklanma Zamanı',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Start/Pause Button
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: pomodoro.isRunning
                                    ? AppTheme.warningGradient
                                    : AppTheme.successGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (pomodoro.isRunning
                                              ? AppTheme.warningColor
                                              : AppTheme.successColor)
                                          .withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  if (pomodoro.isRunning) {
                                    viewModel.pause();
                                  } else {
                                    viewModel.start();
                                    print(
                                      'Başlat butonuna basıldı, fullFocusMode: ${settings.fullFocusMode}',
                                    ); // Debug print
                                    if (settings.fullFocusMode) {
                                      print(
                                        'Odak modu açılıyor!',
                                      ); // Debug print
                                    } else {
                                      print(
                                        'Odak modu kapalı, normal modda kalıyor',
                                      ); // Debug print
                                    }
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      pomodoro.isRunning
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      pomodoro.isRunning
                                          ? 'Duraklat'
                                          : 'Başlat',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Reset Button
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF1E293B,
                                ).withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: viewModel.reset,
                              child: Icon(
                                Icons.refresh,
                                color: AppTheme.errorColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Focus Mode Toggle - KALDIRILDI
                    // Sadece ayarlardaki switch çalışacak
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
