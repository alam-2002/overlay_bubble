import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:new_overlay_rnd/components/background_service.dart';
import 'package:new_overlay_rnd/components/chat_head_overlay.dart';
import 'package:new_overlay_rnd/components/overlay.dart';
import 'package:new_overlay_rnd/components/overlay_service.dart';
import 'package:new_overlay_rnd/components/overlay_widget_top.dart';
import 'package:new_overlay_rnd/screens/home_screen.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundService.initializeService();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ChatHeadOverlay(),
      home: OverlayWidgetTop(
        onCancelPressed: () {
          FlutterOverlayWindow.closeOverlay();
        },
        onAcceptPressed: () {
          FlutterOverlayWindow.closeOverlay();
          OverlayService.launchGoogleMapAppView();
        },
      ),
    ),
  );
}

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

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     print("Background Task Triggered: $task");
//     await FlutterOverlayWindow.showOverlay(
//       height: 1500,
//       // width: 100,
//       enableDrag: false,
//       alignment: OverlayAlignment.centerRight,
//       positionGravity: PositionGravity.auto,
//       flag: OverlayFlag.defaultFlag,
//     );
//     // ChatHeadController.startChatHead();
//     // ChatHeadController.showFirstOverlay();
//
//     return Future.value(true);
//   });
// }

/// workmanager Method to show overlay from background state of app
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Background Task Triggered: $task");
    OverlayService.showFirstOverlay();

    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
