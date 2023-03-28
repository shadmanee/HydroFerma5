import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../home/notifications.dart';

class ConnectedDevices extends StatefulWidget {
  const ConnectedDevices({Key? key}) : super(key: key);

  @override
  State<ConnectedDevices> createState() => _ConnectedDevicesState();
}

class _ConnectedDevicesState extends State<ConnectedDevices> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios, size: 24),
                  ),
                  const Expanded(
                    child: Text(
                      'Connected Devices',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 25),
                const Expanded(
                  child: Text(
                    'Water Quality Tester',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          curve: Curves.linear,
                          type: PageTransitionType.bottomToTop,
                          child: const ConnectedDevices(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_ios))
              ],
            ),
            const Divider(),
            Row(
              children: [
                const SizedBox(width: 25),
                const Expanded(
                  child: Text(
                    'Temperature & Humidity Sensor',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          curve: Curves.linear,
                          type: PageTransitionType.bottomToTop,
                          child: const Notifications(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_ios))
              ],
            ),
            const Divider(thickness: 0),
          ],
        ),
      ),
    );
  }
}
