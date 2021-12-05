import 'package:aoku/models/aoi_sound.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final audioProvider = ChangeNotifierProvider<AudioState>((_) => AudioState());

class AudioState extends ChangeNotifier {
  bool _isPlaying = false;
  bool _isInitialized = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final AudioCache _audioCache = AudioCache(
    fixedPlayer: _audioPlayer,
    prefix: 'sounds/',
  );
  final List<AoiSound> _sounds = aoiSoundsMaster;
  late int _index;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool get isPlaying => _isPlaying;
  bool get isInitialized => _isInitialized;
  AudioPlayer get audioPlayer => _audioPlayer;
  AudioCache get audioCache => _audioCache;
  List<AoiSound> get aoiSounds => _sounds;
  int get index => _index;
  Duration get duration => _duration;
  Duration get position => _position;

  set initialIndex(int initialIndex) {
    _index = initialIndex;
  }

  void initAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
    });
    _audioPlayer.onAudioPositionChanged.listen((position) {
      _position = position;
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      _isPlaying = false;
    });
    _isInitialized = true;
    notifyListeners();
  }

  void load() {
    _audioCache.load(_sounds[_index].fileName);
    notifyListeners();
  }

  void play() {
    if (!_isInitialized) {
      initAudioPlayer();
    }

    _audioCache.play(_sounds[_index].fileName);
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void stop() {
    _audioPlayer.stop();
    _isPlaying = false;
    notifyListeners();
  }

  void next() {
    stop();
    _index++;
    notifyListeners();
    play();
    notifyListeners();
  }

  void previous() {
    stop();
    _index--;
    notifyListeners();
    play();
    notifyListeners();
  }
}