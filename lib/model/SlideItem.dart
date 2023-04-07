import 'package:flutter/widgets.dart' show BuildContext, Key, Stack, Widget;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import '../Screen/SingleView/ViewPresentation.dart';
import 'ItemsShel.dart';

class SlideItems extends ConsumerWidget {
  SlideItems({super.key});

  final List<ItemsShel> listItems = [];
  final List<ItemsViewPresentation> listItemsView = [];

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

  void addItemsView(ItemsViewPresentation itemsView){
    listItemsView.add(itemsView);
  }

  void delItem(Key delItemId){
    // int i = 0;
    // for (var item in listItems) {
    //   if (item.key != delItemId){
    //     listItems.removeAt(i);
    //   }
    //   ++i;
    // }
    listItems.retainWhere((item) => item.key != delItemId);
    // listItems.retainWhere((item) => (item.key != delItemId));
  }

  Stack getSlide(){
    // return data.getSlide();
    return Stack(
      children: listItems,
    );
  }
  Stack getSlideView(){
    // return data.getSlide();
    return Stack(
      children: listItemsView,
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