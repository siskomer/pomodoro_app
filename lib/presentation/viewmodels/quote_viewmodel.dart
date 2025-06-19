import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class QuoteState {
  final String quote;
  QuoteState({required this.quote});
}

class QuoteViewModel extends StateNotifier<QuoteState> {
  static final List<String> _quotes = [
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
  ];

  QuoteViewModel() : super(QuoteState(quote: _quotes[0]));

  void randomQuote() {
    final random = Random();
    final newQuote = _quotes[random.nextInt(_quotes.length)];
    state = QuoteState(quote: newQuote);
  }
}
