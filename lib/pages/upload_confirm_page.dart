// π― Dart imports:
import 'dart:developer';
import 'dart:io';

// π¦ Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// π¦ Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class UploadConfirmPage extends StatefulWidget {
  const UploadConfirmPage({
    Key? key,
    required this.filePickerResult,
    required this.geoPoint,
    required this.title,
    required this.length,
    required this.city,
    required this.province,
    required this.timestamp,
  }) : super(key: key);

  final FilePickerResult? filePickerResult;
  final GeoPoint? geoPoint;
  final String? title;
  final int? length;
  final String? city;
  final String? province;
  final Timestamp? timestamp;

  @override
  State<UploadConfirmPage> createState() => _UploadConfirmPageState();
}

class _UploadConfirmPageState extends State<UploadConfirmPage> {
  FilePickerResult? _filePickerResult;
  GeoPoint? _geoPoint;
  String? _title;
  int? _lengthInSeconds;
  String? _city;
  String? _province;
  Timestamp? _timestamp;

  double uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _filePickerResult = widget.filePickerResult;
    _geoPoint = widget.geoPoint;
    _title = widget.title;
    _lengthInSeconds = widget.length;
    _city = widget.city;
    _province = widget.province;
    _timestamp = widget.timestamp;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('γ’γγγ­γΌγγδΈ­ζ­’γγΎγγοΌ'),
          actions: [
            CupertinoDialogAction(
              child: const Text('γ­γ£γ³γ»γ«'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ) as Future<bool>,
      child: Scaffold(
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            SizedBox(
              height: 150,
              width: 150,
              child: LiquidCircularProgressIndicator(
                value: uploadProgress / 100,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.surface,
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                borderColor: Theme.of(context).colorScheme.primary,
                borderWidth: 0.3,
                direction: Axis.vertical,
                center: Text(
                  uploadProgress == 0.0 ? 'Waiting...' : '$uploadProgress%',
                ),
              ),
            ),
            const SizedBox(height: 80.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56.0),
              child: Table(
                children: [
                  TableRow(
                    children: [
                      const Text(
                        'γΏγ€γγ«',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        _title ?? '',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text(
                        'ε ΄ζ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '$_city, $_province',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text(
                        'ζε»',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '${_timestamp!.toDate().hour.toString()}:${_timestamp!.toDate().minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CupertinoButton.filled(
          child: const Text('γ’γγγ­γΌγ'),
          onPressed: () async {
            await _upload(_filePickerResult!);
            await _updateSoundInfo(_filePickerResult!.files.single.name);

            Navigator.popUntil(
              context,
              (route) => route.isFirst,
            );
          },
        ),
      ),
    );
  }

  Future<void> _upload(FilePickerResult filePickerResult) async {
    UploadTask task;
    File file = File(filePickerResult.files.single.path as String);
    String fileName = filePickerResult.files.single.name;

    try {
      // Check if file is not empty
      // https://stackoverflow.com/a/62845903/13676510
      if (!file.existsSync()) {
        log('file doesn\'t exist. Creating a new one...');
        file = await file.create();
        log('Created.');
      }

      task = FirebaseStorage.instance.ref('sounds/$fileName').putFile(file);

      task.snapshotEvents.listen((event) {
        setState(() => uploadProgress = ((event.bytesTransferred.toDouble() /
                event.totalBytes.toDouble() *
                100)
            .roundToDouble()));
      });
    } on FirebaseException catch (e) {
      log('Error uploading a file: ${e.message}');
    }
  }

  Future<void> _updateSoundInfo(String fileName) async {
    try {
      await FirebaseFirestore.instance.doc('sounds/$fileName').set(
        {
          'fileName': fileName,
          'lengthInSeconds': _lengthInSeconds,
          'title': _title,
          'timestamp': _timestamp,
          'city': _city,
          'province': _province,
          'location': _geoPoint,
        },
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      log('Error updating a file: ${e.message}');
    }
  }
}
