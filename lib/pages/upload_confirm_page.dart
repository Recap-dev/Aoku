// 🎯 Dart imports:
import 'dart:developer';
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class UploadConfirmPage extends StatefulWidget {
  const UploadConfirmPage({
    Key? key,
    required this.filePickerResult,
    required this.geoPoint,
    required this.title,
    required this.city,
    required this.province,
    required this.timestamp,
  }) : super(key: key);

  final FilePickerResult? filePickerResult;
  final GeoPoint? geoPoint;
  final String? title;
  final String? city;
  final String? province;
  final Timestamp? timestamp;

  @override
  State<UploadConfirmPage> createState() => _UploadConfirmPageState();
}

class _UploadConfirmPageState extends State<UploadConfirmPage> {
  // 0.0 ~ 100.0
  double uploadProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: StepProgressIndicator(
          totalSteps: 5,
          currentStep: 5,
          size: 10,
          padding: 0,
          selectedColor: Theme.of(context).colorScheme.surface,
          unselectedColor: Colors.grey.shade300,
          roundedEdges: const Radius.circular(4),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          const SizedBox(height: 56.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56.0),
            child: Table(
              children: [
                TableRow(
                  children: [
                    const Text(
                      'タイトル',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.title ?? '',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      '場所',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${widget.city}, ${widget.province}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      '時刻',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${widget.timestamp!.toDate().hour.toString()}:${widget.timestamp!.toDate().minute.toString()}',
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
        child: const Text('アップロード'),
        onPressed: () async {
          Future.wait([
            _upload(widget.filePickerResult!),
            _updateSoundInfo(widget.filePickerResult!.files.single.name),
          ]);

          Navigator.popUntil(
            context,
            (route) => route.isFirst,
          );
        },
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
      if (file.existsSync()) {
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
          'lengthInSeconds': 0,
          'title': widget.title,
          'timestamp': widget.timestamp,
          'city': widget.city,
          'province': widget.province,
          'location': widget.geoPoint,
        },
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      log('Error updating a file: ${e.message}');
    }
  }
}
