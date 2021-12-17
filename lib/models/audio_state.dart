import 'dart:developer';

import 'package:aoku/models/aoi_sound.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

final audioProvider = ChangeNotifierProvider<AudioState>((_) => AudioState());

class AudioState extends ChangeNotifier {
  bool _isInitialized = false;
  final AudioPlayer _player = AudioPlayer();
  final List<AoiSound> _sounds = soundsMaster;
  //late int _index;
  late Duration _duration;
  late Duration _position;

  late final ConcatenatingAudioSource _playList;

  bool get isPlaying => _player.playerState.playing;
  bool get isInitialized => _isInitialized;
  AudioPlayer get player => _player;
  List<AoiSound> get sounds => _sounds;
  //int get index => _player.currentIndex ?? 0;
  ConcatenatingAudioSource get playList => _playList;
  Duration get duration => _duration;
  Duration get position => _position;

  //set initialIndex(int initialIndex) {
  //  _index = initialIndex;
  //}

  Future<void> init() async {
    final AudioSession session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _player.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace stackTrace) {
        log('A stream error occured: $e');
        notifyListeners();
      },
    );

    _player.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });

    _player.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    _playList = ConcatenatingAudioSource(
      children: List.generate(10, (index) {
        return AudioSource.uri(
          Uri.parse('sounds/${_sounds[index].fileName}'),
          tag: MediaItem(
            id: _sounds[index].fileName,
            title: _sounds[index].title,
          ),
        );
      }),
    );

    _player.setAudioSource(_playList);

    _isInitialized = true;
    notifyListeners();
  }

  void play({required bool isSameSound}) {
    if (!_isInitialized) {
      init();
    }

    _player.play();
    notifyListeners();
  }

  void pause() {
    _player.pause();
    notifyListeners();
  }

  void stop() {
    _player.stop();
    notifyListeners();
  }

  void next() {
    //play(isSameSound: false);
    if (_player.hasNext) {
      _player.seekToNext();
    }
    notifyListeners();
  }

  void previous() {
    //play(isSameSound: false);
    if (_player.hasPrevious) {
      _player.seekToPrevious();
    }
    notifyListeners();
  }
}
