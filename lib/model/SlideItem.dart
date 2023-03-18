import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ItemsShel.dart';

class SlideItems extends ConsumerWidget {
  SlideItems();

  List<ItemsShel> listItems = [];
  // Data data = Data();

  int lengthArr(){
    return listItems.length;
    // return data.getLengthListItems();
  }

  List<ItemsShel> getListItems(){
    return listItems;
  }

  // void addItem(ItemsShel item){
  //   listItems.add(item);
  // }

  void addItemShel(ItemsShel itemShel){
    listItems.add(itemShel);
  }

  void delItem(Key delItemId){
    listItems.retainWhere((item) => item.key != delItemId);
  }

  Stack getSlide(){
    // return data.getSlide();
    return Stack(
      children: listItems,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: listItems,
      // children: data.getListItems(),
    );
  }
}