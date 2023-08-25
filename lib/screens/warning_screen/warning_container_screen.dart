import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:projeto_aucs/models/aniversarios.dart';

class ContainerWarningScreen extends StatefulWidget {
  final Aniversarios? aniversarios;
  final String userId;
  final Function refreshFunction;

  const ContainerWarningScreen({
    Key? key,
    this.aniversarios,
    required this.userId,
    required this.refreshFunction,
  }) : super(key: key);

  @override
  State<ContainerWarningScreen> createState() => _ContainerWarningScreenState();
}

class _ContainerWarningScreenState extends State<ContainerWarningScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.aniversarios?.ze_nome != null) {
      return ListTile(
        title: Row(
          children: [
            Text(
              '${widget.aniversarios!.ze_nome.trim()} - ',
              overflow: TextOverflow.values.first,
              textAlign: TextAlign.center,
              style: GoogleFonts.acme(
                textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
            ),
            Text(
              DateFormat('dd/MM').format(DateTime.parse(widget.aniversarios!.ze_niver)),
              overflow: TextOverflow.values.first,
              textAlign: TextAlign.center,
              style: GoogleFonts.acme(
                textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () {},
        child: Container(
          height: 115,
          alignment: Alignment.center,
          child: const Text(
            'Nenhum aniversário esse mês!',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
