import 'package:aoku/models/aoi_sound.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayPage extends StatefulWidget {
  PlayPage({
    Key? key,
    required this.currentTitle,
    required this.currentFileName,
    required this.aoiSoundsList,
    required this.currentIndex,
  }) : super(key: key);

  final String fileNamePrefix = 'sounds/';
  final List<AoiSound> aoiSoundsList;

  // Might be changed if next/previous is pressed
  String currentTitle;
  String currentFileName;
  int currentIndex;

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final AudioCache _audioCache =
      AudioCache(fixedPlayer: _audioPlayer, prefix: widget.fileNamePrefix);
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.release();
    _audioPlayer.dispose();
    _audioCache.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFE3E3E3),
          shadowColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              _onStop();
            },
            icon: const Icon(Icons.chevron_left_rounded),
          ),
        ),
        backgroundColor: const Color(0xFFE3E3E3),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
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
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.currentTitle),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed:
                                widget.currentIndex == 0 ? null : _onPrevious,
                            icon: const Icon(Icons.skip_previous_rounded),
                            //icon: Image.asset('images/prev-arrow.png'),
                          ),
                          !_isPlaying
                              ? IconButton(
                                  onPressed: () {
                                    _onPlay();
                                  },
                                  icon: Image.asset('images/play-btn.png'),
                                )
                              : IconButton(
                                  onPressed: () {
                                    _onPause();
                                  },
                                  icon: const Icon(Icons.pause_rounded),
                                ),
                          IconButton(
                            onPressed: widget.currentIndex ==
                                    widget.aoiSoundsList.length - 1
                                ? null
                                : _onNext,
                            icon: const Icon(Icons.skip_next_rounded),
                            //icon: Image.asset('images/prev-arrow.png'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
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
}
