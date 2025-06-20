import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quote_provider.dart';
import '../theme.dart';

class QuoteScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteState = ref.watch(quoteProvider);
    final quoteViewModel = ref.read(quoteProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F2), // Açık kırmızı/pembe
      appBar: AppBar(
        title: const Text('Günün Sözü'),
        backgroundColor: const Color(0xFFFFF1F2),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.errorColor),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: AppTheme.errorColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.format_quote,
                    color: AppTheme.errorColor,
                    size: 48,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '"${quoteState.quote}"',
                    style: TextStyle(
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.errorColor.withOpacity(0.85),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: quoteViewModel.randomQuote,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Yeni Söz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
