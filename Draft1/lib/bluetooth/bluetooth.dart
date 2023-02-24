import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ConnectBluetooth extends StatefulWidget {
  const ConnectBluetooth({Key? key}) : super(key: key);

  @override
  State<ConnectBluetooth> createState() => _ConnectBluetoothState();
}

class _ConnectBluetoothState extends State<ConnectBluetooth> {
  bool _connecting = false;

  // late BluetoothDevice device;
  // late BluetoothState state;
  // late BluetoothDeviceState deviceState;
  // late StreamSubscription scanSubscription;

  FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  void initState() {
    super.initState();
    FlutterBlue.instance.state.listen((state) {
      if (state == BluetoothState.off) {
        setState(() {
          _connecting = true;
        });
        print(_connecting);
      } else if (state == BluetoothState.on) {
        _connecting = false;
      }
    });
  }

  void scanForDevices() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    var subscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });
    flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          margin: EdgeInsets.all(40.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(300),
              color: CupertinoColors.systemGrey5),
          child: IconButton(
            onPressed: () {
              if (_connecting) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.info,
                  animType: AnimType.bottomSlide,
                  btnOkOnPress: () {},
                  btnOkColor: Color(0x7C888F8E),
                  buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
                  body: SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        'Bluetooth turned off.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 20),
                      ),
                    ),
                  ),
                  // autoHide: const Duration(seconds: 3),
                ).show();
              } else {
                scanForDevices();
              }
            },
            icon: Icon(Icons.bluetooth),
            iconSize: 250,
          ),
        ),
      ),
    );
  }
}
