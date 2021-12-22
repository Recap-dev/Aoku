import 'dart:developer';
import 'dart:ui';

import 'package:aoku/models/audio_state.dart';
import 'package:aoku/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlbumArt extends ConsumerStatefulWidget {
  const AlbumArt({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlbumArtState();
}

class _AlbumArtState extends ConsumerState<AlbumArt>
    with SingleTickerProviderStateMixin {
  late final GoogleMapController _mapController;
  final Set<Marker> _markers = {};
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

  void _onMapCreated(GoogleMapController controller) {
    log('onMapCreated.');

    _mapController = controller;
    _mapController.setMapStyle(
      MapUtils.lightMapStyle,
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
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
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
                markers: _markers,
                initialCameraPosition: CameraPosition(
                  target: audioState
                      .sounds[audioState.player.currentIndex ?? 0].location,
                  zoom: 20,
                ),
                onMapCreated: _onMapCreated,
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(
                      initialLocation: audioState
                          .sounds[audioState.player.currentIndex as int]
                          .location,
                    ),
                  ),
                ),
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
      ),
    );
  }
}
