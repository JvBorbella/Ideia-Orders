import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';

class InputAction extends StatefulWidget {
  //Variável para definir o texto do InputAction na página em que é chamado
  final String text;
  final ValueChanged? onChanged, onSubmitted;
  //Variável para definir o tipo do teclado qque será exibiso ao clicar no InputAction, na página em que é chamado
  final TextInputType type;
  final IconButtonTheme? iconButton;
  //Variável para definir se o texto passado no InputAction será exibido ou ocultado, na página em que é chamado
  final bool? obscureText, isLoadingButton;
  final TextEditingController? controller;
  final Function? validator;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputActionFormatters;
  final VoidCallback? onTap;

  const InputAction(
      {super.key,
      required this.text,
      this.onChanged,
      required this.type,
      this.obscureText,
      this.controller,
      this.validator,
      this.iconButton,
      required this.textAlign,
      this.textInputAction,
      this.inputActionFormatters,
      this.onTap,
      this.onSubmitted,
      this.isLoadingButton});

  @override
  State<InputAction> createState() => _InputActionState();
}

class _InputActionState extends State<InputAction> {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Se um controlador foi fornecido, use-o; caso contrário, use o controlador interno.
    if (widget.controller != null) {
      _textController = widget.controller ?? TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Container(
          margin: const EdgeInsets.only(left: 5.0, right: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _textController,
                onChanged: widget.onChanged,
                style: TextStyle(
                    fontSize: Responsive.h(context, 12),
                    fontFamily: 'Poppins-Regular'),
                onFieldSubmitted: widget.onSubmitted,
                keyboardType: widget.type,
                textAlign: widget.textAlign,
                obscureText: widget.obscureText ?? false,
                cursorColor: Theme.of(context).colorScheme.primary,
                textInputAction: TextInputAction.go,
                inputFormatters: widget.inputActionFormatters,
                onTap: widget.onTap,
                decoration: InputDecoration(
                  suffixIcon: widget.isLoadingButton == true
                      ? Container(
                          width: Responsive.h(context, 7),
                          height: Responsive.h(context, 7),
                          padding: EdgeInsets.all(Responsive.h(context, 10)),
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2.0,
                          ),
                        )
                      : widget.iconButton,
                  suffixIconColor: Theme.of(context).colorScheme.primary,
                  labelText: widget.text,
                  labelStyle: TextStyle(
                    color: ColorsApp.quarantineColor,
                    fontSize: Responsive.h(context, 10),
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSecondary,
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
}
