import 'package:flutter/material.dart';
import 'package:new_overlay_rnd/components/overlay_service.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        detachedCallBack: () async => OverlayService.showBubbleOverlay(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver App")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => OverlayService.showBookingOverlay(),
          child: Text("Simulate New Booking"),
        ),
      ),
    );
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Function? detachedCallBack;
  LifecycleEventHandler({this.detachedCallBack});
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && detachedCallBack != null) {
      detachedCallBack!();
    }
  }
}
