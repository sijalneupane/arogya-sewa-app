import 'package:flutter/material.dart';

class MyInteractiveViewer {
 dynamic myInteractiveViewer(BuildContext context,Widget? child) {
    return showDialog(
      context: context,
      builder:
          (_) => Dialog(
            insetPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 5,
            ),
            backgroundColor: Colors.green,
            shadowColor: Colors.black,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 2,
                scaleEnabled: true,
                clipBehavior: Clip.antiAlias,
                trackpadScrollCausesScale: true,
                panEnabled: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: child,
                ),
              ),
            ),
          ),
    );
  }
}
