import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  _OverlayWidgetState createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  String overlayContent = "Bubble Overlay";

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((message) {
      setState(() {
        overlayContent = message;
      });

      if (message == "Ride Request") {
        _showBookingOverlay();
      }
    });
  }

  void _showBookingOverlay() {
    setState(() {
      overlayContent = "New Ride Request";
    });
  }

  void _onAcceptRide() {
    FlutterOverlayWindow.closeOverlay();
    print("Ride Accepted! Opening Google Maps...");
  }

  void _onRejectRide() {
    FlutterOverlayWindow.shareData("Bubble Overlay");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: overlayContent == "Bubble Overlay" ? 80 : 250,
          height: overlayContent == "Bubble Overlay" ? 80 : 150,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: overlayContent == "Bubble Overlay"
              ? const Icon(Icons.car_rental, size: 50, color: Colors.white)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("New Booking!", style: TextStyle(color: Colors.white, fontSize: 16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _onAcceptRide,
                          child: const Text("Accept"),
                        ),
                        ElevatedButton(
                          onPressed: _onRejectRide,
                          child: const Text("Reject"),
                        ),
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
