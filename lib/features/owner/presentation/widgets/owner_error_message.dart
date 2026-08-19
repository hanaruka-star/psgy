import 'package:flutter/material.dart';

class OwnerErrorMessage extends StatelessWidget {
  final String message;
  final bool centered;

  const OwnerErrorMessage({
    super.key,
    required this.message,
    this.centered = true,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      message.replaceFirst('Exception: ', ''),
      textAlign: centered ? TextAlign.center : TextAlign.start,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    );

    if (!centered) {
      return text;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: text,
      ),
    );
  }
}
