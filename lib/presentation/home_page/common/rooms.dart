import 'package:flutter/material.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // heightFactor: MediaQuery.of(context).size.height+500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Center(
            child: Text("It's sunny here"),
          ),
          AlertDialog(
            content: Text('Hi'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            // child: Text('Result: ${snapshot.data}'),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Awaiting result...'),
          ),
        ],
      ),
    );
  }
}
