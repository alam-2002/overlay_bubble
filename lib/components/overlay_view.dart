import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

// void main() {
//   runApp(OverlayView());
// }

// @pragma("vm:entry-point")
// void overlayMain2() {
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: OverlayView(),
//     ),
//   );
// }

class OverlayView extends StatefulWidget {
  @override
  _OverlayViewState createState() => _OverlayViewState();
}

class _OverlayViewState extends State<OverlayView> {
  String receivedData = "Waiting for data...";

  @override
  void initState() {
    super.initState();

    // Listen for data from the main app
    FlutterOverlayWindow.overlayListener.listen((event) {
      setState(() {
        receivedData = event;
      });
      print("Overlay received: $event");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.8),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(receivedData, style: TextStyle(fontSize: 18)),
              ElevatedButton(
                onPressed: () => FlutterOverlayWindow.shareData("accept"),
                child: Text("Accept"),
              ),
              ElevatedButton(
                onPressed: () => FlutterOverlayWindow.shareData("reject"),
                child: Text("Reject"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
//
// void main() => runApp(OverlayView());
//
// class OverlayView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: OverlayContent(),
//     );
//   }
// }
//
// class OverlayContent extends StatefulWidget {
//   @override
//   _OverlayContentState createState() => _OverlayContentState();
// }
//
// class _OverlayContentState extends State<OverlayContent> {
//   String overlayType = "bubble";
//
//   @override
//   void initState() {
//     super.initState();
//     getOverlayType();
//   }
//
//   Future<void> getOverlayType() async {
//     final data = await FlutterOverlayWindow.getOverlayData();
//     setState(() {
//       overlayType = data ?? "bubble";
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return overlayType == "booking" ? bookingOverlay() : bubbleOverlay();
//   }
//
//   Widget bubbleOverlay() {
//     return GestureDetector(
//       onTap: () => FlutterOverlayWindow.shareData("openBooking"),
//       child: Container(
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//           color: Colors.red,
//           shape: BoxShape.circle,
//         ),
//         child: Center(
//           child: Icon(Icons.directions_car, color: Colors.white, size: 40),
//         ),
//       ),
//     );
//   }
//
//   Widget bookingOverlay() {
//     return Container(
//       width: 300,
//       height: 200,
//       color: Colors.white,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("New Booking", style: TextStyle(fontSize: 20)),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () => FlutterOverlayWindow.shareData("accept"),
//             child: Text("Accept"),
//           ),
//           ElevatedButton(
//             onPressed: () => FlutterOverlayWindow.shareData("reject"),
//             child: Text("Reject"),
//           ),
//         ],
//       ),
//     );
//   }
// }
