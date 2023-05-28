import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/scan_widget.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  Future<bool> bluetoothGranted() async {
    bool pgranted = await Permission.bluetooth.isGranted;
    if (pgranted) {
      bool? bgranted = await FlutterBluetoothSerial.instance.isEnabled;
      if (bgranted != null && bgranted) {
        setState(() {});
        return true;
      } else {
        setState(() {});
        return false;
      }
    } else {
      setState(() {});
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: FutureBuilder(
            future: bluetoothGranted(),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return const ScanWidget();
              } else {
                return Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.indigoAccent)),
                    onPressed: () async {
                      await Permission.bluetooth.request();
                      await Permission.bluetoothConnect.request();
                      await Permission.bluetoothScan.request();
                      await Permission.bluetoothAdvertise.request();

                      bool isBluetoothEnabled =
                          await Permission.bluetooth.isGranted;
                      if (isBluetoothEnabled) {
                        await FlutterBluetoothSerial.instance.requestEnable();
                        setState(() {});
                      }
                    },
                    child: const Text("Enable Bluetooth"),
                  ),
                );
              }
            }),
      ),
    );
  }
}
