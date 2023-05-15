import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:izi_quizi/widgets/selection_slide/selection_slide_state.dart';

class ButtonDelete extends ConsumerWidget {
  const ButtonDelete.deleteItemId(this.deleteItemKey, {super.key});

  final Key deleteItemKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createEditingController = ref.read(createEditing.notifier);
    final slideDataController = ref.read(slideDataProvider.notifier);
    final deleteItemKeyController = ref.read(delItemKey.notifier);
    final currentSlideNum = ref.read(currentSlideNumber.notifier);
    final selectionSlideController = ref.read(selectionSlideProvider.notifier);
    return Positioned(
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 30,
        height: 30,
        child: RawMaterialButton(
          fillColor: Colors.redAccent,
          shape: const CircleBorder(),
          elevation: 0.0,
          onPressed: () {
            final buttonId = ref.read(currentSlideNumber.notifier);
            slideDataController
                .indexOfListSlide(buttonId.state - 1)
                .delItem(deleteItemKey);
            deleteItemKeyController.state = deleteItemKey;

            if (slideDataController.getLengthListSlide() ==
                currentSlideNum.state) {
              --currentSlideNum.state;
            }

            selectionSlideController.deleteItem(deleteItemKey);

            createEditingController.updateUi();
          },
          child: const Icon(
            Icons.delete,
            size: 20,
          ),
        ),
      ),
    );
  }
}
