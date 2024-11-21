// lib/providers/speech_provider.dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechProvider extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';
  bool _isInitialized = false;

  bool get isListening => _isListening;
  String get recognizedText => _recognizedText;

  // 초기화 함수
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 마이크 권한 요청
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      _isInitialized = false;
      return;
    }

    // speech_to_text 초기화
    _isInitialized = await _speechToText.initialize(
      onError: (error) => print('Error: $error'),
      onStatus: (status) => print('Status: $status'),
    );

    notifyListeners();
  }

  // 음성 인식 시작
  Future<void> startListening() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isInitialized) {
      _isListening = true;
      _recognizedText = '';
      notifyListeners();

      await _speechToText.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;
          notifyListeners();
        },
        localeId: 'en_US', // 영어 인식
        partialResults: false, // 최종 결과만 받기
        listenMode: ListenMode.confirmation, // 단어 확인 모드
      );
    } else {
      _recognizedText = 'Microphone permission denied';
      notifyListeners();
    }
  }

  // 음성 인식 중지
  Future<void> stopListening() async {
    _isListening = false;
    await _speechToText.stop();
    notifyListeners();
  }

  // 상태 초기화
  void reset() {
    _recognizedText = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }
}