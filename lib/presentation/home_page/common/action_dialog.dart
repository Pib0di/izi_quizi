import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/creating_editing_screen.dart';
import 'package:izi_quizi/presentation/multiple_view/multiple_view_screen.dart';
import 'package:izi_quizi/presentation/single_view/single_view_screen.dart';

///A presentation dialog box that allows you to select an action (single viewing, multiple viewing, editing)
class PresentationDialog<T> extends PopupRoute<T> {
  PresentationDialog({
    required this.idPresent,
    required this.presentName,
    required this.ref,
    Key? key,
  });

  final Ref ref;
  final int idPresent;
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
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Text('Presentation Dialog', style: Theme.of(context).textTheme.headlineSmall),
                ElevatedButton(
                  onPressed: () {
                    // request.getSlideData(idPresent, presentName); //Т.К ДАННЫЕ УЖЕ ЗАПРОШЕНЫ ПРИ НАЖАТИИ
                    // slideDataController.setItemsView();
                    slideDataController
                      ..clear()
                      ..setSlidesSingleView();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SingleViewPresentation(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text('Просмотреть'),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.person),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    createRoom(appDataController.idUser, presentName);
                    // slideDataController.setItemsView();
                    slideDataController
                      ..clear()
                      ..setSlidesSingleView();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MultipleView(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text('Начать сессию'),
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
                ElevatedButton(
                  onPressed: () {
                    // slideDataController.setItemsEdit();
                    slideDataController
                      ..clear()
                      ..setSlidesEdit();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PresentationEdit.edit(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text('Редактировать'),
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
