import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ToggleLed extends StatefulWidget {
  const ToggleLed({super.key});

  @override
  State<ToggleLed> createState() => _ToggleLedState();
}

class _ToggleLedState extends State<ToggleLed> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? device;

  @override
  void initState() {
    super.initState();
    _discoverDevices();
  }

  Future<void> _discoverDevices() async {
    // Start scanning for Bluetooth devices
    flutterBlue.startScan();

    // Wait for a few seconds (you might want to adjust the duration)
    await Future.delayed(const Duration(seconds: 5));

    // Stop scanning
    flutterBlue.stopScan();

    // Get a list of discovered devices
    List<BluetoothDevice> devices = await flutterBlue.connectedDevices;

    // Assuming you have a reference to a BluetoothDevice (you might get it from the list)
    if (devices.isNotEmpty) {
      device = devices.first;
    }
  }

  Future<void> _toggleLED() async {
    if (device != null) {
      await device!.connect();

      // Discover services and characteristics
      List<BluetoothService> services = await device!.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid == Guid("19B10001-E8F2-537E-4F6C-D104768A1214")) {
            // Toggle the LED by writing a value
            characteristic.write([
              1
            ]); // You may need to adjust this value based on your Arduino code
          }
        }
      }

      await device!.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LED Control App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _toggleLED,
          child: const Text('Toggle LED'),
        ),
      ),
    );
  }
}
