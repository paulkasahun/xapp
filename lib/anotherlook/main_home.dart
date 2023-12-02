// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:xapp/device_screen.dart';

// class MainHome extends StatelessWidget {
//   const MainHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: StreamBuilder<BluetoothState>(
//           stream: FlutterBlue.instance.state,
//           initialData: BluetoothState.unknown,
//           builder: (c, snapshot) {
//             final state = snapshot.data;
//             if (state == BluetoothState.on) {
//               return const FindDevicesScreen();
//             }
//             return BluetoothOffScreen(state: state);
//           }),
//     );
//   }
// }

// class BluetoothOffScreen extends StatelessWidget {
//   const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

//   final BluetoothState? state;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlue,
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const Icon(
//               Icons.bluetooth_disabled,
//               size: 200.0,
//               color: Colors.white54,
//             ),
//             Text(
//               'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FindDevicesScreen extends StatelessWidget {
//   const FindDevicesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Find Devices'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             StreamBuilder<List<ScanResult>>(
//               stream: FlutterBlue.instance.scanResults,
//               initialData: const [],
//               builder: (c, snapshot) => Column(
//                 children: snapshot.data!
//                     .map((result) => ListTile(
//                           title: Text(result.device.name == "" ? "No Name " : result.device.name),
//                           subtitle: Text(result.device.id.toString()),
//                           onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                             result.device.connect();
//                             return DeviceScreen(device: result.device);
//                           })),
//                         ))
//                     .toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: StreamBuilder<bool>(
//         stream: FlutterBlue.instance.isScanning,
//         initialData: false,
//         builder: (c, snapshot) {
//           if (snapshot.data!) {
//             return FloatingActionButton(
//               onPressed: () => FlutterBlue.instance.stopScan(),
//               backgroundColor: Colors.red,
//               child: const Icon(Icons.stop),
//             );
//           } else {
//             return FloatingActionButton(
//                 child: const Icon(Icons.search), onPressed: () => FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4)));
//           }
//         },
//       ),
//     );
//   }
// }
