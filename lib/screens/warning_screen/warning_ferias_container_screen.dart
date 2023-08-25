import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_aucs/models/sze010_falta_dias.dart';

class FeriasWarningScreen extends StatefulWidget {
  final Sze010FaltaDias? faltaDias;
  final String userId;
  final Function refreshFunction;

  const FeriasWarningScreen({
    Key? key,
    this.faltaDias,
    required this.userId,
    required this.refreshFunction,
  }) : super(key: key);

  @override
  State<FeriasWarningScreen> createState() => _FeriasWarningScreenState();
}

class _FeriasWarningScreenState extends State<FeriasWarningScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.faltaDias != null) {
      return ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Marcar os ${widget.faltaDias?.ze_saldfer.round()} dias restantes '
                    'o quanto antes.',
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: GoogleFonts.acme(
                  textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return ListTile(
        title: Row(
          children: [
            Text(
              'Todo o período foi agendado!',
              textAlign: TextAlign.center,
              style: GoogleFonts.acme(
                textStyle: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }
  }
}
