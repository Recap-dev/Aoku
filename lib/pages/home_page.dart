import 'package:aoku/components/profile_button.dart';
import 'package:aoku/pages/upload_page_step1.dart';
import 'package:aoku/tabs/home_tab.dart';
import 'package:aoku/tabs/settings_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
        height: 89,
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          selectedItemColor: Theme.of(context).colorScheme.onBackground,
          unselectedItemColor:
              Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                CupertinoIcons.music_albums_fill,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(
                CupertinoIcons.settings,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Align(
        alignment: const Alignment(0, 0.96),
        child: FloatingActionButton(
          child: const Icon(CupertinoIcons.up_arrow),
          onPressed: () async {
            showCupertinoModalBottomSheet(
              context: context,
              builder: (context) => const UploadPageStep1(),
            );
          },
        ),
      ),
    );
  }
}
