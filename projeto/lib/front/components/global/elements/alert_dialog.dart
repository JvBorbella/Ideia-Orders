import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:projeto/front/components/login_config/elements/config_button.dart';

class AlertDialogDefault extends StatefulWidget {
  const AlertDialogDefault({super.key});

  @override
  State<AlertDialogDefault> createState() => _AlertDialogDefaultState();
}

class _AlertDialogDefaultState extends State<AlertDialogDefault> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Style.defaultColor,
      title: Text(
        'Seu usuário não possui permissão',
        style: TextStyle(fontSize: Style.height_12(context)),
      ),
      actions: [
        ButtonConfig(
            text: 'Fechar',
            height: Style.height_15(context),
            onPressed: () => Navigator.of(context).pop())
      ],
    );
  }
}
