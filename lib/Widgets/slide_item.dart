import 'package:flutter/widgets.dart' show BuildContext, Key, Stack, Widget;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/screen/single_view_screen.dart';
import 'items_shel.dart';

///
class SlideItems extends ConsumerWidget {
  SlideItems({super.key});

  final List<ItemsShel> listItems = [];
  final List<ItemsViewPresentation> listItemsView = [];

  int lengthArr(){
    return listItems.length;
  }

  List<ItemsShel> getListItems(){
    return listItems;
  }

  void addItemShel(ItemsShel itemShel){
    listItems.add(itemShel);
  }

  void addItemsView(ItemsViewPresentation itemsView){
    listItemsView.add(itemsView);
  }

  void delItem(Key delItemId){
    listItems.retainWhere((item) => item.key != delItemId);
  }

  Stack getSlide(){
    return Stack(
      children: listItems,
    );
  }
  Stack getSlideView(){
    return Stack(
      children: listItemsView,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: listItems,
    );
  }
}