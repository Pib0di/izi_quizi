import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/Factory%D0%A1lasses/SideSlides.dart';

import '../FactoryСlasses/SlideData.dart';
import '../main.dart';

class ButtonDelete extends ConsumerWidget {
  ButtonDelete.deleteItemId(this.deleteItemKey, {super.key});
  Key deleteItemKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StateController<int> _numAddItem = ref.watch(numAddItem.notifier);
    StateController<int> _ItemId = ref.watch(ItemId.notifier);

    StateController<Key> _deleteItemKey = ref.watch(delItemId.notifier);

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
            print("deleteItemKey => ${deleteItemKey}");
            SlideData slideData = SlideData();
            print("sideSlides.length => ${sideSlides.getLengthSideList()}, slideData.length => ${slideData.getLengthListSlide()}");
            _deleteItemKey.state = deleteItemKey;
            _numAddItem.state = -100;
            _numAddItem.state = -10;
          },
          child: const Icon(Icons.delete, size: 20,),
        ),
      ),
    );
  }
}
