// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:file_picker/file_picker.dart';

// 🌎 Project imports:
import 'package:aoku/pages/upload_page.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: const Icon(CupertinoIcons.up_arrow),
      onPressed: () async {
        FilePickerResult? tmpResult = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['m4a'],
        );

        if (tmpResult != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadPage(result: tmpResult),
            ),
          );
        }
      },
    );
  }
}
