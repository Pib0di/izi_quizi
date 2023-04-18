import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/data/repository/local/app_data.dart';
import 'package:izi_quizi/domain/authentication/authentication_impl.dart';
import 'package:izi_quizi/main.dart';
import 'package:izi_quizi/presentation/authentication/authentication_state.dart';

AuthenticationImpl authenticationImpl = AuthenticationImpl();

class PasswordField extends StatefulWidget {
  PasswordField({
    super.key,
    this.formKey,
    this.restorationId,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction,
    this.myControllerPass,
    this.helperTexts,
  });

  GlobalKey<FormState>? formKey;
  final String? restorationId;
  final Key? fieldKey;
  String? hintText;
  String? labelText;
  final String? helperText;
  final String? helperTexts;
  final FormFieldSetter<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final TextEditingController? myControllerPass;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> with RestorationMixin {
  final RestorableBool _obscureText = RestorableBool(true);

  @override
  String? get restorationId => widget.restorationId;

  String? get hintText => widget.hintText;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_obscureText, 'obscure_text');
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        // _formKey.currentState!.validate()
        widget.formKey!.currentState!.validate();
      },
      controller: widget.myControllerPass,
      key: widget.fieldKey,
      restorationId: 'password_text_field',
      obscureText: _obscureText.value,
      maxLength: 18,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: 'password',
        labelText: widget.labelText,
        helperText: widget.helperText,
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

class Join extends ConsumerStatefulWidget {
  const Join({super.key});

  @override
  JoinState createState() => JoinState();
}

class JoinState extends ConsumerState<Join> {
  final myControllerEmail = TextEditingController();
  final controllerPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  late bool isAuth = false;
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

  @override
  Widget build(BuildContext context) {
    isAuth = ref.watch(appData.authStateProvider());
    isAuth = appData.authStateController().state;
    ref.watch(authUpdate);

    if (appData.authStateController().state == true) {
      Navigator.of(context).pop();
    }
    // Widget progress(){
    //   return Row(
    //     children: const [
    //       Icon(
    //         Icons.warning_rounded,
    //         color: Colors.redAccent,
    //         size: 30,
    //       ),
    //       Text("Ошибка авторизации"),
    //     ],
    //   );
    //   print("isAuth => $isAuth");
    //   if (buttonClick){
    //     if (!isAuth && buttonClick){
    //       return Row(
    //         children: const [
    //           Icon(
    //             Icons.warning_rounded,
    //             color: Colors.redAccent,
    //             size: 30,
    //           ),
    //           Text("Ошибка авторизации"),
    //         ],
    //       );
    //     }
    //     return Row(
    //       children: const [
    //         SizedBox(
    //           width: 40,
    //           height: 40,
    //           child: CircularProgressIndicator(),
    //         ),
    //         Text("Ожидание ответа"),
    //       ],
    //     );
    //   }
    //   return const Text("");
    // }
    final passwordField = PasswordField(
      formKey: _formKey,
      myControllerPass: controllerPass,
      restorationId: 'password_field',
      textInputAction: TextInputAction.next,
      validator: (value) {
        return authenticationImpl.checkPassword(value);
      },
    );

    final buttonsAdapt = <Widget>[
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
          if (_formKey.currentState!.validate()) {
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
          if (_formKey.currentState!.validate()) {
            buttonPressed = true;
            AppData.email = myControllerEmail.text;
            authenticationImpl.authorize(AppData.email, controllerPass.text);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Авторизация...')),
            );
          }
        },
        child: const Text('Войти'),
      ),
    ];

    return IntrinsicHeight(
      child: Container(
        width: 600,
        padding: AppData.typeBrowser == 'Mobile'
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          // color: Colors.grey[200],
          color: Colors.white,
          borderRadius: AppData.typeBrowser == 'Mobile'
              ? BorderRadius.zero
              : BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: myControllerEmail,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return authenticationImpl.checkEmail(value);
                    },
                    onChanged: (value) {
                      authenticationImpl.checkEmail(value);
                      if (value.isNotEmpty) {
                        _formKey.currentState!.validate();
                      }
                    },
                    // focusNode: _lifeStory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'andrey@example.com',
                      // helperText: "название вашего iziQuizi",
                      labelText: 'Email',
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  passwordField
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Builder(
                builder: (BuildContext context) {
                  if (AppData.typeBrowser == 'Mobile') {
                    return SizedBox(
                      height: 110,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: buttonsAdapt,
                      ),
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: buttonsAdapt,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
