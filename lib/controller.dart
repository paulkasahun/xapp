
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BlueController extends GetxController{
  FlutterBlue ble = FlutterBlue.instance;

  Future scandevices() async{
     if ( await Permission.bluetoothScan.request().isGranted){
      if(await Permission.bluetoothConnect.request().isGranted){
        ble.startScan(timeout:const Duration(seconds: 5) );
        ble.stopScan();
      }
     }


  }
  Stream<List<ScanResult>> get scanresult =>ble.scanResults;
 


}