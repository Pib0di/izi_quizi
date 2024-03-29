import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/widgets/selection_slide/selection_slide_case.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

final selectionSlideProvider = StateNotifierProvider((ref) {
  return SelectionSlideController(ref);
});

// state - number of the selected slide
class SelectionSlideController extends StateNotifier<int> {
  SelectionSlideController(this.ref) : super(0);

  Ref ref;
  Key currentKeySelectSlide = UniqueKey();

  final TextEditingController controller = TextEditingController();
  final TextEditingController urlTextController = TextEditingController();

  bool freeResponseSlide = false;
  bool surveySlide = false;
  bool audioSlide = true;

  Widget? _mediaWidget;

  void setMediaWidget(Widget widget) {
    _mediaWidget = widget;
  }

  Widget getMediaWidget() {
    return _mediaWidget ?? const CircularProgressIndicator();
  }

  var isPickImage = false;

  void pickImage() {
    final isMobileDevice = ref.read(appDataProvider.notifier).isMobileDevice;
    isPickImage = true;
    if (isMobileDevice) {
      pickImageWeb(ref);
    } else {
      pickImagePC(ref);
    }
  }

  final _audioRecorder = Record();
  Timer? _timer;
  int recordDuration = 0;
  bool recording = false;
  String? path;

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      ++recordDuration;
      updateUi();
    });
  }

  Future<void> start() async {
    recordDuration = 0;
    recording = true;
    isPlayRecord = false;
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );

        await _audioRecorder.start(
          encoder: AudioEncoder.opus,
        );
        recordDuration = 0;

        _startTimer();
      }
    } catch (e) {
      return;
    }
  }

  Future<void> stop() async {
    _timer?.cancel();

    path = await _audioRecorder.stop();

    recording = false;
    updateUi();
  }

  bool isPlayRecord = false;

  Future<void> playRecord() async {
    isPlayRecord = true;
    final audioPlayer = AudioPlayer();
    if (path != null) {
      if (ref.read(appDataProvider.notifier).isMobile) {
        await audioPlayer.setFilePath(path!);
      } else {
        await audioPlayer.setUrl(path!);
      }
    }
    await audioPlayer.play();
    unawaited(audioPlayer.dispose());
    isPlayRecord = false;
    updateUi();
  }

  void updateUi() {
    ++state;
  }
}

class PageManager {}

enum ButtonState { paused, playing, loading }
