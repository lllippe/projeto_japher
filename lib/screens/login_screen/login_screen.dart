import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projeto_aucs/screens/commom/error_dialog.dart';
import 'package:projeto_aucs/screens/commom/exception_dialog.dart';
import 'package:projeto_aucs/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 150),
        margin: const EdgeInsets.all(16),
        //decoration:
        //BoxDecoration(border: Border.all(width: 8), color: Colors.white),
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    child: Image.asset(
                      'assets/images/robot.gif',
                      fit: BoxFit.cover,
                    ),
                  ), //Icon(
                  //Icons.bookmark,
                  //size: 64,
                  //color: Colors.brown,
                  //),
                  const Text(
                    "Japher Assessoria Contábil",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("por FrPelissari",
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(thickness: 2),
                  ),
                  const Text("Entre"),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text("Usuário"),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(label: Text("Senha")),
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 16,
                    obscureText: true,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        tryLogin(context);
                      },
                      child: const Text("Continuar")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void tryLogin(BuildContext context) {
    String email = _emailController.text;
    String password = _passwordController.text;

    authService.login(email, password).then((token) {
      Navigator.pushReplacementNamed(context, 'transfer');
    }).catchError((e) {
      ErrorDialog(context, 'Usuário não cadastrado');
    }, test: (e) => e is UserNotFoundException).catchError((e) {
      showExceptionDialog(context,
          content:
              "O servidor demorou para responder, tente novamente mais tarde.");
    }, test: (e) => e is TimeoutException);
  }
}
