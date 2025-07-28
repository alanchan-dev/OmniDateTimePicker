import 'package:flutter/material.dart';

typedef ButtonRowBuilder = List<Widget> Function(
  void Function() onCancelPressed,
  String cancelText,
  void Function()? onSavePressed,
  String saveText,
);

class ButtonRow extends StatelessWidget {
  const ButtonRow({
    super.key,
    required this.onCancelPressed,
    required this.onSavePressed,
    this.actionsBuilder,
  });

  final void Function() onCancelPressed;
  final void Function()? onSavePressed;

  final ButtonRowBuilder? actionsBuilder;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actionsBuilder?.call(
            onCancelPressed,
            localizations.cancelButtonLabel,
            onSavePressed,
            localizations.okButtonLabel,
          ) ??
          [
            Expanded(
              child: TextButton(
                onPressed: onCancelPressed,
                child: Text(
                  localizations.cancelButtonLabel,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
              child: VerticalDivider(),
            ),
            Expanded(
              child: TextButton(
                onPressed: onSavePressed,
                child: Text(
                  localizations.okButtonLabel,
                ),
              ),
            ),
          ],
    );
  }
}
