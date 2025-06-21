import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/quote_viewmodel.dart';

final quoteProvider = StateNotifierProvider.autoDispose
    .family<QuoteViewModel, QuoteState, Locale>((ref, locale) {
      return QuoteViewModel(locale: locale);
    });
