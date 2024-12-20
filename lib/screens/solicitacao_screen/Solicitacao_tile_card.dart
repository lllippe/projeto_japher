import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/screens/commom/error_dialog.dart';
import 'package:projeto_aucs/screens/commom/success_dialog.dart';
import 'package:projeto_aucs/screens/solicitacao_screen/solicitacao_screen.dart';
import 'package:projeto_aucs/services/sze010_service.dart';
import 'package:projeto_aucs/services/szh010_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SolicitacaoTileCard extends StatefulWidget {
  final Szh010? szh010;
  final matricula;

  const SolicitacaoTileCard({
    Key? key,
    this.szh010,
    this.matricula,
  }) : super(key: key);

  @override
  State<SolicitacaoTileCard> createState() => _SolicitacaoTileCardState();
}

class _SolicitacaoTileCardState extends State<SolicitacaoTileCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.szh010 != null) {
      if (widget.szh010!.zh_mat != '') {
        return ListTile(
          title: Text(
            '${widget.szh010!.zh_dataini.substring(6, 8)}/'
            '${widget.szh010!.zh_dataini.substring(4, 6)}/'
            '${widget.szh010!.zh_dataini.substring(0, 4)} a '
            '${widget.szh010!.zh_datafim.substring(6, 8)}/'
            '${widget.szh010!.zh_datafim.substring(4, 6)}/'
            '${widget.szh010!.zh_dataini.substring(0, 4)} - '
            '${widget.szh010!.zh_diasfer.round()} dias',
            style: GoogleFonts.acme(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          trailing: Wrap(
            children: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  approveSolicitation(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.cancel_outlined),
                onPressed: () {
                  rejectSolicitation(context);
                },
              ),
            ],
          ),
        );
      } else {
        return const ListTile(
          title: Text('Nenhuma solicitação pendente'),
        );
      }
    } else {
      return const ListTile(
        title: Text('Nenhuma solicitação pendente'),
      );
    }
  }

  approveSolicitation(BuildContext context) async {
    Szh010Service szh010service = Szh010Service();
    Sze010Service sze010service = Sze010Service();
    String nameColab = '';
    String mailSendTo = '';

    sze010service.getId(widget.szh010!.zh_mat).then((List<Sze010> listSze010) {
      for(Sze010 sze010 in listSze010){
        nameColab = sze010.ze_nome.trim();
        mailSendTo = sze010.ze_email.trim();
      }
    });

    String emailMessage = '$nameColab, '
        'a requisição do seguinte período de férias:\n'
        'Inicio: ${widget.szh010!.zh_dataini.substring(6, 8)}/'
        '${widget.szh010!.zh_dataini.substring(4, 6)}/'
        '${widget.szh010!.zh_dataini.substring(0, 4)}\n'
        'Fim: ${widget.szh010!.zh_datafim.substring(6, 8)}/'
        '${widget.szh010!.zh_datafim.substring(4, 6)}/'
        '${widget.szh010!.zh_dataini.substring(0, 4)}\n'
        'Totalizando: ${widget.szh010!.zh_diasfer.round()} dia(s) foi aprovada!';

    Szh010 internalSzh010 = Szh010(
        zh_mat: widget.szh010!.zh_mat,
        zh_inipaq: widget.szh010!.zh_inipaq,
        zh_fimpaq: widget.szh010!.zh_fimpaq,
        zh_saldfer: widget.szh010!.zh_saldfer,
        zh_diasfer: widget.szh010!.zh_diasfer,
        zh_dataini: widget.szh010!.zh_dataini,
        zh_datafim: widget.szh010!.zh_datafim,
        zh_aprvges: widget.szh010!.zh_aprvges,
        zh_aprvdir: widget.szh010!.zh_aprvdir,
        zh_recibvi: widget.szh010!.zh_recibvi,
        zh_dtrecvi: widget.szh010!.zh_dtrecvi,
        zh_recibap: widget.szh010!.zh_recibap,
        zh_dtrecap: widget.szh010!.zh_dtrecap,
        zh_integra: widget.szh010!.zh_integra,
        zh_depto: widget.szh010!.zh_depto,
        r_e_c_n_o_field: widget.szh010!.r_e_c_n_o_field,
        r_e_c_d_e_l_field: widget.szh010!.r_e_c_d_e_l_field,
        d_e_l_e_t_field: widget.szh010!.d_e_l_e_t_field);

    SharedPreferences.getInstance().then((prefs) {
      String? group = prefs.getString('group');

      if (group == '1') {
        internalSzh010.zh_aprvdir = '1';
      } else if (group == '2') {
        internalSzh010.zh_aprvges = '1';
      }

      szh010service
          .edit(widget.szh010!.r_e_c_n_o_field, internalSzh010)
          .then((value) {
        if (value) {
          sendEmail(nameColab, emailMessage, mailSendTo);
          Navigator.pop(context, DisposeStatus.success);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SolicitacaoScreen(
                      isloading: false,
                      group: group!,
                    )),
          );
          return SuccessDialog(context, 'Solicitação aceita!');
        } else {
          Navigator.pop(context, DisposeStatus.error);
          return ErrorDialog(context, 'Erro na requisição, tente mais tarde!');
        }
      });
    });
  }

  rejectSolicitation(BuildContext context) async {
    Szh010Service szh010service = Szh010Service();
    Sze010Service sze010service = Sze010Service();
    String nameColab = '';
    String mailSendTo = '';

    sze010service.getId(widget.szh010!.zh_mat).then((List<Sze010> listSze010) {
      for(Sze010 sze010 in listSze010){
        nameColab = sze010.ze_nome.trim();
        mailSendTo = sze010.ze_email.trim();
      }
    });

    String emailMessage = '$nameColab, '
        'a requisição do seguinte período de férias:\n'
        'Inicio: ${widget.szh010!.zh_dataini.substring(6, 8)}/'
        '${widget.szh010!.zh_dataini.substring(4, 6)}/'
        '${widget.szh010!.zh_dataini.substring(0, 4)}\n'
        'Fim: ${widget.szh010!.zh_datafim.substring(6, 8)}/'
        '${widget.szh010!.zh_datafim.substring(4, 6)}/'
        '${widget.szh010!.zh_dataini.substring(0, 4)}\n'
        'Totalizando: ${widget.szh010!.zh_diasfer.round()} dia(s) foi rejeitada!';

    Szh010 internalSzh010 = Szh010(
        zh_mat: widget.szh010!.zh_mat,
        zh_inipaq: widget.szh010!.zh_inipaq,
        zh_fimpaq: widget.szh010!.zh_fimpaq,
        zh_saldfer: widget.szh010!.zh_saldfer,
        zh_diasfer: widget.szh010!.zh_diasfer,
        zh_dataini: widget.szh010!.zh_dataini,
        zh_datafim: widget.szh010!.zh_datafim,
        zh_aprvges: widget.szh010!.zh_aprvges,
        zh_aprvdir: widget.szh010!.zh_aprvdir,
        zh_recibvi: widget.szh010!.zh_recibvi,
        zh_dtrecvi: widget.szh010!.zh_dtrecvi,
        zh_recibap: widget.szh010!.zh_recibap,
        zh_dtrecap: widget.szh010!.zh_dtrecap,
        zh_integra: widget.szh010!.zh_integra,
        zh_depto: widget.szh010!.zh_depto,
        r_e_c_n_o_field: widget.szh010!.r_e_c_n_o_field,
        r_e_c_d_e_l_field: widget.szh010!.r_e_c_d_e_l_field,
        d_e_l_e_t_field: widget.szh010!.d_e_l_e_t_field);

    SharedPreferences.getInstance().then((prefs) {
      String? group = prefs.getString('group');

      if (group == '1') {
        internalSzh010.zh_aprvdir = '2';
      } else if (group == '2') {
        internalSzh010.zh_aprvges = '2';
      }

      szh010service
          .edit(widget.szh010!.r_e_c_n_o_field, internalSzh010)
          .then((value) {
        if (value) {
          sendEmail(nameColab, emailMessage, mailSendTo);
          Navigator.pop(context, DisposeStatus.success);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SolicitacaoScreen(
                      isloading: true,
                      group: group!,
                    )),
          );
          return SuccessDialog(context, 'Solicitação Rejeitada com Sucesso!');
        } else {
          Navigator.pop(context, DisposeStatus.error);
          return ErrorDialog(context, 'Erro na requisição, tente mais tarde!');
        }
      });
    });
  }

  Future<void> sendEmail(String name, String messageToSend, String mailto) async {
    String username = 'japher_ferias@outlook.com';
    String password = 'J4ph3rF3ri4s';
    DateTime now = DateTime.now();

    var message = Message();
    message.from = Address(username.toString());
    message.recipients.add(mailto);
    //message.ccRecipients.add('felipe.pelissari@gmail.com');
    message.subject = 'Requisição de férias - $name';
    message.text = messageToSend;

    var smtpServer = hotmail(username, password);

    try {
      final sendReport = await send(message, smtpServer);
    } on MailerException catch (e) {
      String error = e.toString();
    }
  }
}

enum DisposeStatus { exit, error, success }
