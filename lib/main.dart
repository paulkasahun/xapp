import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/state_manager.dart';
import 'package:xapp/controller.dart';
import 'package:xapp/device_screen.dart';
import 'package:xapp/usefulWidgets/scan_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return const MyHomePage();
          }
          return BluetoothOffScreen(
            state: state,
          );
        },
      ),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  final BluetoothState? state;
  const BluetoothOffScreen({super.key, this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bluetooth_disabled,
              size: 200,
              color: Colors.white54,
            ),
            Text(
              "Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'Not available'}.",
              style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BluetoothDevice
      device; // assign this to the scanned device you want to connect
  FlutterBlue flutterBlue = FlutterBlue.instance;
  @override
  void initState() {
    super.initState();
    _discoverDevices();
  }
  /*
Future<void> _toggleLED() async {
    if (device != null) {
      await device.connect();

      // Discover services and characteristics
      List<BluetoothService> services = await device!.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid == Guid("19B10001-E8F2-537E-4F6C-D104768A1214")) {
            // Toggle the LED by writing a value
            characteristic.write([1]); // You may need to adjust this value based on your Arduino code
          }
        }
      }

      await device.disconnect();
    }
  }*/
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
      BluetoothDevice device = devices.first;
      // Discover services and characteristics
      List<BluetoothService> services = await device.discoverServices();
      // Print out services and characteristics
      for (var service in services) {
       // print("Service: ${service.uuid}");
        for (var characteristic in service.characteristics) {
          //print("Characteristic: ${characteristic.uuid}");
        }
      }
    }
  }

  obtainConnectionDialogeBox() {
    return showDialog(
        context: context,
        builder: (c) {
          return SimpleDialog(
            title: const Text(
              "Device Connection",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () => device.connect(),
                child: Text(
                  "Connect",
                  style: TextStyle(
                    color: Colors.grey[650],
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // selectImage();
                },
                child: Text(
                  'Disconect',
                  style: TextStyle(
                    color: Colors.grey[650],
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {},
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: StreamBuilder<bool>(
          initialData: false,
          stream: FlutterBlue.instance.isScanning,
          builder: (context, snapshot) {
            if (snapshot.data!) {
              return FloatingActionButton(
                onPressed: () => FlutterBlue.instance.stopScan(),
                child: const Icon(Icons.stop_circle_rounded),
              );
            } else {
              return FloatingActionButton(
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: const Duration(seconds: 7)),
                child: const Icon(Icons.search),
              );
            }
          },
        ),
        appBar: AppBar(
          title: Text(
            "Blue",
            style: TextStyle(color: Colors.grey[300]),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.pinkAccent, Colors.deepPurpleAccent],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0])),
          ),
        ),
        body: GetBuilder<BlueController>(
          init: BlueController(),
          builder: (BlueController controller) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<List<BluetoothDevice>>(
                    stream: Stream.periodic(const Duration(seconds: 2))
                        .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                    initialData: const [],
                    builder: (c, snapshot) => Column(
                      children: snapshot.data!
                          .map((d) => Card(
                                child: ListTile(
                                  title: Text(d.name),
                                  subtitle: Text(d.id.toString()),
                                  trailing: StreamBuilder<BluetoothDeviceState>(
                                    stream: d.state,
                                    initialData:
                                        BluetoothDeviceState.disconnected,
                                    builder: (c, snapshot) {
                                      if (snapshot.data ==
                                          BluetoothDeviceState.connected) {
                                        return ElevatedButton(
                                          child: const Text('OPEN'),
                                          onPressed: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      DeviceScreen(device: d))),
                                        );
                                      }
                                      return Text(snapshot.data.toString());
                                    },
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  //scanned result
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBlue.instance.scanResults,
                    initialData: const [],
                    builder: (context, snapshot) {
                      return Column(
                        children: snapshot.data!
                            .map(
                              (r) => ScanResultWidget(
                                result: r,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      r.device.connect();
                                      return DeviceScreen(device: r.device);
                                    },
                                  ));
                                },
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                  /*
                  StreamBuilder<List<ScanResult>>(
                    stream: controller.scanresult,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          padding: const EdgeInsets.only(bottom: 25),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * .68,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data![index];
                              return GestureDetector(
                                onTap: () {
                                  obtainConnectionDialogeBox();
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(data.device.name),
                                    subtitle: Text(data.device.id.id),
                                    trailing: Text(data.rssi.toString()),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text("Device not found"),
                        );
                      }
                    },
                  ),
                  */
                  const SizedBox(
                    height: 12,
                  ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     shadowColor:Colors.transparent ,
                  //     backgroundColor: Colors.cyanAccent,
                  //     padding: const EdgeInsets.symmetric(horizontal: 120,vertical: 20)
                  //   ),
                  //   onPressed: () => controller.scandevices(),
                  //   child: const Text("SCAN",)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
