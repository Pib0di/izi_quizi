import 'package:flutter/material.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/main.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/creating_editing_screen.dart';
import 'package:izi_quizi/presentation/multipe_view/multiple_view_screen.dart';
import 'package:izi_quizi/presentation/single_view/single_view_screen.dart';

class PresentationDialog<T> extends PopupRoute<T> {
  PresentationDialog({
    required this.idPresent,
    required this.presentName,
    Key? key,
  });

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
  SlideData slideData = SlideData();

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Center(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        // UnconstrainedBox is used to make the dialog size itself
        // to fit to the size of the content.
        child: UnconstrainedBox(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                // Text('Presentation Dialog', style: Theme.of(context).textTheme.headlineSmall),
                ElevatedButton(
                  onPressed: () {
                    // request.getSlideData(idPresent, presentName); //Т.К ДАННЫЕ УЖЕ ЗАПРОШЕНЫ ПРИ НАЖАТИИ
                    slideData.setItemsView();
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
                      Icon(Icons.person, color: Colors.green),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    request.createRoom(AppDataState.idUser, presentName);
                    slideData.setItemsView();
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
                      Icon(Icons.group, color: Colors.green),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    slideData.setItemsEdit();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PresentationEdit.edit(presentName),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text('Редактировать'),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.edit, color: Colors.green),
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
