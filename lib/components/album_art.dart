// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:aoku/models/audio_state.dart';
import 'package:aoku/pages/map_page.dart';

/// Will be accessed by AudioState when stream changes
GoogleMapController? smallMapController;

class AlbumArt extends ConsumerStatefulWidget {
  const AlbumArt({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlbumArtState();
}

class _AlbumArtState extends ConsumerState<AlbumArt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(audioProvider);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _animation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);
    _controller.forward();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    smallMapController = controller;
    await smallMapController!.setMapStyle(
      Theme.of(context).brightness == Brightness.dark
          ? MapUtils.darkMapStyle
          : MapUtils.lightMapStyle,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AudioState audioState = ref.watch(audioProvider);

    return ClipRRect(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onBackground,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: audioState.sounds[audioState.currentIndex].location,
                zoom: 8,
              ),
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
            ),
            GestureDetector(
              onTap: () async {
                var page = await buildPageAsync(
                  audioState.sounds[audioState.currentIndex].location,
                );
                var route = MaterialPageRoute(builder: (_) => page);
                Navigator.push(
                  context,
                  route,
                );
              },
              child: FadeTransition(
                opacity: _animation,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color(0xFFFFFFFF),
                  child: const Center(
                    child: Text('Loading...'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> buildPageAsync(LatLng initialLoaction) async =>
      Future.microtask(() => MapPage(initialLocation: initialLoaction));
}
