
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izi_quizi/serv.dart';

import '../main.dart';


class PasswordField extends StatefulWidget {

  PasswordField(
      {
        Key? key,
        this.restorationId,
        this.fieldKey,
        this.hintText,
        this.labelText,
        this.helperText,
        this.onSaved,
        this.validator,
        this.onFieldSubmitted,
        this.focusNode,
        this.textInputAction,
        this.myControllerPass,
      }) : super(key: key);

  final String? restorationId;
  final Key? fieldKey;
  String? hintText;
  String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
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
      controller: widget.myControllerPass,
      key: widget.fieldKey,
      restorationId: 'password_text_field',
      obscureText: _obscureText.value,
      maxLength: 18,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: "password",
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              print("hintText setState() => $hintText");

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
  const Join({Key? key}) : super(key: key);

  @override
  JoinState createState() => JoinState();
}

class JoinState extends ConsumerState<Join> {
  final myControllerEmail = TextEditingController();
  final myControllerPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool buttonClick = false;

  late bool isAuth = false;
  Widget errorWidget = Row(
      children: const [
        Icon(
          Icons.warning_rounded,
          color: Colors.redAccent,
          size: 30,
        ),
        Text("Ошибка авторизации"),
      ],
    );

  @override
  Widget build(BuildContext context) {
    isAuth = ref.watch(appData.authStateProvider());
    isAuth = appData.authStateController().state;
    if (appData.authStateController().state == true){
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
    final PasswordField passwordField = PasswordField(
      myControllerPass: myControllerPass,
      restorationId: 'password_field',
      textInputAction: TextInputAction.next,
      validator: (value){
        bool isPasswordValid(String? password) {
          if (password == null) return false;
          if (password.length < 8) return false;
          if (!password.contains(RegExp(r"[a-z]"))) return false;
          if (!password.contains(RegExp(r"[A-Z]"))) return false;
          if (!password.contains(RegExp(r"[0-9]"))) return false;
          // if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
          return true;
        }
        final bool passwordValid = isPasswordValid(value);
        if (  value == null
            || value.isEmpty
            || !passwordValid
        ) {
          return "Пароль должен содержать a-z, A-Z, 0-9 и содержать от 8 символов";
        }
        return null;
      },
      onFieldSubmitted: (value) {
      },
    );
    return IntrinsicHeight(
      child: Container(
        width: 600,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(32),
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
                    validator: (value){
                      if (  value == null
                            || value.isEmpty
                            || !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value)
                      ) {
                        return 'Неверный формат почты';
                      }
                      return null;
                    },
                    // focusNode: _lifeStory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "andrey@example.com",
                      // helperText: "название вашего iziQuizi",
                      labelText: "Email",
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 20,),
                  passwordField
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  buttonClick ? isAuth ? const Text("")
                      : errorWidget
                      : const Text(""),

                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate())
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: const Text('Зарегистрироваться'),
                  ),
                  const SizedBox(width: 10,),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate())
                      {
                        buttonClick = true;
                        email = myControllerEmail.text.toString();
                        request.authentication(email, myControllerPass.text.toString());

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Авторизация...')),
                        );
                      }
                    },
                    child: const Text('Войти'),
                  ),
                ],
              ),
            ),
          ],
        )
        ),
    );
  }
}
