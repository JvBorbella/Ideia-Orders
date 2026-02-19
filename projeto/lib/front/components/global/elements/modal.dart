import 'package:flutter/material.dart';
import 'package:projeto/front/components/style.dart';

class Modal extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const Modal(this.title, this.children);

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      backgroundColor: Style.defaultColor,
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: EdgeInsets.all(Style.height_8(context)),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Style.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Style.height_15(context)),
                      topRight: Radius.circular(Style.height_15(context)),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(
                                  Icons.close,
                                  color: Style.tertiaryColor,
                                  size: Style.height_20(context),
                                ))
                          ],
                        ),
                      ),
                      Positioned.fill(
                          child: Center(
                              child: Container(
                        width: Style.width_100(context),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: Style.height_12(context),
                            fontWeight: FontWeight.bold,
                            color: Style.tertiaryColor,
                          ),
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                        ),
                      ))),
                    ],
                  )
                  //  Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [

                  //   ],
                  // )
                  ),
              SizedBox(
                height: Style.height_10(context),
              ),
              Container(
                padding: EdgeInsets.all(Style.height_12(context)),
                child: Column(
                  children: widget.children,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
