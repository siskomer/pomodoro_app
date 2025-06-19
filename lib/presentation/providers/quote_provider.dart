import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/quote_viewmodel.dart';

final quoteProvider = StateNotifierProvider<QuoteViewModel, QuoteState>((ref) {
  return QuoteViewModel();
});
