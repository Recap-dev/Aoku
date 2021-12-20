import 'dart:developer';
import 'dart:ui';

import 'package:aoku/models/audio_state.dart';
import 'package:aoku/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlbumArt extends HookConsumerWidget {
  AlbumArt({
    Key? key,
  }) : super(key: key);

  late final GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    log('onMapCreated.');
    _mapController = controller;

    _mapController.setMapStyle(
      MapUtils.lightMapStyle,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          //child: Text(
          //  audioState.sounds[audioState.player.currentIndex ?? 0].title,
          //),
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
                child: Container(
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
