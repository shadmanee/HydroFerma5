import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:page_transition/page_transition.dart';

import '../home/notifications.dart';
import '../util/sidebar.dart';

class ConnectBluetooth extends StatefulWidget {
  const ConnectBluetooth({Key? key}) : super(key: key);

  @override
  State<ConnectBluetooth> createState() => _ConnectBluetoothState();
}

class _ConnectBluetoothState extends State<ConnectBluetooth> {
  bool _connecting = false;

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

  int notificationCount = 1;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset('images/logo-white.png'),
                    iconSize: 45,
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        iconSize: 35,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.bottomToTop,
                              child: Notifications(),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 10,
                        right: 8,
                        child: notificationCount == 0
                            ? Container()
                            : Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 15,
                            minHeight: 15,
                          ),
                          child: Text(
                            notificationCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.person),
                    iconSize: 35,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
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
                          buttonsBorderRadius:
                              BorderRadius.all(Radius.circular(10)),
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
            ),
          ],
        ),
      ),
    );
  }
}
