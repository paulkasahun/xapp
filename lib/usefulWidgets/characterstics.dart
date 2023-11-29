import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:xapp/usefulWidgets/descriptor.dart';

class Characterstics extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final List<Descriptor> descriptor;
  final VoidCallback? onReadPressed;
  final VoidCallback? onWritePressed;
  final VoidCallback? onNotificationPressed;
  const Characterstics(
      {super.key,
      required this.characteristic,
      required this.descriptor,
      this.onReadPressed,
      this.onWritePressed,
      this.onNotificationPressed});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (context, snapshot) {
        final value = snapshot.data;
        Uint8List intBytes = Uint8List.fromList(value!.toList());
        List<double> floatList = intBytes.buffer.asFloat32List();
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Text(
                  (characteristic.uuid.toString().substring(4, 8) == "2a19")
                      ? "Temperature"
                      : "Humidity",
                ),*/
                (characteristic.uuid.toString().substring(4, 8) == "2a19")
                    ? Image.asset(
                        'asset/temp.png',
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'asset/hum.png',
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                Text(
                  (floatList.isEmpty)
                      ? "Refresh Please"
                      : floatList[0].toStringAsFixed(2),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.file_download,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                  ),
                  onPressed: onReadPressed,
                ),
                IconButton(
                  icon: Icon(Icons.file_upload,
                      color:
                          Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                  onPressed: onWritePressed,
                ),
                IconButton(
                  icon: Icon(
                      characteristic.isNotifying
                          ? Icons.sync_disabled
                          : Icons.sync,
                      color:
                          Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                  onPressed: onNotificationPressed,
                )
              ],
            ),
          ),
          children: descriptor,
        );
      },
    );
  }
}
