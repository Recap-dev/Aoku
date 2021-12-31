// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

// 🌎 Project imports:
import 'package:aoku/constants.dart';
import 'package:aoku/pages/upload_confirm_page.dart';

class UploadPage extends StatefulWidget {
  UploadPage({Key? key, required this.result}) : super(key: key);

  final FilePickerResult result;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  FilePickerResult? _result;
  String? _title;
  int? _length;
  Timestamp _timestamp = Timestamp.now();
  Position? _currentPosition;
  GeoPoint? _geoPoint;
  Placemark? _placemark;
  String? _province;
  String? _city;

  @override
  void initState() {
    super.initState();
    _result = widget.result;
    _onInitState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.homeScaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoFormSection.insetGrouped(
              backgroundColor: Colors.transparent,
              children: [
                CupertinoTextField(
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 60,
                      child: const Text('タイトル'),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  clearButtonMode: OverlayVisibilityMode.editing,
                  autofocus: true,
                  onChanged: (String? value) => setState(
                    () => _title = value,
                  ),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 60,
                      child: const Text('長さ（秒）'),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  clearButtonMode: OverlayVisibilityMode.editing,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(
                    () => _length = int.tryParse(value),
                  ),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 60,
                      child: const Text('場所'),
                    ),
                  ),
                  readOnly: true,
                  padding: const EdgeInsets.all(16),
                  placeholder: '${_city ?? '読み込み中…'} ${_province ?? ''}',
                  suffix: const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      CupertinoIcons.arrow_right_circle_fill,
                    ),
                  ),
                  onTap: () async {
                    void onError(PlacesAutocompleteResponse response) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(response.errorMessage ?? 'Unknown error'),
                        ),
                      );
                    }

                    final p = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: kGoogleMapsApiKey,
                      onError: onError,
                      mode: Mode.overlay,
                      language: 'ja',
                      components: [Component(Component.country, 'jp')],
                    );

                    await _updateLocation(p);
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime value) => setState(
                      () => _timestamp = Timestamp.fromDate(value),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CupertinoButton.filled(
        child: const Icon(CupertinoIcons.arrow_right),
        onPressed: _title != null && _length != null && _geoPoint != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UploadConfirmPage(
                      filePickerResult: _result,
                      geoPoint: _geoPoint,
                      title: _title,
                      length: _length,
                      city: _city,
                      province: _province,
                      timestamp: _timestamp,
                    ),
                  ),
                );
              }
            : null,
      ),
    );
  }

  Future<void> _onInitState() async {
    _currentPosition = await Geolocator.getCurrentPosition();
    List<Placemark> _placemarks = await placemarkFromCoordinates(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      localeIdentifier: 'en_US',
    );
    _placemark = _placemarks.first;

    setState(() {
      _currentPosition = _currentPosition;
      _geoPoint = GeoPoint(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      _city = _placemark!.locality;
      _province = _placemark!.administrativeArea;
    });
  }

  Future<void> _updateLocation(Prediction? p) async {
    if (p == null) {
      return;
    }

    // get detail (lat/lng)
    final _places = GoogleMapsPlaces(
      apiKey: kGoogleMapsApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    final detail = await _places.getDetailsByPlaceId(p.placeId!);
    final geometry = detail.result.geometry!;
    final lat = geometry.location.lat;
    final lng = geometry.location.lng;

    List<Placemark> _placemarks = await placemarkFromCoordinates(
      lat,
      lng,
      localeIdentifier: 'en_US',
    );
    _placemark = _placemarks.first;

    setState(() {
      _geoPoint = GeoPoint(lat, lng);
      _city = _placemark!.locality;
      _province = _placemark!.administrativeArea;
    });
  }
}
