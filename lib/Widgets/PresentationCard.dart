
import 'package:flutter/material.dart';

import '../main.dart';
import 'PresentationDialog.dart';

class PresentCard extends StatefulWidget {
  const PresentCard({
    Key? key,
    required this.idPresent,
    required this.presentName,
  }) : super(key: key);

  final int idPresent;
  final String presentName;

  @override
  State<PresentCard> createState() => _PresentCardState();
}

class _PresentCardState extends State<PresentCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            width: 190,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: const DecorationImage(
                image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: RawMaterialButton(
              padding: const EdgeInsets.only(bottom: 10),
              shape: const RoundedRectangleBorder(),
              onPressed: (){
                print("getSlideData");
                request.getSlideData(widget.idPresent, widget.presentName);
                Navigator.of(context).push(PresentationDialog<void>(
                  idPresent: widget.idPresent,
                  presentName: widget.presentName,
                ));
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
                print("email => $email, txt => ${widget.idPresent.toString()}");
                request.deletePresent(email, widget.idPresent.toString());
              },
              child: const Icon(Icons.delete, size: 20,),
            ),
          ),
        ),
      ],
    );
  }
}