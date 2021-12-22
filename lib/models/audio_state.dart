import 'dart:developer';

import 'package:aoku/components/album_art.dart';
import 'package:aoku/models/aoi_sound.dart';
import 'package:audio_session/audio_session.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

final audioProvider = ChangeNotifierProvider<AudioState>((_) => AudioState());

enum AudioStateInitStatus {
  notYet,
  inProgress,
  done,
}

class AudioState extends ChangeNotifier {
  AudioStateInitStatus _initStatus = AudioStateInitStatus.notYet;
  final AudioPlayer _player = AudioPlayer();
  final List<AoiSound> _sounds = soundsMaster;
  late final ConcatenatingAudioSource _playList;
  int _currentIndex = 0;
  ProcessingState? _processingState;
  late Duration _duration;
  late Duration _position;
  late Duration _buffered;
  bool _shuffleModeEnabled = false;
  LoopMode _loopMode = LoopMode.off;

  bool get isPlaying => _player.playerState.playing;
  bool get hasNext => _player.hasNext;
  bool get hasPrevious => _player.hasPrevious;
  AudioStateInitStatus get initStatus => _initStatus;
  AudioPlayer get player => _player;
  List<AoiSound> get sounds => _sounds;
  int get currentIndex => _currentIndex;
  ProcessingState? get processingState => _processingState;
  Duration get duration => _duration;
  Duration get position => _position;
  Duration get buffered => _buffered;
  bool get shuffleModeEnabled => _shuffleModeEnabled;
  LoopMode get loopMode => _loopMode;

  Future<AudioStateInitStatus> init(int initialIndex) async {
    if (_initStatus == AudioStateInitStatus.done) {
      return _initStatus;
    }

    if (_initStatus == AudioStateInitStatus.inProgress) {
      return _initStatus;
    }

    _processingState = _player.processingState;

    _initStatus = AudioStateInitStatus.inProgress;

    final AudioSession session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration.music(),
    );
    List<String> urls = [];

    _player.sequenceStateStream.listen((sequenceState) {
      log('sequenceStream changed.');

      if (sequenceState == null) return;

      if (smallMapController != null) {
        smallMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            _sounds[_player.currentIndex as int].location,
            12,
          ),
        );
      } else {
        log('Ignoring because smallMapController is null.');
      }

      _currentIndex = sequenceState.currentIndex;

      notifyListeners();
    });

    _player.processingStateStream.listen((processingState) {
      _processingState = processingState;
      notifyListeners();
    });

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

    _player.bufferedPositionStream.listen((buffered) {
      _buffered = buffered;
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

    final storage = firebase_storage.FirebaseStorage.instance;

    for (int i = 0; i < sounds.length; i++) {
      log('fetching ${_sounds[i].fileName}');

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
      children: List.generate(10, (i) {
        return AudioSource.uri(
          Uri.parse(urls[i]),
          tag: MediaItem(
            id: _sounds[i].fileName,
            title: _sounds[i].title,
            artUri: Uri(
              path: 'images/icon.png',
            ),
          ),
        );
      }),
    );

    await _player.setAudioSource(_playList);

    if (initialIndex != _currentIndex) {
      await _player.seek(
        Duration.zero,
        index: initialIndex,
      );
      _currentIndex = initialIndex;
    }

    _initStatus = AudioStateInitStatus.done;
    log('Initialized.');
    notifyListeners();

    return AudioStateInitStatus.done;
  }

  Future<void> play(int selectedIndex) async {
    if (selectedIndex != _currentIndex) {
      await _player.seek(
        Duration.zero,
        index: selectedIndex,
      );
      _currentIndex = selectedIndex;
    }

    _player.play();
    notifyListeners();
  }

  Future<void> pause() async {
    await _player.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    await _player.stop();
    notifyListeners();
  }

  Future<void> next() async {
    if (_player.hasNext) {
      await _player.seekToNext();
      _currentIndex++;
    }
    notifyListeners();
  }

  Future<void> previous() async {
    if (_player.hasPrevious) {
      await _player.seekToPrevious();
      _currentIndex--;
    }
    notifyListeners();
  }

  Future<void> toggleShuffleMode({bool? forceEnable}) async {
    if (forceEnable == true) {
      _shuffleModeEnabled = true;
    } else {
      _shuffleModeEnabled = !shuffleModeEnabled;
    }

    await _player.setShuffleModeEnabled(_shuffleModeEnabled);
    notifyListeners();
  }

  Future<void> toggleLoopMode({bool? forceEnable}) async {
    if (forceEnable == true) {
      _loopMode = LoopMode.all;
    } else if (_loopMode == LoopMode.off) {
      _loopMode = LoopMode.all;
    } else if (_loopMode == LoopMode.all) {
      _loopMode = LoopMode.one;
    } else {
      _loopMode = LoopMode.off;
    }

    await _player.setLoopMode(_loopMode);
    notifyListeners();
  }
}
