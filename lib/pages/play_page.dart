import 'dart:ui';

import 'package:aoku/models/aoi_sound.dart';
import 'package:aoku/pages/map_page.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlayPage extends StatefulWidget {
  PlayPage({
    Key? key,
    required this.aoiSoundsList,
    required this.currentIndex,
    required this.currentTitle,
    required this.currentFileName,
    required this.city,
    required this.province,
    required this.location,
  }) : super(key: key);

  final String fileNamePrefix = 'sounds/';
  final List<AoiSound> aoiSoundsList;

  // Might be changed if next/previous is pressed
  int currentIndex;
  String currentTitle;
  String currentFileName;
  String city;
  String province;
  LatLng location;

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
      if (widget.currentIndex != widget.aoiSoundsList.length - 1) {
        _onNext();
      } else {
        Navigator.pop(context);
      }
    });
    _audioCache.load(widget.currentFileName);
    _onPlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFE3E3E3),
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            _onStop();
          },
          icon: const Icon(CupertinoIcons.chevron_left),
        ),
      ),
      backgroundColor: const Color(0xFFE3E3E3),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SafeArea(
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
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Column(
                          children: [
                            ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 20.0, sigmaY: 20.0),
                                child: Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.currentTitle,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 48.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const IconButton(
                                  icon: Icon(
                                    CupertinoIcons.heart_fill,
                                    color: Colors.pink,
                                  ),
                                  onPressed: null,
                                  iconSize: 32.0,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.map_fill,
                                    color: Colors.white,
                                  ),
                                  onPressed: _onMapTapped,
                                  iconSize: 32.0,
                                ),
                                const SizedBox(
                                  width: 12.0,
                                ),
                                GestureDetector(
                                  onTap: _onMapTapped,
                                  child: Text(
                                    '${widget.city}, ${widget.province}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      StreamBuilder<Object>(
                          stream: null,
                          builder: (context, snapshot) {
                            return ProgressBar(
                              progress: _currentPosition,
                              total: _currentDuration,
                              barHeight: 2,
                              barCapShape: BarCapShape.square,
                              thumbColor: Colors.white,
                              baseBarColor: Colors.white.withOpacity(0.1),
                              progressBarColor: Colors.white.withOpacity(0.8),
                              bufferedBarColor: Colors.transparent,
                              thumbRadius: 4,
                              thumbGlowRadius: 6,
                              timeLabelTextStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              timeLabelPadding: 10.0,
                              onSeek: (Duration duration) {
                                HapticFeedback.selectionClick();
                                _audioPlayer.seek(duration);
                              },
                              onDragStart:
                                  (ThumbDragDetails thumbDragDetails) =>
                                      HapticFeedback.lightImpact(),
                              onDragEnd: () => HapticFeedback.mediumImpact(),
                            );
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed:
                                widget.currentIndex == 0 ? null : _onPrevious,
                            icon: Icon(
                              CupertinoIcons.backward_fill,
                              color: widget.currentIndex == 0
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.white,
                            ),
                            iconSize: 48,
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          if (!_isPlaying)
                            IconButton(
                              onPressed: () {
                                _onPlay();
                              },
                              icon: const Icon(
                                CupertinoIcons.play_fill,
                                color: Colors.white,
                              ),
                              iconSize: 56,
                            )
                          else
                            IconButton(
                              onPressed: () {
                                _onPause();
                              },
                              icon: const Icon(
                                CupertinoIcons.pause_fill,
                                color: Colors.white,
                              ),
                              iconSize: 56,
                            ),
                          const SizedBox(
                            width: 40,
                          ),
                          IconButton(
                            onPressed: widget.currentIndex ==
                                    widget.aoiSoundsList.length - 1
                                ? null
                                : _onNext,
                            icon: Icon(
                              CupertinoIcons.forward_fill,
                              color: widget.currentIndex ==
                                      widget.aoiSoundsList.length - 1
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.white,
                            ),
                            iconSize: 48,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPlay() {
    _audioCache.play(widget.currentFileName);
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
    //_audioCache.clear(widget.selectedFileName);
    if (widget.currentIndex == widget.aoiSoundsList.length - 1) {
      Navigator.pop(context);
    } else {
      setState(() {
        widget.currentIndex = widget.currentIndex + 1;
        widget.currentFileName =
            widget.aoiSoundsList[widget.currentIndex].fileName;
        widget.currentTitle = widget.aoiSoundsList[widget.currentIndex].title;
      });
      _onPlay();
    }
  }

  void _onPrevious() {
    _onStop();
    //_audioCache.clear(widget.selectedFileName);
    if (widget.currentIndex == 0) {
      Navigator.pop(context);
    } else {
      setState(() {
        widget.currentIndex = widget.currentIndex - 1;
        widget.currentFileName =
            widget.aoiSoundsList[widget.currentIndex].fileName;
        widget.currentTitle = widget.aoiSoundsList[widget.currentIndex].title;
      });
      _onPlay();
    }
  }

  void _onMapTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(
          initialLocation: widget.location,
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
