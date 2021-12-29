import 'package:aoku/pages/upload_page_step2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class UploadPageStep1 extends StatefulWidget {
  const UploadPageStep1({Key? key}) : super(key: key);

  @override
  State<UploadPageStep1> createState() => _UploadPageStep1State();
}

class _UploadPageStep1State extends State<UploadPageStep1> {
  FilePickerResult? filePickerResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: StepProgressIndicator(
          totalSteps: 5,
          currentStep: 1,
          size: 10,
          padding: 0,
          selectedColor: Theme.of(context).colorScheme.background,
          unselectedColor: Colors.grey.shade300,
          roundedEdges: const Radius.circular(4),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoFormSection.insetGrouped(
                backgroundColor: Colors.transparent,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: filePickerResult != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(filePickerResult!.files.single.name),
                              IconButton(
                                onPressed: () =>
                                    setState(() => filePickerResult = null),
                                icon: const Icon(CupertinoIcons.clear),
                              ),
                            ],
                          )
                        : CupertinoButton.filled(
                            child: const Text('ファイル'),
                            onPressed: () async {
                              FilePickerResult? tmpResult =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['m4a'],
                              );

                              setState(() => filePickerResult = tmpResult);
                            },
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CupertinoButton.filled(
        child: const Text('次へ'),
        onPressed: filePickerResult == null
            ? null
            : () => showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => UploadPageStep2(
                    filePickerResult: filePickerResult,
                  ),
                ),
      ),
    );
  }
}
