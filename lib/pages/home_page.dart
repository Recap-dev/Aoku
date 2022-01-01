// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// 🌎 Project imports:
import 'package:aoku/components/error_dialog.dart';
import 'package:aoku/components/profile_button.dart';
import 'package:aoku/components/upload_button.dart';
import 'package:aoku/tabs/home_tab.dart';
import 'package:aoku/tabs/settings_tab.dart';

// 📦 Package imports:

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
  late StreamSubscription<ConnectivityResult> _connectivitySub;
  late StreamSubscription<BatteryState> _batterySub;

  @override
  void initState() {
    super.initState();

    _connectivitySub = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        showCupertinoDialog(
          context: context,
          builder: (_) => ErrorDialog.connectionError(),
        );
      }
    });

    _batterySub = Battery().onBatteryStateChanged.listen((state) async {
      if (state == BatteryState.charging) return;

      if (await Battery().batteryLevel < 50) {
        showCupertinoDialog(
          context: context,
          builder: (_) => ErrorDialog.lowBatteryError(),
        );
      }
    });
  }

  @override
  void dispose() {
    _connectivitySub.cancel();
    _batterySub.cancel();

    super.dispose();
  }

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
              icon: Icon(CupertinoIcons.music_albums_fill),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const Align(
        alignment: Alignment(0, 0.99),
        child: UploadButton(),
      ),
    );
  }
}
