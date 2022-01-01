// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:file_picker/file_picker.dart';

// 🌎 Project imports:
import 'package:aoku/components/profile_button.dart';
import 'package:aoku/pages/upload_page.dart';
import 'package:aoku/tabs/home_tab.dart';
import 'package:aoku/tabs/settings_tab.dart';

// 📦 Package imports:

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _tabList = [
    HomeTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: ProfileButton(),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: _tabList[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 84,
        child: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          activeColor: Theme.of(context).colorScheme.onBackground,
          inactiveColor:
              Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
          iconSize: 28,
          onTap: (value) => setState(() => _selectedIndex = value),
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.music_albums_fill,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.settings,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Align(
        alignment: const Alignment(0, 0.99),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: const Icon(CupertinoIcons.up_arrow),
          onPressed: () async {
            FilePickerResult? tmpResult = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.custom,
              allowedExtensions: ['m4a'],
            );

            if (tmpResult != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadPage(result: tmpResult),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
