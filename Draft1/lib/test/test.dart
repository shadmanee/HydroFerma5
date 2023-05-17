import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Map<dynamic, dynamic> lastRead = {};
String temperature = '';
String humidity = '';

class SensorDataPage extends StatefulWidget {
  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    setupSensorDataListener();
  }

  void setupSensorDataListener() {
    print('IN FUNCTION');
    dbRef = FirebaseDatabase.instance.ref().child('/sensor_data/');
    dbRef.onValue.listen((DatabaseEvent event) {
      print("Read DBREF");
      DataSnapshot snap = event.snapshot;
      print('Snapshot value: ${snap.value}');

      if (snap.value != null) {
        List<dynamic> readings = snap.value as List<dynamic>;

        if (readings.isNotEmpty) {
          Map<dynamic, dynamic> lastReading =
              readings.last as Map<dynamic, dynamic>;
          lastRead = lastReading;

          if (lastRead.containsKey('temperature')) {
            temperature = lastRead['temperature'].toString();
          } else {
            temperature = '';
          }

          if (lastRead.containsKey('humidity')) {
            humidity = lastRead['humidity'].toString();
          } else {
            humidity = '';
          }

          setState(() {});
        }
      }
    }, onError: (Object error) {
      print('NOT READING BECAUSE $error');
    });
  }

  // @override
  // void dispose() {
  //   dbRef.onValue.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Temperature: $temperature',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Humidity: $humidity',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
