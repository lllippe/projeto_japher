import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projeto_aucs/screens/commom/error_dialog.dart';
import 'package:projeto_aucs/screens/commom/exception_dialog.dart';
import 'package:projeto_aucs/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool _passwordVsible = false;

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
                  ),
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
                    decoration: InputDecoration(
                      label: const Text("Senha"),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVsible = !_passwordVsible;
                          });
                        },
                        icon: Icon(
                          _passwordVsible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 16,
                    obscureText: _passwordVsible
                        ? false
                        : true,
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

  void changeVisible(BuildContext context) {
    _passwordVsible = !_passwordVsible;
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
