import 'dart:async';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:url_launcher/url_launcher.dart';

/// Static Latitude & Longitude
const double originLatitude = 18.6370204;
const double originLongitude = 73.8244481;

const double destinationLatitude = 26.7324;
const double destinationLongitude = 88.4176;

class OverlayService {
  static Future<void> showBubbleOverlay() async {
    await FlutterOverlayWindow.showOverlay(
      overlayTitle: "Bubble Overlay",
      overlayContent: "bubble",
      enableDrag: true,
      height: 100,
      width: 100,
    );
  }

  static Future<void> showBookingOverlay() async {
    await FlutterOverlayWindow.showOverlay(
      overlayTitle: "New Booking",
      overlayContent: "booking",
      enableDrag: false,
      height: 200,
      width: 300,
    );
  }

  static Future<void> requestOverlayPermission() async {
    bool? granted = await FlutterOverlayWindow.isPermissionGranted();
    if (granted == false) {
      await FlutterOverlayWindow.requestPermission();
    }
    print('Overlay Permission = ${granted}');
  }

  static Future<void> showChatHeadOverlay() async {
    await FlutterOverlayWindow.showOverlay(
      height: 100,
      width: 100,
      enableDrag: false,
      alignment: OverlayAlignment.bottomCenter,
      positionGravity: PositionGravity.auto,
      visibility: NotificationVisibility.visibilityPublic,
      flag: OverlayFlag.defaultFlag,
    );

    // If user doesn't accept within 30 seconds, remove the overlay
    Timer(Duration(seconds: 30), () async {
      await FlutterOverlayWindow.closeOverlay();
      print('showFirstOverlay removed, 30 seconds completed');
    });
  }

  static Future<void> closeOverlay() async {
    await FlutterOverlayWindow.closeOverlay();
  }

  static Future<void> showFirstOverlay() async {
    await FlutterOverlayWindow.showOverlay(
      height: 1500,
      enableDrag: false,
      alignment: OverlayAlignment.bottomCenter,
      positionGravity: PositionGravity.auto,
      visibility: NotificationVisibility.visibilityPublic,
      flag: OverlayFlag.defaultFlag,
    );

    // // If user doesn't accept within 30 seconds, remove the overlay
    // Timer(Duration(seconds: 30), () {
    //   closeOverlay();
    //   print('showFirstOverlay removed, 30 seconds completed');
    // });
  }

  // Send data from main app to overlay using FlutterOverlayWindow methods
  static Future<void> sendDataToOverlay(String value) async {
    await FlutterOverlayWindow.shareData(value);
  }

  // Launch Google Map and start navigation in its full app view Using android_intent_plus.
  static void launchGoogleMapAppView() {
    final intent = AndroidIntent(
      action: 'action_view',
      data: "google.navigation:q=26.7324,88.4176&mode=d",
      package: 'com.google.android.apps.maps',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    intent.launch();
  }

  // static void openGoogleMapsInPIP(double lat, double lng) async {
  //   final Uri googleMapsUrl = Uri.parse("google.navigation:q=$lat,$lng");
  //   if (await canLaunchUrl(googleMapsUrl)) {
  //     await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch Google Maps.';
  //   }
  // }

  // // Launch Google Map and start navigation in its full app view url_launcher
  // static Future<void> launchGoogleMap({required String origin, required String destination}) async {
  //   final Uri googleMapUrl =
  //       Uri.parse("https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&dir_action=navigate&travelmode=driving");
  //
  //   if (await canLaunchUrl(googleMapUrl)) {
  //     await launchUrl(googleMapUrl, mode: LaunchMode.platformDefault);
  //   } else {
  //     print("Could not launch Google Maps");
  //   }
  // }
}

class ChatHeadController {
  static const MethodChannel _channel = MethodChannel("chat_head_channel");

  // Start Chat Head
  static Future<void> startChatHead() async {
    try {
      await _channel.invokeMethod("startChatHead");
      print("Chat Head Started");
      Timer(Duration(seconds: 15), () async {
        stopChatHead();
        // overlayMain2();
        showFirstOverlay();
        // await FlutterOverlayWindow.showOverlay(
        //   overlayTitle: "Booking Request",
        //   overlayContent: "Ride Request",
        //   enableDrag: false,
        //   height: 200,
        //   width: 300,
        //   alignment: OverlayAlignment.center,
        // );
      });
    } on PlatformException catch (e) {
      print("Failed to start chat head: ${e.message}");
    }
  }

  // Stop Chat Head
  static Future<void> stopChatHead() async {
    try {
      await _channel.invokeMethod("stopChatHead");
      print("Chat Head Stopped");
    } on PlatformException catch (e) {
      print("Failed to stop chat head: ${e.message}");
    }
  }

  static Future<void> showFirstOverlay() async {
    await FlutterOverlayWindow.showOverlay(
      height: 1500,
      enableDrag: false,
      alignment: OverlayAlignment.bottomCenter,
      positionGravity: PositionGravity.auto,
      visibility: NotificationVisibility.visibilityPublic,
      flag: OverlayFlag.defaultFlag,
    );

    // If user doesn't accept within 30 seconds, remove the overlay
    // Timer(Duration(seconds: 30), () {
    //   FlutterOverlayWindow.closeOverlay();
    //   print('showFirstOverlay removed, 30 seconds completed');
    // });
  }
}

// class ChatHeadAndroidIntent {
//   static void startChatHead() async {
//     final intent = AndroidIntent(
//       action: 'android.intent.action.START_SERVICE',
//       package: 'com.example.new_overlay_rnd',
//       componentName: 'com.example.new_overlay_rnd.ChatHeadService',
//       // componentName: 'com.example.chathead.ChatHeadService',
//       flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
//     );
//
//     try {
//       await intent.launch();
//       print("Chat Head Started");
//       Timer(Duration(seconds: 10), () async {
//         stopChatHead();
//         ChatHeadController.showFirstOverlay();
//       });
//     } catch (e) {
//       print("Failed to start chat head: $e");
//     }
//   }
//
//   static void stopChatHead() async {
//     final intent = AndroidIntent(
//       action: 'android.intent.action.STOP_SERVICE',
//       package: 'com.example.new_overlay_rnd',
//       componentName: 'com.example.new_overlay_rnd.ChatHeadService',
//       // componentName: 'com.example.chathead.ChatHeadService',
//       flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
//     );
//
//     try {
//       await intent.launch();
//       print("Chat Head Stopped");
//     } catch (e) {
//       print("Failed to stop chat head: $e");
//     }
//   }
// }
