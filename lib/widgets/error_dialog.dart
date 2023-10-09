import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final VoidCallback? onConfirm;

  const ErrorDialog({
    Key? key,
    this.title,
    this.content,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: content != null ? Text(content!) : null,
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text('Okay'),
        ),
      ],
    );
  }
}
