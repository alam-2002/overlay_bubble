import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundService {
  /// Initialize background service
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        onBackground: onIosBackground,
        autoStart: true,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        autoStartOnBoot: true,
      ),
    );
    service.startService();
  }

  /// Start background service after termination
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Overlay Running in Background",
        content: "Tap to return to the app",
      );
    }
  }

  /// Start background service
  static void startBackgroundService() {
    final service = FlutterBackgroundService();
    service.startService();
  }

  /// Stop background service
  static void stopBackgroundService() {
    final service = FlutterBackgroundService();
    service.invoke("stop");
  }

  /// IOS background configuration
  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    return true;
  }
}

/*

  /// Initialize background service
  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        onBackground: onIosBackground,
        autoStart: true,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: false,
        autoStartOnBoot: true,
      ),
    );
    service.startService();
  }

  /// Start background service after termination
  @pragma('vm:entry-point')
  void onStart(ServiceInstance service) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Overlay Running",
        content: "Tap to return to the app",
      );
    }

    // Timer.periodic(Duration(seconds: 5), (timer) async {
    //   // final backgroundService = FlutterBackgroundService();
    //   // //
    //   // // bool isRunning = await backgroundService.isRunning();
    //   // // bool isRunning = await FlutterOverlayWindow.isActive();
    //   //
    //   // // if (!await FlutterOverlayWindow.isActive()) {
    //   // if (!await backgroundService.isRunning()) {
    //   //   timer.cancel();
    //   //   // stopBackgroundService();
    //   // }
    //
    //   bool isOverlayActive = await FlutterOverlayWindow.isActive();
    //   if (isOverlayActive == false) {
    //     await FlutterOverlayWindow.showOverlay(
    //       height: 1200,
    //       enableDrag: false,
    //       // alignment: OverlayAlignment.centerRight,
    //       alignment: OverlayAlignment.bottomCenter,
    //       positionGravity: PositionGravity.left,
    //     );
    //
    //     // If user doesn't accept within 30 seconds, remove the overlay
    //     Timer(Duration(seconds: 30), () async {
    //       await FlutterOverlayWindow.closeOverlay();
    //       timer.cancel();
    //       print('onStart Overlay removed, 30 seconds completed');
    //     });
    //   }
    // });
  }

  /// Start background service
  void startBackgroundService() {
    final service = FlutterBackgroundService();
    service.startService();
  }

  /// Stop background service
  void stopBackgroundService() {
    final service = FlutterBackgroundService();
    service.invoke("stop");
  }

  /// IOS background configuration
  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    return true;
  }

 */
