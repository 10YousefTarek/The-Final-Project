import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../screens/smart_home_screen.dart';
import 'BluetoothDeviceListEntry.dart';

class ScanWidget extends StatefulWidget {
  final bool start;
  const ScanWidget({super.key, this.start = true});

  @override
  State<ScanWidget> createState() => _ScanWidgetState();
}

class _ScanWidgetState extends State<ScanWidget> {
  late StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = [];
  late bool isDiscovering;

  @override
  void initState() {
    super.initState();

    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    if (!isDiscovering) {
      setState(() {
        results.clear();
        isDiscovering = true;
      });

      _startDiscovery();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You can't refresh when still scanning")));
    }
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        bool inResult = false;
        for (var element in results) {
          if (element.device == r.device) {
            inResult = true;
          }
        }
        if (!inResult) {
          results.add(r);
        }
      });
    });

    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _restartDiscovery(),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, index) {
          BluetoothDiscoveryResult result = results[index];
          return BluetoothDeviceListEntry(
            device: result.device,
            rssi: result.rssi,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return SmartHomeScreen(server: result.device);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
