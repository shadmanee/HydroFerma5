import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

late Map<dynamic, dynamic> lastRead;
late String temperature;
late String humidity;

class SensorDataPage extends StatefulWidget {
  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  @override
  void initState() {
    super.initState();
    getLastReading();
  }

  void getLastReading() async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('/sensor_data/');

    dbRef.onValue.listen((event) {
      List<dynamic>? readings = event.snapshot.value as List<dynamic>?;

      if (readings != null && readings.isNotEmpty) {
        Map<dynamic, dynamic>? lastReading =
            readings.last as Map<dynamic, dynamic>?;
        if (lastReading != null) {
          lastReading['reading_id'] = event.snapshot.key;
          lastRead = lastReading;
          setState(() {
            temperature = lastRead['temperature'].toString();
            humidity = lastRead['humidity'].toString();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Temperature: $temperature',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Humidity: $humidity',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
