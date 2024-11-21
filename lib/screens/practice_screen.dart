// lib/screens/practice_screen.dart
import 'package:flutter/material.dart';
import '../widgets/speech_button.dart';
import '../widgets/word_display.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // WordDisplay를 Expanded로 감싸서 유연한 크기 조절
                const Expanded(
                  child: Center(
                    child: WordDisplay(),
                  ),
                ),
                // 하단 버튼 영역
                const SpeechButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}