import 'package:aoku/pages/upload_page_step4.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class UploadPageStep3 extends StatefulWidget {
  const UploadPageStep3({
    Key? key,
    required this.filePickerResult,
    required this.geoPoint,
    required this.city,
    required this.province,
  }) : super(key: key);

  final FilePickerResult? filePickerResult;
  final GeoPoint? geoPoint;
  final String? city;
  final String? province;

  @override
  State<UploadPageStep3> createState() => _UploadPageStep3State();
}

class _UploadPageStep3State extends State<UploadPageStep3> {
  Timestamp? timestamp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: StepProgressIndicator(
          totalSteps: 5,
          currentStep: 3,
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
        child: SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            initialDateTime: DateTime.now(),
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (time) {
              HapticFeedback.selectionClick();
              setState(() => timestamp = Timestamp.fromDate(time));
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CupertinoButton.filled(
        child: const Text('次へ'),
        onPressed: timestamp == null
            ? null
            : () => showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => UploadPageStep4(
                    filePickerResult: widget.filePickerResult,
                    geoPoint: widget.geoPoint,
                    timestamp: timestamp,
                    city: widget.city,
                    province: widget.province,
                  ),
                ),
      ),
    );
  }
}
