import 'package:flutter/material.dart';

class EnterProjectName extends StatelessWidget {
  const EnterProjectName(TextEditingController? control, {super.key})
      : myController = control;
  final TextEditingController? myController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: TextFormField(
        controller: myController,
        restorationId: 'life_story_field',
        textInputAction: TextInputAction.next,
        // focusNode: _lifeStory,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Проективная геометрия 2-3 неделя',
          // helperText: "название вашего iziQuizi",
          labelText: 'Имя проекта',
        ),
        maxLines: 1,
      ),
    );
  }
}
