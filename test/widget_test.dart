// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomodoro_app/main.dart';
import 'package:pomodoro_app/domain/entities/pomodoro.dart';
import 'package:pomodoro_app/presentation/viewmodels/pomodoro_viewmodel.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

final pomodoroViewModelProvider =
    StateNotifierProvider<PomodoroViewModel, Pomodoro>((ref) {
      return PomodoroViewModel(pomodoroDuration: 1500, breakDuration: 300);
    });
