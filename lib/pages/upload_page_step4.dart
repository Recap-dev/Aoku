// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

// 🌎 Project imports:
import 'package:aoku/pages/upload_confirm_page.dart';

class UploadPageStep4 extends StatefulWidget {
  const UploadPageStep4({
    Key? key,
    this.filePickerResult,
    this.geoPoint,
    this.city,
    this.province,
    this.timestamp,
  }) : super(key: key);

  final FilePickerResult? filePickerResult;
  final GeoPoint? geoPoint;
  final String? city;
  final String? province;
  final Timestamp? timestamp;

  @override
  State<UploadPageStep4> createState() => _UploadPageStep4State();
}

class _UploadPageStep4State extends State<UploadPageStep4> {
  String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: StepProgressIndicator(
          totalSteps: 5,
          currentStep: 4,
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
        child: title != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title ?? ''),
                  IconButton(
                    onPressed: () => setState(() => title = null),
                    icon: const Icon(CupertinoIcons.clear),
                  ),
                ],
              )
            : CupertinoButton.filled(
                child: const Text('タイトル'),
                onPressed: () => showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    content: CupertinoTextField(
                      placeholder: 'タイトル',
                      autofocus: true,
                      onChanged: (value) => setState(() => title = value),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('キャンセル'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CupertinoDialogAction(
                        child: const Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CupertinoButton.filled(
        child: const Text('次へ'),
        onPressed: title == null
            ? null
            : () => showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => UploadConfirmPage(
                    filePickerResult: widget.filePickerResult,
                    geoPoint: widget.geoPoint,
                    title: title,
                    city: widget.city,
                    province: widget.province,
                    timestamp: widget.timestamp,
                  ),
                ),
      ),
    );
  }
}
