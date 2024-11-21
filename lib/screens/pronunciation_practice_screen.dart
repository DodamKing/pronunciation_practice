// lib/screens/pronunciation_practice_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/practice_provider.dart';
import '../widgets/practice_button.dart';

class PronunciationPracticeScreen extends StatefulWidget {
  const PronunciationPracticeScreen({super.key});

  @override
  State<PronunciationPracticeScreen> createState() => _PronunciationPracticeScreenState();
}

class _PronunciationPracticeScreenState extends State<PronunciationPracticeScreen> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 화면이 생성될 때 상태 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PracticeProvider>().resetState();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronunciation Practice'),
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
            // SingleChildScrollView로 감싸서 스크롤 가능하게 함
            child: Column(
              children: [
                // 단어 입력 카드
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        hintText: 'Enter a word to practice',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            if (_textController.text.isNotEmpty) {
                              context.read<PracticeProvider>().setTargetWord(
                                  _textController.text.trim()
                              );
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 연습 영역을 Expanded로 감싸서 남은 공간을 채움
                Expanded(
                  child: Consumer<PracticeProvider>(
                    builder: (context, provider, _) {
                      if (provider.targetWord.isEmpty) {
                        return const Center(
                          child: Text(
                            'Enter a word above to start practicing',
                            style: TextStyle(fontSize: 18, color: Colors.white70),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 목표 단어 카드
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Practice this word:',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      provider.targetWord,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 발음 결과 카드
                            if (provider.lastRecognizedText.isNotEmpty) ...[
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Your pronunciation:',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        provider.lastRecognizedText,
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: provider.isCorrect
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        provider.accuracyMessage,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // 녹음 버튼
                const PracticeButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}