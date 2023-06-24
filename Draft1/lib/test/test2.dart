// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class DataPage extends StatefulWidget {
//   @override
//   _DataPageState createState() => _DataPageState();
// }
//
// class _DataPageState extends State<DataPage> {
//   late DatabaseReference _databaseRef;
//   final List _readings = [];
//   final List _temperature = [];
//   final List _water = [];
//   final List _humidity = [];
//   final List _pH = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the DatabaseReference
//     _databaseRef = FirebaseDatabase.instance.ref().child('sensor_data');
//
//     // Retrieve the most recent 20 sensor values
//     _databaseRef.orderByKey().limitToLast(20).onValue.listen((event) {
//       setState(() {
//         Map<dynamic, dynamic> values = event.snapshot.value as Map;
//         values.forEach((key, value) {
//           _readings.add(key);
//           _temperature.add(value['temperature']);
//           _water.add(value['water']);
//           _humidity.add(value['humidity']);
//           _pH.add(value['ph']);
//         });
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sensor Data'),
//       ),
//       body: ListView.builder(
//         itemCount: _readings.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text('Reading ID: ${index + 1}'),
//             subtitle: Text('Value: ${_water[index]}'),
//           );
//         },
//       ),
//     );
//   }
// }
