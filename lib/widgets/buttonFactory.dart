import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/domain/create_editing_case.dart';

class ElevatedButtonFactory extends StatelessWidget {
  const ElevatedButtonFactory.numAddItem({
    required this.onPressed,
    required this.child,
    super.key,
  });

  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: ElevatedButton(
        style: ButtonStyle(
          alignment: Alignment.center,
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[child],
        ),
      ),
    );
  }
}

class ConsumerTextButton extends ConsumerWidget {
  ConsumerTextButton.showDialog({
    this.addedItem,
    this.id,
    this.child,
    this.closeAfterClicking,
    this.onPressed,
    super.key,
  });

  void Function()? onPressed;
  final bool? closeAfterClicking;
  final String? addedItem;
  final int? id;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createEditingController =
        ref.read(createEditingCaseProvider.notifier);

    return TextButton(
      onPressed: onPressed ??
          () => {
                if (addedItem != null)
                  {
                    createEditingController.addSettings = id ?? 0,
                    createEditingController.addItem(addedItem!),
                  },

                //if the button be to a dialog box then close it
                if (closeAfterClicking ?? false)
                  {Navigator.pop(context, 'close')},
              },
      child: child ?? const Text(''),
    );
  }
}
