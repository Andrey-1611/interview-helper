import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'speech_state.dart';

class SpeechCubit extends Cubit<SpeechState> {
  final SpeechToText _speechToText;
  final FlutterTts _flutterTts;

  SpeechCubit(this._speechToText, this._flutterTts) : super(SpeechState());

  bool _isInit = false;

  Future<void> _init() async {
    await _speechToText.initialize();
    _isInit = true;
  }

  void toggleListening() async {
    if (!_isInit) await _init();
    if (state.isListening) {
      _speechToText.stop();
    } else {
      _speechToText.listen(
        onResult: (text) => emit(state.copyWith(text: text.recognizedWords)),
        localeId: 'ru_RU',
      );
    }
    emit(state.copyWith(isListening: !state.isListening));
  }

  void clearText() {
    emit(state.copyWith(text: ''));
  }

  Future<void> speak(String text) async {
    if (state.needSpeak) {
      await _flutterTts.setLanguage('ru_RU');
      await _flutterTts.speak(text);
    }
  }

  void toggleSpeaking() => emit(state.copyWith(needSpeak: !state.needSpeak));
}
