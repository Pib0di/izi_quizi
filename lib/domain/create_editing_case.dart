import 'dart:io' as file;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';
import 'package:izi_quizi/widgets/item_shel/items_shel.dart';
import 'package:universal_html/html.dart';

void renameQuiz(String email, String currentNamePresent, String newName) {
  renamePresent(email, currentNamePresent, newName);
}

void saveQuiz(
    int idPresent, String idUser, String presentName, String jsonSlide) {
  setPresentation(idPresent, idUser, presentName, jsonSlide);
}

final createEditingCaseProvider =
    StateNotifierProvider<CreateEditingCase, int>((ref) {
  return CreateEditingCase(ref);
});

class CreateEditingCase extends StateNotifier<int> {
  CreateEditingCase(this.ref) : super(0);

  Ref ref;

  final urlTextController = TextEditingController();
  int addSettings = 0;

  void itemNum(int itemNum) {}

  void addItem(String nameItem) {
    final createEditingController = ref.read(createEditing.notifier);
    final slideDataController = ref.read(slideDataProvider.notifier);
    final currentSlideNum = ref.read(currentSlideNumber);

    switch (nameItem) {
      case 'heading':
        {
          slideDataController.indexOfListSlide(currentSlideNum - 1).addItemShel(
                ItemsShel.id(
                  UniqueKey(),
                  slideDataController
                      .indexOfListSlide(currentSlideNum - 1)
                      .lengthArr(),
                ),
              );
          createEditingController.updateUi();
          break;
        }
      case 'mainText':
        {
          itemNum(2);
          break;
        }
      case 'list':
        {
          itemNum(3);
          break;
        }
      case 'image':
        {
          final slideNum = ref.read(currentSlideNumber.notifier).state - 1;
          final isMobileDevice =
              ref.read(appDataProvider.notifier).isMobileDevice;

          if (addSettings == -4) {
            final imageBox = ItemsShel.imageWidgetJson(
              key: UniqueKey(),
              url: urlTextController.text,
            );

            ref
                .read(slideDataProvider.notifier)
                .indexOfListSlide(slideNum)
                .addItemShel(imageBox);
            ref.read(createEditing.notifier).updateUi();
            break;
          }

          if (isMobileDevice) {
            pickFileWeb(slideNum, ref);
          } else {
            pickFilePC(slideNum, ref);
          }
          break;
        }
      case 'video':
        {
          itemNum(5);
          break;
        }
      case 'sound':
        {
          itemNum(6);
          break;
        }
      case 'shape':
        {
          itemNum(7);
          break;
        }
      case 'pointers':
        {
          itemNum(8);
          break;
        }
      case 'row':
        {
          itemNum(9);
          break;
        }
      case 'column':
        {
          itemNum(10);
          break;
        }
      default:
        {}
    }
  }
}

Future<void> pickFileWeb(int slideNum, Ref ref) async {
  Uint8List? imageData;

  final input = FileUploadInputElement()..click();
  input.onChange.listen((event) {
    final file = input.files!.first;
    final reader = FileReader()..readAsArrayBuffer(file);

    reader.onLoad.listen((event) {
      imageData = reader.result as Uint8List;
      final imageWidget = Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(imageData!),
            fit: BoxFit.cover,
          ),
        ),
      );
      final imageBox = ItemsShel.imageWidget(UniqueKey(), imageWidget);

      ref
          .read(slideDataProvider.notifier)
          .indexOfListSlide(slideNum)
          .addItemShel(imageBox);
      ref.read(createEditing.notifier).updateUi();
    });
  });
}

Future<void> pickFilePC(int slideNum, Ref ref) async {
  final result = await FilePicker.platform.pickFiles(
    dialogTitle: "Выберите изображение или gif",
    type: FileType.image,
    // allowedExtensions: ['jpg','gif','jpeg'],
  );

  if (result != null) {
    final imageFile = file.File(result.files.single.path!);

    print(result.files.single.path!);
    final imageWidget = Container(
      // margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.file(imageFile).image,
          fit: BoxFit.cover,
        ),
      ),
    );

    final imageBox = ItemsShel.imageWidget(UniqueKey(), imageWidget);

    ref
        .read(slideDataProvider.notifier)
        .indexOfListSlide(slideNum)
        .addItemShel(imageBox);
  } else {
    // User canceled the picker
  }

  ref.read(createEditing.notifier).updateUi();
}
