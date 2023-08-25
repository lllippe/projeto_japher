import 'package:flutter/material.dart';

class UnderConstruction extends StatelessWidget {
  final String image;

  const UnderConstruction(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 350,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ]);
  }
}
