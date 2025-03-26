import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

// @pragma("vm:entry-point")
// void overlayMain2() {
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: OverlayWidgetTop(
//         onCancelPressed: () {
//           FlutterOverlayWindow.closeOverlay();
//         },
//         onAcceptPressed: () {
//           FlutterOverlayWindow.closeOverlay();
//         },
//       ),
//     ),
//   );
// }

class ChatHeadOverlay extends StatefulWidget {
// class ChatHeadOverlay extends StatelessWidget {
  const ChatHeadOverlay({super.key});

  @override
  State<ChatHeadOverlay> createState() => _ChatHeadOverlayState();
}

class _ChatHeadOverlayState extends State<ChatHeadOverlay> {
  // @override
  // void initState() {
  //   super.initState();
  //
  //   Timer(Duration(seconds: 20), () async {
  //     await FlutterOverlayWindow.closeOverlay();
  //     overlayMain2();
  //     await FlutterOverlayWindow.showOverlay(
  //       height: 1500,
  //       enableDrag: false,
  //       alignment: OverlayAlignment.bottomCenter,
  //       positionGravity: PositionGravity.auto,
  //       visibility: NotificationVisibility.visibilityPublic,
  //       flag: OverlayFlag.defaultFlag,
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onPanUpdate: (details) {
          // Update the position of the chat-head overlay
          FlutterOverlayWindow.resizeOverlay(
            50,
            50,
            true,
          );
        },
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              'assets/images/bubbleIcon.png',
              height: 50,
              width: 50,
            ),
            // child: Icon(
            //   Icons.chat,
            //   color: Colors.white,
            //   size: 25,
            // ),
          ),
        ),
      ),
    );
  }
}
