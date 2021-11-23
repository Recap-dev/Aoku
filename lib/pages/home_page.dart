import 'package:aoku/models/aoi_sound.dart';
import 'package:aoku/pages/play_page.dart';
import 'package:flutter/material.dart';

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
        latitude: 00,
        longitude: 00,
      ),
      AoiSound(
        title: '古民家カフェの仕込み作業',
        fileName: 'kominka_cafe.m4a',
        latitude: 00,
        longitude: 00,
      ),
      AoiSound(
        title: '足助町シェアハウスのベランダの雨',
        fileName: 'kura_no_naka.m4a',
        latitude: 00,
        longitude: 00,
      ),
      AoiSound(
        title: 'シェアハウスリビングのリモートワーク作業音',
        fileName: 'share_house.m4a',
        latitude: 00,
        longitude: 00,
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
                itemBuilder: (context, selectedIndex) {
                  String title = _aoiSoundsList[selectedIndex].title;
                  String fileName = _aoiSoundsList[selectedIndex].fileName;

                  return buildAoiSoundListTile(
                    title,
                    context,
                    fileName,
                    _aoiSoundsList,
                    selectedIndex,
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
    String title,
    BuildContext context,
    String fileName,
    List<AoiSound> _aoiSoundsList,
    int selectedIndex,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        child: Center(
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset('images/play-btn.png'),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayPage(
                    currentTitle: title,
                    currentFileName: fileName,
                    aoiSoundsList: _aoiSoundsList,
                    currentIndex: selectedIndex,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
