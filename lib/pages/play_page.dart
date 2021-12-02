import 'package:aoku/components/album_art.dart';
import 'package:aoku/components/aoi_progress_bar.dart';
import 'package:aoku/components/heart_button.dart';
import 'package:aoku/components/map_button.dart';
import 'package:aoku/components/info_text.dart';
import 'package:aoku/components/next_button.dart';
import 'package:aoku/components/pause_button.dart';
import 'package:aoku/components/play_button.dart';
import 'package:aoku/components/previous_button.dart';
import 'package:aoku/models/aoi_sound.dart';
import 'package:aoku/pages/map_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayPage extends StatefulWidget {
  PlayPage({
    Key? key,
    required this.aoiSounds,
    required this.currentIndex,
  }) : super(key: key);

  final String fileNamePrefix = 'sounds/';
  final List<AoiSound> aoiSounds;

  // Might be changed if next/previous is pressed
  int currentIndex;

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late final AudioPlayer _audioPlayer;
  late final AudioCache _audioCache;
  bool _isPlaying = false;
  Duration _currentDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  late String cachedFilePath;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
    _audioCache.load(widget.aoiSounds[widget.currentIndex].fileName);
    _onPlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            _onStop();
          },
          icon: const Icon(CupertinoIcons.chevron_left),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(1.0, -1.0),
                child: Image.asset(
                  'images/orange-blur.png',
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: const Alignment(-1.0, 1.0),
                child: Image.asset(
                  'images/blue-blur-1.png',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      AlbumArt(widget: widget),
                      const SizedBox(
                        height: 48.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const HeartButton(),
                          InfoText(widget: widget),
                          MapButton(onPressed: _onMapTapped),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  AoiProgressBar(
                    currentPosition: _currentPosition,
                    currentDuration: _currentDuration,
                    audioPlayer: _audioPlayer,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PreviousButton(
                        widget: widget,
                        onPressed: _onPrevious,
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      _isPlaying
                          ? PauseButton(onPressed: _onPause)
                          : PlayButton(onPressed: _onPlay),
                      const SizedBox(
                        width: 40,
                      ),
                      NextButton(
                        widget: widget,
                        onPressed: _onNext,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initAudioPlayer() {
    _audioPlayer = AudioPlayer();
    _audioCache = AudioCache(
      fixedPlayer: _audioPlayer,
      prefix: widget.fileNamePrefix,
    );
    _audioCache.clearAll();
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _currentDuration = duration;
      });
    });
    _audioPlayer.onAudioPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      if (widget.currentIndex != widget.aoiSounds.length - 1) {
        _onNext();
      } else {
        Navigator.pop(context);
      }
    });
  }

  void _onPlay() {
    _audioCache.play(widget.aoiSounds[widget.currentIndex].fileName);
    setState(() {
      _isPlaying = true;
    });
  }

  void _onPause() {
    _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _onStop() {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  void _onNext() {
    _onStop();
    if (!(widget.currentIndex == widget.aoiSounds.length - 1)) {
      setState(() {
        widget.currentIndex = widget.currentIndex + 1;
      });
      _onPlay();
    }
  }

  void _onPrevious() {
    _onStop();
    if (!(widget.currentIndex == 0)) {
      setState(() {
        widget.currentIndex = widget.currentIndex - 1;
      });
      _onPlay();
    }
  }

  void _onMapTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(
          initialLocation: widget.aoiSounds[widget.currentIndex].location,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.release();
    _audioPlayer.dispose();
    _audioCache.clearAll();
    super.dispose();
  }
}
