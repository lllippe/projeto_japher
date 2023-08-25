import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        fixedSize: const Size.fromWidth(300),
        textStyle: const TextStyle(fontSize: 25),
        );

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Bem-vindo ao App dos Anjos da Umbanda do Cacique Sol!',
              style: TextStyle(color: Colors.brown, fontSize: 30),
              textAlign: TextAlign.center,),
          ),
          ElevatedButton(
            style: style,
            child: Text(
              'Login',
              style: TextStyle(color: Colors.brown[100], fontSize: 25),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/dashboard");
            },
          ),
          ElevatedButton(
            style: style,
            child: Text(
              'Continuar sem login',
              style: TextStyle(color: Colors.brown[100], fontSize: 25),
            ),
            onPressed: () {},
          ),
        ],
      ),
    ));
  }
}
