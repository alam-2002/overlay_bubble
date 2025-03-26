import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:new_overlay_rnd/components/overlay_service.dart';

class OverlayWidgetTop extends StatefulWidget {
  OverlayWidgetTop({
    super.key,
    required this.onCancelPressed,
    required this.onAcceptPressed,
  });

  final void Function() onCancelPressed;
  final void Function() onAcceptPressed;

  @override
  State<OverlayWidgetTop> createState() => _OverlayWidgetTopState();
}

class _OverlayWidgetTopState extends State<OverlayWidgetTop> {
  // String receivedText = "Waiting for data...";
  // String pickupLocation = "Waiting for data...";
  // String dropLocation = "Waiting for data...";
  //
  // // Future<String> receiveOverlayData() async {
  // //   final prefs = await SharedPreferences.getInstance();
  // //   setState(() {
  // //     receivedText = prefs.getString('overlay_message') ?? "No data passed";
  // //     pickupLocation = prefs.getString('pickup_location') ?? "No data passed";
  // //     dropLocation = prefs.getString('drop_location') ?? "No data passed";
  // //   });
  // //   return receivedText;
  // // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   // receiveOverlayData();
  // }

  String overlayValue = "Waiting for data...";

  @override
  void initState() {
    super.initState();

    // Listen to shared data from main app
    FlutterOverlayWindow.overlayListener.listen((data) {
      print("Overlay received: $data");
      setState(() {
        overlayValue = data.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        color: Colors.blue,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.circle,
                    size: 15,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  '2.4 Km',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 9),
                  height: 80,
                  width: 1,
                  color: Colors.black,
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: 300,
                  child: Text(
                    // pickupLocation,
                    'Hafeezpet-1609, Rd Number 15, Krishna Nagar Colony, Aditya Nagas Hafeerpet',
                    maxLines: 2,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_pin,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(
                  '2.4 Km',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              width: 300,
              child: Text(
                // dropLocation,
                'Hafeezpet-1609, Rd Number 16, Ganga Nagar Colony, Sharma Nagas Hafeezpet',
                maxLines: 2,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: widget.onCancelPressed,
                  icon: Icon(
                    Icons.cancel_outlined,
                    size: 50,
                  ),
                ),
                ElevatedButton(
                  onPressed: widget.onAcceptPressed,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.yellow),
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                    minimumSize: WidgetStateProperty.all<Size>(
                      Size(200, 50),
                    ), // Width and height
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25), // Rounded corners
                      ),
                    ),
                  ),
                  child: Text(
                    'Accept',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            Text(
              // receivedText,
              overlayValue,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
