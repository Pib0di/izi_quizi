import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/data/repository/local/slide_data.dart';
import 'package:izi_quizi/data/repository/server/server_data.dart';
import 'package:izi_quizi/presentation/home_page/common/action_dialog.dart';

class PresentCard extends ConsumerStatefulWidget {
  const PresentCard({
    required this.idPresent,
    required this.presentName,
    super.key,
  });

  final int idPresent;
  final String presentName;

  @override
  PresentCardState createState() => PresentCardState();
}

class PresentCardState extends ConsumerState<PresentCard> {
  @override
  Widget build(BuildContext context) {
    final myValueRef = ref.read(slideDataProvider.notifier).ref;
    final appDataController = ref.read(appDataProvider.notifier);

    return Stack(
      children: [
        Positioned(
          child: Container(
            width: 190,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: RawMaterialButton(
              padding: const EdgeInsets.only(bottom: 10),
              shape: const RoundedRectangleBorder(),
              onPressed: () {
                getPresentation(widget.idPresent, widget.presentName);
                Navigator.of(context).push(
                  PresentationDialog<void>(
                    idPresent: widget.idPresent,
                    presentName: widget.presentName,
                    ref: myValueRef,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xE5DFFFD6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      widget.presentName,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
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
                deletePresent(
                  appDataController.email,
                  widget.idPresent.toString(),
                );
              },
              child: const Icon(
                Icons.delete,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
