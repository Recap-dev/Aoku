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
    final List<AoiSound> _aoiSoundsList = [
      AoiSound(
        title: '足助町シェアハウスのベランダ',
        fileName: 'asukecho.m4a',
        location: const LatLng(35.135616330301005, 137.31655937710295),
        length: 60,
        city: 'Toyota',
        province: 'Aichi',
      ),
      AoiSound(
        title: '古民家カフェの仕込み作業',
        fileName: 'kominka_cafe.m4a',
        location: const LatLng(35.135616330301005, 137.31655937710295),
        length: 30,
        city: 'Toyota',
        province: 'Aichi',
      ),
      AoiSound(
        title: '足助町シェアハウスのベランダの雨',
        fileName: 'kura_no_naka.m4a',
        location: const LatLng(35.135616330301005, 137.31655937710295),
        length: 15,
        city: 'Toyota',
        province: 'Aichi',
      ),
      AoiSound(
        title: 'シェアハウスリビングのリモートワーク作業音',
        fileName: 'share_house.m4a',
        location: const LatLng(35.135616330301005, 137.31655937710295),
        length: 5,
        city: 'Toyota',
        province: 'Aichi',
      ),
      AoiSound(
        title: '古民家カフェの朝',
        fileName: 'shikomi.m4a',
        location: const LatLng(35.135616330301005, 137.31655937710295),
        length: 5,
        city: 'Toyota',
        province: 'Aichi',
      ),
      AoiSound(
        title: '風の強い日、足助町シェアハウスのベランダ',
        fileName: 'windy-day.m4a',
        location: const LatLng(35.135616330301005, 137.31655937710295),
        length: 5,
        city: 'Toyota',
        province: 'Aichi',
      ),
      AoiSound(
        title: '古民家カフェの夕方仕込み開始',
        fileName: 'shikomi-short.m4a',
        location: const LatLng(35.135616330301005, 137.31655937710295),
        length: 5,
        city: 'Toyota',
        province: 'Aichi',
      ),
    ];

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
                itemCount: _aoiSoundsList.length,
                itemExtent: 70,
                itemBuilder: (context, _selectedIndex) {
                  String _title = _aoiSoundsList[_selectedIndex].title;
                  String _fileName = _aoiSoundsList[_selectedIndex].fileName;
                  String _city = _aoiSoundsList[_selectedIndex].city;
                  String _province = _aoiSoundsList[_selectedIndex].province;
                  LatLng _location = _aoiSoundsList[_selectedIndex].location;

                  return buildAoiSoundListTile(
                    context,
                    _aoiSoundsList,
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
    List<AoiSound> _aoiSoundsList,
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
                  _aoiSoundsList[_selectedIndex].length.toString() + 'min',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayPage(
                        aoiSoundsList: _aoiSoundsList,
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
