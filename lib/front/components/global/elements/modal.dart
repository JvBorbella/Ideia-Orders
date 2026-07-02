import 'package:flutter/material.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';

class Modal extends StatefulWidget {
  final String? title;
  final List<Widget>? children;

  const Modal(this.title, this.children) : super(key: null);

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SizedBox(
              width: Responsive.w(context, 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(Responsive.h(context, 8)),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Responsive.h(context, 15)),
                        topRight: Radius.circular(Responsive.h(context, 15)),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                Icons.close,
                                color: ColorsApp.tertiaryColor,
                                size: Responsive.h(context, 20),
                              ),
                            ),
                          ],
                        ),
                        Positioned.fill(
                          child: Center(
                            child: SizedBox(
                              width: Responsive.w(context, 120),
                              child: Text(
                                widget.title ?? '',
                                style: TextStyle(
                                  fontSize: Responsive.h(context, 12),
                                  fontWeight: FontWeight.bold,
                                  color: ColorsApp.tertiaryColor,
                                ),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Responsive.h(context, 10)),
                  Container(
                    padding: EdgeInsets.all(Responsive.h(context, 12)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Responsive.h(context, 15)),
                        bottomRight: Radius.circular(Responsive.h(context, 15)),
                      ),
                    ),
                    child: Column(
                      children: widget.children ?? [],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
