import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/domain/authentication/authentication.dart';
import 'package:izi_quizi/presentation/authentication/authentication_state.dart';

class Join extends ConsumerStatefulWidget {
  const Join({super.key});

  @override
  JoinState createState() => JoinState();
}

class JoinState extends ConsumerState<Join> {
  @override
  Widget build(BuildContext context) {
    final stateController = ref.watch(authenticationPopupProvider.notifier);
    final formKey = stateController.formKey;

    if (stateController.isAuth == true) {
      Navigator.of(context).pop();
    }

    return IntrinsicHeight(
      child: Container(
        width: 600,
        padding: AppDataState.typeBrowser == 'Mobile'
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDataState.typeBrowser == 'Mobile'
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
                    controller: stateController.controllerEmail,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return AuthenticationCase().checkEmail(value);
                    },
                    onChanged: (value) {
                      AuthenticationCase().checkEmail(value);
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
                        .watch(authenticationPopupProvider.notifier)
                        .controllerPass,
                    restorationId: 'password_field',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return AuthenticationCase().checkPassword(value);
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [Buttons(formKey: formKey)],
              ),
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
    ref.watch(authenticationPopupProvider);

    final stateController = ref.watch(authenticationPopupProvider.notifier);
    final buttonPressed = stateController.buttonPressed;
    final isAuth = stateController.isAuth;

    return Expanded(
      child: ListView(
        children: <Widget>[
          buttonPressed
              ? isAuth
                  ? const Text('')
                  : errorWidget
              : const Text(''),
          const Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
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
          const SizedBox(
            width: 10,
            height: 10,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                stateController
                  ..buttonPressed = true
                  ..increment();
                AppDataState.email = stateController.controllerEmail.text;
                AuthenticationCase().authorize(
                  AppDataState.email,
                  stateController.controllerPass.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Авторизация...')),
                );
              }
            },
            child: const Text('Войти'),
          ),
        ],
      ),
    );
  }
}

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
