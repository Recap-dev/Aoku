// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

// 🌎 Project imports:
import 'package:aoku/pages/upload_page_step3.dart';

class UploadPageStep2 extends StatefulWidget {
  const UploadPageStep2({
    Key? key,
    required this.filePickerResult,
  }) : super(key: key);

  final FilePickerResult? filePickerResult;

  @override
  State<UploadPageStep2> createState() => _UploadPageStep2State();
}

class _UploadPageStep2State extends State<UploadPageStep2> {
  GeoPoint? geoPoint;
  String? province;
  String? city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: StepProgressIndicator(
          totalSteps: 5,
          currentStep: 2,
          size: 10,
          padding: 0,
          selectedColor: Theme.of(context).colorScheme.surface,
          unselectedColor: Colors.grey.shade300,
          roundedEdges: const Radius.circular(4),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Center(
        child: city != null || province != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${city ?? ''}, ${province ?? ''}'),
                  IconButton(
                    onPressed: () => setState(() {
                      city = null;
                      province = null;
                    }),
                    icon: const Icon(CupertinoIcons.clear),
                  ),
                ],
              )
            : CupertinoButton.filled(
                child: const Text('場所'),
                onPressed: _showMapPicker,
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CupertinoButton.filled(
        child: const Text('次へ'),
        onPressed: geoPoint == null || city == null || province == null
            ? null
            : () => showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => UploadPageStep3(
                      filePickerResult: widget.filePickerResult,
                      geoPoint: geoPoint,
                      city: city,
                      province: province),
                ),
      ),
    );
  }

  Future<void> _showMapPicker() async {
    final _controller = Completer<GoogleMapController>();
    MapPickerController mapPickerController = MapPickerController();
    CameraPosition cameraPosition = const CameraPosition(
      target: LatLng(35.652832, 139.839478),
      zoom: 13,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            extendBodyBehindAppBar: true,
            body: MapPicker(
              showDot: false,
              iconWidget: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(75),
                    ),
                  ),
                  const Icon(CupertinoIcons.placemark_fill),
                ],
              ),
              mapPickerController: mapPickerController,
              child: Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: cameraPosition,
                    onMapCreated: (controller) =>
                        _controller.complete(controller),
                    onCameraMoveStarted: () => mapPickerController.mapMoving!(),
                    onCameraMove: (position) => cameraPosition = position,
                    onCameraIdle: () async {
                      mapPickerController.mapFinishedMoving!();
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                        cameraPosition.target.latitude,
                        cameraPosition.target.longitude,
                        localeIdentifier: 'en_US',
                      );

                      setState(() {
                        city = placemarks.first.locality;
                        province = placemarks.first.administrativeArea;
                        geoPoint = GeoPoint(
                          cameraPosition.target.latitude,
                          cameraPosition.target.longitude,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: CupertinoButton.filled(
              child: const Text('決定'),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    );
  }
}
