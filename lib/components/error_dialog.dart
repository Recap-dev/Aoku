// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key? key,
    required this.message,
    required this.iconData,
    required this.iconColor,
  }) : super(key: key);

  factory ErrorDialog.connectionError() => const ErrorDialog(
        message: 'インターネットに接続されていることを確認し、アプリを再起動してください',
        iconData: CupertinoIcons.clear_circled_solid,
        iconColor: CupertinoColors.destructiveRed,
      );

  factory ErrorDialog.lowBatteryError() => const ErrorDialog(
        message: '就寝時間に使用される場合は、充電器に接続することを推奨します',
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
