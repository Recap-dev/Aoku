// π¦ Flutter imports:
import 'package:flutter/cupertino.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key? key,
    required this.message,
    required this.iconData,
    required this.iconColor,
  }) : super(key: key);

  factory ErrorDialog.connectionError() => const ErrorDialog(
        message: 'γ€γ³γΏγΌγγγγ«ζ₯ηΆγγγ¦γγγγ¨γη’Ίθͺγγγ’γγͺγεθ΅·εγγ¦γγ γγ',
        iconData: CupertinoIcons.clear_circled_solid,
        iconColor: CupertinoColors.destructiveRed,
      );

  factory ErrorDialog.lowBatteryError() => const ErrorDialog(
        message: 'ε°±ε―ζιγ«δ½Ώη¨γγγε ΄εγ―γει»ε¨γ«ζ₯ηΆγγγγ¨γζ¨ε₯¨γγΎγ',
        iconData: CupertinoIcons.battery_25_percent,
        iconColor: CupertinoColors.black,
      );

  final String message;
  final IconData iconData;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Icon(
        iconData,
        color: iconColor,
        size: 30,
      ),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: const Text('OK'),
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
