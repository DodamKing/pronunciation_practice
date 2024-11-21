// lib/providers/practice_provider.dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class PracticeProvider extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  String _targetWord = '';
  String _lastRecognizedText = '';
  bool _isListening = false;
  bool _isInitialized = false;

  String get targetWord => _targetWord;
  String get lastRecognizedText => _lastRecognizedText;
  bool get isListening => _isListening;
  bool get isCorrect => _lastRecognizedText.toLowerCase() == _targetWord.toLowerCase();

  String get accuracyMessage {
    if (_lastRecognizedText.isEmpty) return '';

    // 간단한 정확도 평가 로직
    if (isCorrect) {
      return 'Perfect! 🎉';
    }

    // Levenshtein 거리를 사용한 유사도 계산
    int distance = _calculateLevenshteinDistance(
        _targetWord.toLowerCase(),
        _lastRecognizedText.toLowerCase()
    );

    double similarity = 1 - (distance / _targetWord.length);

    if (similarity > 0.8) {
      return 'Very Close! Try again 👍';
    } else if (similarity > 0.6) {
      return 'Getting there! Keep practicing 💪';
    } else {
      return 'Keep trying! 🎯';
    }
  }

  // 상태 초기화 메서드 추가
  void resetState() {
    _targetWord = '';
    _lastRecognizedText = '';
    _isListening = false;
    notifyListeners();
  }

  void setTargetWord(String word) {
    _targetWord = word;
    _lastRecognizedText = '';
    notifyListeners();
  }

  Future<void> startListening() async {
    if (!_isInitialized) {
      _isInitialized = await _speechToText.initialize();
    }

    if (_isInitialized && _targetWord.isNotEmpty) {
      _isListening = true;
      _lastRecognizedText = '';
      notifyListeners();

      await _speechToText.listen(
        onResult: (result) {
          _lastRecognizedText = result.recognizedWords;
          notifyListeners();
        },
        localeId: 'en_US',
        listenMode: ListenMode.confirmation,
      );
    }
  }

  Future<void> stopListening() async {
    _isListening = false;
    await _speechToText.stop();
    notifyListeners();
  }

  // Levenshtein 거리 계산 (문자열 유사도)
  int _calculateLevenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<List<int>> matrix = List.generate(
      s1.length + 1,
          (i) => List.generate(s2.length + 1, (j) => 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        int cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((min, val) => val < min ? val : min);
      }
    }

    return matrix[s1.length][s2.length];
  }
}