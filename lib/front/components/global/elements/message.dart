import 'package:flutter/material.dart';
import 'package:styles/widths.dart';

class Message {
  static void showReturnOverlay(
      BuildContext context, Color color, IconData icon, String text) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
        builder: (context) => Padding(
              padding: EdgeInsetsGeometry.symmetric(
                  horizontal: Responsive.h(context, 12),
                  vertical: Responsive.h(context, 12)),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            text,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => overlayEntry.remove(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () => overlayEntry.remove());
  }
}
