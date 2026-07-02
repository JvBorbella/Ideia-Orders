import 'package:flutter/material.dart';
import 'package:styles/widths.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        'Seu usuário não possui permissão',
        style: TextStyle(fontSize: Responsive.h(context, 12)),
      ),
      actions: [
        ButtonConfig(
            text: 'Fechar',
            height: Responsive.h(context, 15),
            onPressed: () => Navigator.of(context).pop())
      ],
    );
  }
}
