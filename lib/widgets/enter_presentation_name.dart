import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/presentation/creating_editing_presentation/create_editing_state.dart';

class EnterProjectName extends ConsumerWidget {
  const EnterProjectName(TextEditingController? control, {super.key})
      : myController = control;
  final TextEditingController? myController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createEditingController = ref.read(createEditing.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: TextFormField(
        controller: createEditingController.textController,
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
