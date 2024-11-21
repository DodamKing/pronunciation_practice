// lib/widgets/practice_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/practice_provider.dart';

class PracticeButton extends StatelessWidget {
  const PracticeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PracticeProvider>(
      builder: (context, provider, _) {
        if (provider.targetWord.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTapDown: (_) => provider.startListening(),
              onTapUp: (_) => provider.stopListening(),
              onTapCancel: () => provider.stopListening(),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: provider.isListening
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: (provider.isListening
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary)
                          .withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  provider.isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              provider.isListening ? 'Release to stop' : 'Hold to speak',
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        );
      },
    );
  }
}