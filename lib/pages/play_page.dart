import 'package:aoku/models/aoi_sound.dart';
import 'package:aoku/pages/map_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 12.0,
                                  ),
                                  child: Text(
                                    widget.currentTitle,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const IconButton(
                                    icon: Icon(
                                      CupertinoIcons.heart_fill,
                                      color: Colors.pink,
                                    ),
                                    onPressed: null,
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      CupertinoIcons.map_fill,
                                      color: Colors.white,
                                    ),
                                    onPressed: _onMapTapped,
                                  ),
                                  GestureDetector(
                                    onTap: _onMapTapped,
                                    child: Text(
                                      '${widget.city}, ${widget.province}',
                                      style:
                                          const TextStyle(color: Colors.white),
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
                        // Seek bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed:
                                  widget.currentIndex == 0 ? null : _onPrevious,
                              icon: const Icon(
                                CupertinoIcons.backward_fill,
                                color: Colors.white,
                              ),
                              //icon: Image.asset('images/prev-arrow.png'),
                            ),
                            !_isPlaying
                                ? IconButton(
                                    onPressed: () {
                                      _onPlay();
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.play_arrow_solid,
                                      color: Colors.white,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      _onPause();
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.pause_solid,
                                      color: Colors.white,
                                    ),
                                  ),
                            IconButton(
                              onPressed: widget.currentIndex ==
                                      widget.aoiSoundsList.length - 1
                                  ? null
                                  : _onNext,
                              icon: const Icon(
                                CupertinoIcons.forward_fill,
                                color: Colors.white,
                              ),
                              //icon: Image.asset('images/prev-arrow.png'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
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
}
