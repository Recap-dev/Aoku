import 'dart:developer';

import 'package:aoku/models/aoi_sound.dart';
import 'package:audio_session/audio_session.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

final audioProvider = ChangeNotifierProvider<AudioState>((_) => AudioState());

enum AudioStateInitStatus {
  notInitialized,
  inProgress,
  initialized,
}

class AudioState extends ChangeNotifier {
  AudioStateInitStatus _initStatus = AudioStateInitStatus.notInitialized;
  final AudioPlayer _player = AudioPlayer();
  final List<AoiSound> _sounds = soundsMaster;
  late final ConcatenatingAudioSource _playList;
  int _currentIndex = 0;
  late Duration _duration;
  late Duration _position;
  bool _shuffleModeEnabled = false;
  LoopMode _loopMode = LoopMode.off;

  bool get isPlaying => _player.playerState.playing;
  AudioStateInitStatus get initStatus => _initStatus;
  AudioPlayer get player => _player;
  List<AoiSound> get sounds => _sounds;
  ConcatenatingAudioSource get playList => _playList;
  int get currentIndex => _currentIndex;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get shuffleModeEnabled => _shuffleModeEnabled;
  LoopMode get loopMode => _loopMode;

  Future<bool> init(int initialIndex) async {
    _initStatus = AudioStateInitStatus.inProgress;

    final AudioSession session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    List<String> urls = [];

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

    _player.playerStateStream.listen((state) {
      notifyListeners();
    });

    _player.shuffleModeEnabledStream.listen((shuffleModeEnabled) {
      _shuffleModeEnabled = shuffleModeEnabled;
      notifyListeners();
    });

    _player.loopModeStream.listen((loopModeEnabled) {
      _loopMode = loopModeEnabled;
      notifyListeners();
    });

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    for (int i = 0; i < sounds.length; i++) {
      log('sounds/${_sounds[i].fileName}');

      try {
        urls.add(
          // Read the sound file from Firebase Cloud Storage
          await storage.ref('sounds/${_sounds[i].fileName}').getDownloadURL(),
        );
      } on firebase_storage.FirebaseException catch (e) {
        log('Error getting download url: $e');
      } on Exception catch (e) {
        log('Error getting download url: $e');
      }
    }

    _playList = ConcatenatingAudioSource(
      children: List.generate(10, (index) {
        return AudioSource.uri(
          Uri.parse(urls[index]),
          tag: MediaItem(
            id: _sounds[index].fileName,
            title: _sounds[index].title,
          ),
        );
      }),
    );

    _player.setAudioSource(_playList);

    if (initialIndex != _currentIndex) {
      _player.seek(
        Duration.zero,
        index: initialIndex,
      );
      _currentIndex = initialIndex;
    }

    _initStatus = AudioStateInitStatus.initialized;
    notifyListeners();

    return true;
  }

  Future<void> play(int selectedIndex) async {
    if (_initStatus == AudioStateInitStatus.notInitialized) {
      log('Initializing AudioState...');
      await init(selectedIndex);
      log('Done');
    }

    log('currentIndex: $_currentIndex');
    log('selectedIndex: $selectedIndex');

    if (selectedIndex != _currentIndex) {
      await _player.seek(
        Duration.zero,
        index: selectedIndex,
      );
      _currentIndex = selectedIndex;
    }

    await _player.play();
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
    if (_player.hasNext) {
      _player.seekToNext();
      _currentIndex++;
    }
    notifyListeners();
  }

  void previous() {
    if (_player.hasPrevious) {
      _player.seekToPrevious();
      _currentIndex--;
    }
    notifyListeners();
  }

  void toggleShuffleMode() {
    _shuffleModeEnabled = !shuffleModeEnabled;
    _player.setShuffleModeEnabled(_shuffleModeEnabled);
    notifyListeners();
  }

  void toggleLoopMode() {
    if (_loopMode == LoopMode.off) {
      _loopMode = LoopMode.all;
    } else if (_loopMode == LoopMode.all) {
      _loopMode = LoopMode.one;
    } else {
      _loopMode = LoopMode.off;
    }
    _player.setLoopMode(_loopMode);
    notifyListeners();
  }
}
