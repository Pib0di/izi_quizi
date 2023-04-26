import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/domain/creating_editing_presentation/create_editing.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';

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
            const EdgeInsets.symmetric(vertical: 5),
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
  const ConsumerTextButton({
    this.addedItem,
    this.id,
    this.child,
    this.closeAfterClicking,
    super.key,
  });

  const ConsumerTextButton.showDialog({
    this.addedItem,
    this.id,
    this.child,
    this.closeAfterClicking,
    super.key,
  });

  final bool? closeAfterClicking;
  final String? addedItem;
  final int? id;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => {
        if (id != null)
          {
            ref.read(createEditing.notifier).set(id!),
          },

        if (addedItem != null)
          {
            CreateEditingCase().addItem(addedItem!),
          },

        //if the button be to a dialog box then close it
        if (closeAfterClicking ?? false) {Navigator.pop(context, 'OK')},
      },
      child: child ?? const Text(''),
    );
  }
}

Future<T?> showDialogFactory<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  final themes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).context,
  );

  return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
    DialogRoute<T>(
      context: context,
      builder: builder,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      settings: routeSettings,
      themes: themes,
      anchorPoint: anchorPoint,
    ),
  );
}
