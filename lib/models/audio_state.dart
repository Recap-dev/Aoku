import 'dart:developer';

import 'package:aoku/components/album_art.dart';
import 'package:aoku/models/aoi_sound.dart';
import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  static final AudioState _instance = AudioState._internal();

  factory AudioState() => _instance;

  AudioState._internal();

  AudioStateInitStatus _initStatus = AudioStateInitStatus.notYet;
  final AudioPlayer _player = AudioPlayer();
  final List<AoiSound> _sounds = [];
  late ConcatenatingAudioSource _playList;
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

  Future<AudioStateInitStatus> init({bool? forceInit}) async {
    // forceInit is set to true when a user refreshes the app
    // null is treated as false
    if (!(forceInit ?? false)) {
      if (_initStatus == AudioStateInitStatus.done) {
        return _initStatus;
      }

      if (_initStatus == AudioStateInitStatus.inProgress) {
        return _initStatus;
      }
    }

    int initialIndex = 0;

    _processingState = _player.processingState;

    _initStatus = AudioStateInitStatus.inProgress;

    final AudioSession session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration.music(),
    );

    _player.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;

      // Anmate map when sequenceState changes
      if (smallMapController != null) {
        smallMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            _sounds[_player.currentIndex as int].location,
            8,
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
    final firestore = FirebaseFirestore.instance;

    final CollectionReference soundsCollection = firestore.collection('sounds');
    final QuerySnapshot soundsDocuments = await soundsCollection.get();
    final List<QueryDocumentSnapshot> soundsOnFirestore = soundsDocuments.docs;

    log('There\'re ${soundsOnFirestore.length} sounds.');

    sounds.clear();

    for (int i = 0; i < soundsOnFirestore.length; i++) {
      final Map<String, dynamic> fields =
          soundsOnFirestore[i].data() as Map<String, dynamic>;
      final String fileName = fields['fileName'] ?? 'unknown';
      final String title = fields['title'] ?? 'unknown';
      final String city = fields['city'] ?? 'unknown';
      final Duration length =
          Duration(seconds: (fields['lengthInSeconds']) ?? Duration.zero);
      final String province = fields['province'] ?? 'unknown';
      final LatLng location = LatLng(
        (fields['location'] as GeoPoint).latitude,
        (fields['location'] as GeoPoint).longitude,
      );
      final Timestamp timestamp = fields['timestamp'] ?? Timestamp.now();
      final TimeOfDay timeOfDay = TimeOfDay(
        hour: timestamp.toDate().hour,
        minute: timestamp.toDate().minute,
      );
      final String downloadURL =
          await storage.ref('sounds/$fileName').getDownloadURL();

      sounds.add(
        AoiSound(
          title: title,
          fileName: fileName,
          location: location,
          length: length,
          city: city,
          province: province,
          time: timeOfDay,
          downloadURL: downloadURL,
        ),
      );

      log('Got a sound: $title');
    }

    _playList = ConcatenatingAudioSource(
      children: List.generate(soundsOnFirestore.length, (i) {
        return AudioSource.uri(
          Uri.parse(sounds[i].downloadURL),
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
    // null is treated as false
    if (forceEnable ?? false) {
      _shuffleModeEnabled = true;
    } else {
      _shuffleModeEnabled = !shuffleModeEnabled;
    }

    await _player.setShuffleModeEnabled(_shuffleModeEnabled);
    notifyListeners();
  }

  Future<void> setLoopMode({bool? forceEnable}) async {
    // null is treated as false
    if (forceEnable ?? false) {
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
