import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/creating_editing_screen.dart';
import 'package:izi_quizi/presentation/multiple_view/multiple_view_screen.dart';
import 'package:izi_quizi/presentation/multiple_view/multiple_view_state.dart';
import 'package:izi_quizi/presentation/single_view/single_view_screen.dart';
import 'package:izi_quizi/utils/theme.dart';

///A presentation dialog box that allows you to select an action (single viewing, multiple viewing, editing)
class PresentationDialog<T> extends PopupRoute<T> {
  PresentationDialog({
    required this.idPresent,
    required this.presentName,
    required this.ref,
    this.isPublic,
    Key? key,
  });

  final bool? isPublic;
  final Ref ref;
  final String idPresent;
  final String presentName;

  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);

  // This allows the popup to be dismissed by tapping the scrim or by pressing
  // the escape key on the keyboard.
  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Presentation Dialog';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final slideDataController = ref.read(slideDataProvider.notifier);
    final appDataController = ref.read(appDataProvider.notifier);

    return Center(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: UnconstrainedBox(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  appDataController.presentName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const Divider(),
                // Text('Presentation Dialog', style: Theme.of(context).textTheme.headlineSmall),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () {
                    // request.getSlideData(idPresent, presentName); //Т.К ДАННЫЕ УЖЕ ЗАПРОШЕНЫ ПРИ НАЖАТИИ
                    // slideDataController.setItemsView();
                    slideDataController
                      ..clearPresentation()
                      ..setSlidesSingleView();
                    ref.read(multipleViewProvider.notifier).isManager = true;
                    ref.read(appDataProvider.notifier).viewingMode = true;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SingleViewPresentation(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text(
                        'Просмотреть',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.person),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  onPressed: (!(isPublic ?? true) ||
                          appDataController.isAuthorized)
                      ? () {
                    ref.read(multipleViewProvider.notifier).isHideMenu =
                              false;
                          ref.read(multipleViewProvider.notifier).isManager =
                              true;
                          createRoom(
                            appDataController.idUser,
                            idPresent.toString(),
                          );
                          // slideDataController.setItemsView();
                          appDataController.idRoom =
                              '${appDataController.idUser}-${idPresent.toString()}';
                          slideDataController
                            ..clearPresentation()
                            ..setSlidesSingleView();
                          getUserRoom(
                            appDataController.idUser,
                            '${appDataController.idUser}-${appDataController.idPresent}',
                          );
                          ref.read(appDataProvider.notifier).viewingMode = true;
                          presentationQuizReport.clear();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MultipleView(),
                            ),
                          );
                        }
                      : null,
                  child: Row(
                    children: const [
                      Text(
                        'Начать сессию',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.group,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (!(isPublic ?? true))
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPublic ?? true
                          ? colorScheme.outline
                          : colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    onPressed: !(isPublic ?? true)
                        ? () {
                            // slideDataController.setItemsEdit();
                            slideDataController
                              ..clearPresentation()
                              ..clearPresentation()
                              ..setSlidesEdit();
                            ref.read(appDataProvider.notifier).viewingMode =
                                false;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PresentationEdit.edit(),
                              ),
                            );
                          }
                        : null,
                    child: Row(
                      children: const [
                        Text(
                          'Редактировать',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.edit,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
