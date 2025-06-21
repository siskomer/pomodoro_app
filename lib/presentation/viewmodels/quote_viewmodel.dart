import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuoteState {
  final String quote;
  QuoteState({required this.quote});
}

class QuoteViewModel extends StateNotifier<QuoteState> {
  final Locale locale;

  static final Map<String, List<String>> _quotes = {
    'en': [
      "You don't have to be great to start, but you have to start to be great.",
      "Focus, breathe, and keep going.",
      "A small step you take today can turn into a great success tomorrow.",
      "Use your time wisely, as it will never come back.",
      "Success comes from trying again and again.",
      "Every day is a new beginning.",
      "Never give up on working for your dreams.",
      "Small steps create big changes.",
      "The best time is now!",
      "You are the source of your motivation.",
    ],
    'tr': [
      'Başlamak için mükemmel olmak zorunda değilsin, ama mükemmel olmak için başlamak zorundasın.',
      'Odaklan, nefes al ve devam et.',
      'Bugün yapacağın küçük bir adım, yarın büyük bir başarıya dönüşebilir.',
      'Zamanını iyi kullan, çünkü bir daha geri gelmez.',
      'Başarı, tekrar tekrar denemekten geçer.',
      'Her gün yeni bir başlangıçtır.',
      'Hayallerin için çalışmaktan asla vazgeçme.',
      'Küçük adımlar büyük değişimler yaratır.',
      'En iyi zaman şimdi!',
      'Motivasyonun kaynağı sensin.',
    ],
  };

  QuoteViewModel({required this.locale})
    : super(
        QuoteState(
          quote: _quotes[locale.languageCode]?.first ?? _quotes['en']!.first,
        ),
      );

  void randomQuote() {
    final random = Random();
    final langCode = locale.languageCode;
    final quoteList = _quotes[langCode] ?? _quotes['en']!;
    final newQuote = quoteList[random.nextInt(quoteList.length)];
    state = QuoteState(quote: newQuote);
  }
}
