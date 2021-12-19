import 'dart:developer';

import 'package:aoku/models/aoi_sound.dart';
import 'package:audio_session/audio_session.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

final audioProvider = ChangeNotifierProvider<AudioState>((_) => AudioState());

class AudioState extends ChangeNotifier {
  bool _isInitialized = false;
  final AudioPlayer _player = AudioPlayer();
  final List<AoiSound> _sounds = soundsMaster;
  late final ConcatenatingAudioSource _playList;
  int _currentIndex = 0;
  late Duration _duration;
  late Duration _position;

  bool get isPlaying => _player.playerState.playing;
  bool get isInitialized => _isInitialized;
  AudioPlayer get player => _player;
  List<AoiSound> get sounds => _sounds;
  ConcatenatingAudioSource get playList => _playList;
  int get currentIndex => _currentIndex;
  Duration get duration => _duration;
  Duration get position => _position;

  Future<bool> init() async {
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

    _isInitialized = true;
    notifyListeners();

    return true;
  }

  void play(int selectedIndex) {
    if (!_isInitialized) {
      init();
    }

    if (selectedIndex != _currentIndex) {
      _player.seek(
        Duration.zero,
        index: selectedIndex,
      );
      _currentIndex = selectedIndex;
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
}
