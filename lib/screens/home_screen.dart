import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:new_overlay_rnd/components/overlay_service.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool isOverlayActive = false;
  bool getBooking = false;
  AppLifecycleState? _appState;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // Get the current lifecycle state
    _appState = WidgetsBinding.instance.lifecycleState;
    print('Initial app state: $_appState');

    // _checkAndShowOverlay();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appState = state;
    });
    if (_appState == AppLifecycleState.paused) {
      ChatHeadController.startChatHead();
      print("app state is paused");
    } else {
      ChatHeadController.stopChatHead();
      print("app state is ${_appState}}");
    }

    // switch (_appState) {
    //   case AppLifecycleState.resumed:
    //     print("app in resumed");
    //     ChatHeadController.stopChatHead();
    //     break;
    //   case AppLifecycleState.inactive:
    //     ChatHeadController.stopChatHead();
    //     print("app in inactive");
    //     break;
    //   case AppLifecycleState.paused:
    //     ChatHeadController.startChatHead();
    //     print("app in paused");
    //     break;
    //   case AppLifecycleState.detached:
    //     ChatHeadController.stopChatHead();
    //     handleShowOverlay();
    //     print("app in detached");
    //     break;
    //   case AppLifecycleState.hidden:
    //     ChatHeadController.stopChatHead();
    //     print("app in detached");
    //     break;
    //   case null:
    //     print('${_appState} is null');
    //     break;
    // }
    print('Updated app state: $_appState');
  }

  /// Check app state and handle overlay accordingly
  void handleShowOverlay() async {
    print('Checking app state before overlay: $_appState');

    if (_appState == AppLifecycleState.resumed || _appState == null) {
      print("App is in foreground, moving to background...");

      await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop'); // Minimize app

      // Register background task to show overlay after 10 sec
      Workmanager().registerOneOffTask(
        "uniqueTaskId",
        "showOverlayTask",
        // initialDelay: Duration(seconds: 10), // Wait 10 seconds
      );
    } else {
      print("overlay is running");
    }
  }

  // /// Check if overlay is permitted and show the bubble
  // Future<void> _checkAndShowOverlay() async {
  //   bool isPermissionGranted = await FlutterOverlayWindow.isPermissionGranted();
  //   if (!isPermissionGranted) {
  //     await FlutterOverlayWindow.requestPermission();
  //   }
  //   _showBubbleOverlay();
  // }
  //
  // /// Show the floating bubble overlay
  // Future<void> _showBubbleOverlay() async {
  //   await FlutterOverlayWindow.showOverlay(
  //     overlayTitle: "Driver Overlay",
  //     overlayContent: "Bubble Overlay",
  //     enableDrag: true,
  //     height: 100,
  //     width: 100,
  //     alignment: OverlayAlignment.centerRight,
  //   );
  //   isOverlayActive = true;
  // }
  //
  // /// Show the booking request overlay
  // Future<void> _showBookingOverlay() async {
  //   await FlutterOverlayWindow.closeOverlay(); // Remove bubble overlay
  //   await FlutterOverlayWindow.showOverlay(
  //     overlayTitle: "Booking Request",
  //     overlayContent: "Ride Request",
  //     enableDrag: false,
  //     height: 200,
  //     width: 300,
  //     alignment: OverlayAlignment.center,
  //   );
  //   isOverlayActive = true;
  // }
  //
  // /// Handle incoming ride request from customer
  // void onNewRideRequest() {
  //   _showBookingOverlay();
  // }
  //
  // /// Handle ride rejection (return to bubble overlay)
  // void onRejectRide() {
  //   _showBubbleOverlay();
  // }
  //
  // /// Handle ride acceptance (remove overlay and open Google Maps)
  // void onAcceptRide() {
  //   FlutterOverlayWindow.closeOverlay();
  //   isOverlayActive = false;
  //   _openGoogleMaps();
  // }
  //
  // void _openGoogleMaps() {
  //   print("Redirecting to Google Maps...");
  //   // Launch Google Maps navigation here
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Driver App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Start Chat Head
            ElevatedButton(
              onPressed: () {
                print('startChatHead pressed');
                ChatHeadController.startChatHead();
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(200, 40),
                ),
              ),
              child: const Text("Start Chat Head"),
            ),

            // Close Chat Head
            ElevatedButton(
              onPressed: () {
                print('stopChatHead pressed');
                ChatHeadController.stopChatHead();
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(200, 40),
                ),
              ),
              child: const Text("Close Chat Head"),
            ),

            // Show Instant Overlay
            ElevatedButton(
              onPressed: () {
                OverlayService.showFirstOverlay();
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(200, 40),
                ),
              ),
              child: const Text("Show Instant Overlay"),
            ),

            // Show Overlay in BG
            ElevatedButton(
              onPressed: () async {
                handleShowOverlay();
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(200, 40),
                ),
              ),
              child: const Text("Show overlay in Background"),
            ),

            // Close Overlay
            ElevatedButton(
              onPressed: () {
                OverlayService.closeOverlay();
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(200, 40),
                ),
              ),
              child: const Text("Close Overlay"),
            ),

            // Text field to pass value
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Enter value to send to overlay',
                ),
              ),
            ),

            // value print
            ElevatedButton(
              onPressed: () async {
                // final value = 'This is testing Pickup & Drop Location';
                final value = _textController.text.toString();
                OverlayService.sendDataToOverlay(value);
                print('Data send to overlay => ${value}');

                // OverlayService.openGoogleMapsInPIP(destinationLatitude, destinationLongitude);
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(200, 40),
                ),
              ),
              child: const Text("Send Value to Overlay"),
            ),
          ],
        ),
      ),
    );
  }
}
