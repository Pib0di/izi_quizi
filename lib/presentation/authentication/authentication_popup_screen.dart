import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/domain/authentication_case.dart';
import 'package:izi_quizi/presentation/authentication/authentication_state.dart';

class Join extends ConsumerStatefulWidget {
  const Join({super.key});

  @override
  JoinState createState() => JoinState();
}

class JoinState extends ConsumerState<Join> {
  @override
  Widget build(BuildContext context) {
    ref.watch(authenticationProvider);

    final authenticationController = ref.watch(authenticationProvider.notifier);
    final appDataController = ref.read(appDataProvider.notifier);

    final formKey = authenticationController.formKey;

    //todo question
    if (authenticationController.isAuth == true) {
      Navigator.of(context).pop();
    }

    return IntrinsicHeight(
      child: Container(
        width: 600,
        padding: appDataController.isMobile
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: appDataController.isMobile
              ? BorderRadius.zero
              : BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: authenticationController.controllerEmail,
                    textInputAction: TextInputAction.next,
                    validator: checkEmail,
                    onChanged: (value) {
                      checkEmail(value);
                      if (value.isNotEmpty) {
                        formKey.currentState!.validate();
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'andrey@example.com',
                      labelText: 'Email',
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PasswordField(
                    formKey: formKey,
                    myControllerPass: ref
                        .watch(authenticationProvider.notifier)
                        .controllerPass,
                    restorationId: 'password_field',
                    textInputAction: TextInputAction.next,
                    validator: checkPassword,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Buttons(formKey: formKey),
            ),
          ],
        ),
      ),
    );
  }
}

///login and registration buttons
class Buttons extends ConsumerWidget {
  const Buttons({required this.formKey, super.key});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authenticationProvider);

    final appDataController = ref.read(appDataProvider.notifier);
    final authenticationController = ref.read(authenticationProvider.notifier);
    var buttonPressed = authenticationController.buttonPressed;
    final authorizeError = authenticationController.authorizeError;

    if (authorizeError) {
      buttonPressed = false;
    }

    return Column(
      children: <Widget>[
        if (buttonPressed) circularProgress,
        if (authorizeError) errorWidget,
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  // backgroundColor: Colors.teal,
                  // foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Зарегистрироваться'),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 10,
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    appDataController.email =
                        authenticationController.controllerEmail.text;
                    authorize(
                      appDataController.email,
                      authenticationController.controllerPass.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Авторизация...')),
                    );
                    authenticationController
                      ..buttonPressed = true
                      ..authorizeError = false
                      ..update();
                  }
                },
                child: const Text('Войти'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget circularProgress = Row(
  children: [
    Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: const SizedBox(
          width: 28, height: 28, child: CircularProgressIndicator()),
    ),
    const SizedBox(
      width: 10,
    ),
    const Text('Подтверждение'),
  ],
);

Widget errorWidget = Row(
  children: const [
    Icon(
      Icons.warning_rounded,
      color: Colors.redAccent,
      size: 30,
    ),
    Text('Ошибка авторизации'),
  ],
);

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.formKey,
    this.restorationId,
    this.hintText,
    this.validator,
    this.textInputAction,
    this.myControllerPass,
  });

  final GlobalKey<FormState>? formKey;
  final String? restorationId;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final TextEditingController? myControllerPass;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> with RestorationMixin {
  final RestorableBool _obscureText = RestorableBool(true);

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_obscureText, 'obscure_text');
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        widget.formKey!.currentState!.validate();
      },
      controller: widget.myControllerPass,
      restorationId: 'password_text_field',
      obscureText: _obscureText.value,
      maxLength: 18,
      validator: widget.validator,
      decoration: InputDecoration(
        filled: true,
        hintText: 'password',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText.value = !_obscureText.value;
            });
          },
          hoverColor: Colors.transparent,
          icon: Icon(
            _obscureText.value ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}
