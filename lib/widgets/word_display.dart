import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/speech_provider.dart';

class WordDisplay extends StatelessWidget {
  const WordDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeechProvider>(
      builder: (context, provider, _) {
        if (provider.isListening) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                'Listening...',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white70,
                ),
              ),
            ],
          );
        }

        if (provider.recognizedText.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.record_voice_over,
                size: 50,
                color: Colors.white70,
              ),
              SizedBox(height: 20),
              Text(
                'Hold the button and speak\nan English word',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white70,
                ),
              ),
            ],
          );
        }

        return Card(
          elevation: 10,
          color: Colors.white10,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'You said:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  provider.recognizedText,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                // 필요하다면 여기에 발음 평가 결과나 다른 정보를 추가할 수 있습니다
              ],
            ),
          ),
        );
      },
    );
  }
}