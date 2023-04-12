import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/side_slides.dart';

import '../data/repository/local/slide_data.dart';
import '../main.dart';
import '../presentation/riverpod/creating_editing_presentation/create_editing_state.dart';

class ButtonDelete extends ConsumerWidget {
  ButtonDelete.deleteItemId(this.deleteItemKey, {super.key});
  Key deleteItemKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numAddItemState = ref.watch(numAddItem.notifier);

    StateController<Key> deleteItemKeyState = ref.watch(delItemId.notifier);

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
            // sideSlides.updateCount();
            print("deleteItemKey => $deleteItemKey");
            SlideData slideData = SlideData();
            print("sideSlides.length => ${sideSlides.getLengthSideList()}, slideData.length => ${slideData.getLengthListSlide()}");
            deleteItemKeyState.state = deleteItemKey;
            numAddItemState.set(-101);
            numAddItemState.set(-10);
          },
          child: const Icon(Icons.delete, size: 20,),
        ),
      ),
    );
  }
}

class ProgectName extends StatelessWidget {
  ProgectName(TextEditingController? controll) : myController = controll;
  TextEditingController? myController;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: TextFormField(
        controller: myController,
        restorationId: 'life_story_field',
        textInputAction: TextInputAction.next,
        // focusNode: _lifeStory,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Проективная геометрия 2-3 неделя",
          // helperText: "название вашего iziQuizi",
          labelText: "Имя проекта",
        ),
        maxLines: 1,
      ),
    );
  }
}