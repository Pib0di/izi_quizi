
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/domain/creating_editing_presentation/create_editing_case.dart';
import 'package:izi_quizi/presentation/riverpod/creating_editing_presentation/create_editing_state.dart';

import '../../main.dart';

class CreateEditingImpl extends CreateEditingCase{
  static final CreateEditingImpl _instance = CreateEditingImpl._internal();
  factory CreateEditingImpl() { return _instance; }
  CreateEditingImpl._internal();

  WidgetRef? ref;
  void getRef(WidgetRef ref){
    this.ref = ref;
  }
  void itemNum(int itemNum){
    ref!.watch(numAddItem.notifier).set(-1);
    ref!.watch(numAddItem.notifier).set(itemNum);
  }

  @override
  void renameQuiz(String email, String currentNamePresent, String newName) {
    request.renamePresent(email, currentNamePresent, newName);
  }

  @override
  void saveQuiz(String idUser, String presentName, String jsonSlide) {
    request.setPresentation(idUser, presentName, jsonSlide);
  }

  @override
  void addItem(String nameItem) {
    switch(nameItem){
      case 'heading':{
        itemNum(1);
        break;
      }
      case 'mainText':{
        itemNum(2);
        break;
      }
      case 'list':{
        itemNum(3);
        break;
      }
      case 'image':{
        itemNum(4);
        break;
      }
      case 'video':{
        itemNum(5);
        break;
      }
      case 'sound':{
        itemNum(6);
        break;
      }
      case 'shape':{
        itemNum(7);
        break;
      }
      case 'pointers':{
        itemNum(8);
        break;
      }
      case 'row':{
        itemNum(9);
        break;
      }
      case 'column':{
        itemNum(10);
        break;
      }
      default:{

      }
    }
  }


}