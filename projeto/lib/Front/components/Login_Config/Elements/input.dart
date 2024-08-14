import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto/front/components/Style.dart';

class Input extends StatefulWidget {
  //Variável para definir o texto do input na página em que é chamado
  final String text;
  //Variável para definir o tipo do teclado qque será exibiso ao clicar no input, na página em que é chamado
  final TextInputType type;
  final IconButton;
  //Variável para definir se o texto passado no input será exibido ou ocultado, na página em que é chamado
  final obscureText;
  final controller;
  final validator;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;

  const Input(
      {Key? key,
      required this.text,
      required this.type,
      this.obscureText,
      this.controller,
      this.validator,
      this.IconButton,
      required this.textAlign,
      this.textInputAction
      })
      : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Se um controlador foi fornecido, use-o; caso contrário, use o controlador interno.
    if (widget.controller != null) {
      _textController = widget.controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: 1200),
        child: Container(
          margin: EdgeInsets.only(left: 5.0, right: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _textController, 
                style: TextStyle(
                  fontSize: Style.height_12(context),
                  fontFamily: 'Poppins-Regular'
                ),
                onSubmitted: (value) {
                  FocusScope.of(context).nextFocus(); // Avança para o próximo campo ao pressionar Enter
                },
                keyboardType: widget.type,
                textAlign: widget.textAlign,
                obscureText: widget.obscureText ?? false,
                cursorColor: Style.primaryColor,
                textInputAction: widget.textInputAction ?? TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: widget.IconButton,
                  suffixIconColor: Style.primaryColor,
                  labelText: widget.text,
                  labelStyle: TextStyle(
                    color: Style.quarantineColor,
                    fontSize: Style.height_10(context),
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Style.secondaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Style.secondaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   // Certifique-se de liberar o controlador ao destruir o widget.
  //   _textController.dispose();
  //   super.dispose();
  // }
}
