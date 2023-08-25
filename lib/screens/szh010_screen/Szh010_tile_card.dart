import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_aucs/models/sze010_falta_dias.dart';
import 'package:projeto_aucs/screens/add_screen/add_szh010_screen.dart';

class Szh010TileCard extends StatefulWidget {
  final Sze010FaltaDias? sze010;
  final depto;

  const Szh010TileCard({
    Key? key,
    this.sze010,
    this.depto,
  }) : super(key: key);

  @override
  State<Szh010TileCard> createState() => _Szh010TileCardState();
}

class _Szh010TileCardState extends State<Szh010TileCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.sze010 != null) {
      return ListTile(
          title: Text(
            widget.sze010!.ze_nome.trim(),
            style: GoogleFonts.acme(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          trailing: const Icon(Icons.edit),
          onTap: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSzh010Screen(
                    sze010: widget.sze010!,
                    createAppBar: true,
                  ),
                ),
              ); //callAddSzh010Screen(context, sze010: widget.sze010);
            });
          });
    } else {
      return const ListTile(
        title: Text('Nenhum colaborador Cadastrado'),
      );
    }
  }
}
