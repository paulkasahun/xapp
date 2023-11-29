import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:xapp/usefulWidgets/characterstics.dart';

class Service extends StatelessWidget {
  final BluetoothService service;
  final List<Characterstics> characterstics;
  const Service(
      {super.key, required this.service, required this.characterstics});

  @override
  Widget build(BuildContext context) {
    if (service.uuid.toString().toUpperCase().substring(4, 8) == 'A123') {
      return ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Services"),
            Text(
              '0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
            )
          ],
        ),
        children: characterstics,
      );
    } else {
      return const ListTile(
        title: Text(''),
      );
    }
  }
}
