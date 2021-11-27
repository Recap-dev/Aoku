import 'dart:ui';

import 'package:aoku/models/aoi_sound.dart';
import 'package:aoku/pages/play_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<AoiSound> _aoiSounds = aoiSounds;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFFE3E3E3),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFE3E3E3),
      body: Stack(
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
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _aoiSounds.length,
                itemExtent: 70,
                itemBuilder: (context, _selectedIndex) {
                  String _title = _aoiSounds[_selectedIndex].title;
                  String _fileName = _aoiSounds[_selectedIndex].fileName;
                  String _city = _aoiSounds[_selectedIndex].city;
                  String _province = _aoiSounds[_selectedIndex].province;
                  LatLng _location = _aoiSounds[_selectedIndex].location;

                  return buildAoiSoundListTile(
                    context,
                    _aoiSounds,
                    _selectedIndex,
                    _title,
                    _fileName,
                    _city,
                    _province,
                    _location,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildAoiSoundListTile(
    BuildContext context,
    List<AoiSound> _aoiSounds,
    int _selectedIndex,
    String _title,
    String _fileName,
    String city,
    String _province,
    LatLng _location,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              child: ListTile(
                title: Text(
                  _title,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: Text(
                  _aoiSounds[_selectedIndex].length.toString() + 'min',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayPage(
                        aoiSounds: _aoiSounds,
                        currentIndex: _selectedIndex,
                        currentTitle: _title,
                        currentFileName: _fileName,
                        city: city,
                        province: _province,
                        location: _location,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
