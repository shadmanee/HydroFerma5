// import 'dart:async';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
//
// late double current;
//
// class MyTable extends StatefulWidget {
//   const MyTable({Key? key}) : super(key: key);
//
//   @override
//   State<MyTable> createState() => _MyTableState();
// }
//
// class _MyTableState extends State<MyTable> {
//   late Query dbRef;
//   DatabaseReference reference =
//       FirebaseDatabase.instance.ref().child('/sensor_data/');
//
//   List<Map> readings = [];
//
//   @override
//   void initState() {
//     super.initState();
//     dbRef = FirebaseDatabase.instance
//         .ref()
//         .child('/sensor_data/')
//         .orderByKey()
//         .limitToLast(100);
//
//     dbRef.onChildAdded.listen(_onEntryAdded);
//     dbRef.onChildChanged.listen(_onEntryChanged);
//     dbRef.onChildRemoved.listen(_onEntryRemoved);
//   }
//
//   void _onEntryAdded(DatabaseEvent event) {
//     setState(() {
//       Map reading = event.snapshot.value as Map;
//       reading['reading_id'] = event.snapshot.key;
//       current = reading['reading_id'];
//       readings.add(reading);
//     });
//   }
//
//   void _onEntryChanged(DatabaseEvent event) {
//     setState(() {
//       Map reading = event.snapshot.value as Map;
//       reading['reading_id'] = event.snapshot.key;
//       current = reading['reading_id'];
//       int index = readings
//           .indexWhere((element) => element['reading_id'] == event.snapshot.key);
//       readings[index] = reading;
//     });
//   }
//
//   void _onEntryRemoved(DatabaseEvent event) {
//     setState(() {
//       readings.removeWhere(
//           (element) => element['reading_id'] == event.snapshot.key);
//     });
//   }
//
//   Future<double?> getLastReading() async {
//     DatabaseReference dbRef =
//         FirebaseDatabase.instance.ref().child('/sensor_data/');
//
//     DataSnapshot snapshot =
//         (await dbRef.orderByKey().limitToLast(1).once()) as DataSnapshot;
//
//     Map? reading = snapshot.value as Map?;
//
//     if (reading != null) {
//       reading['reading_id'] = snapshot.key;
//     }
//
//     return reading!['reading_id'];
//   }
//
//   Widget listItem({required Map reading}) {
//     return Container(
//       alignment: Alignment.center,
//       margin: const EdgeInsets.all(10),
//       padding: const EdgeInsets.all(10),
//       height: 110,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20.0),
//         gradient: const LinearGradient(
//           colors: [Color(0xffddd6f3), Color(0xffc6bbef)],
//           begin: Alignment.topLeft,
//           end: Alignment.topRight,
//         ),
//       ),
//       child: ListTile(
//         leading: Text(
//           reading['reading_id'].toString(),
//           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
//         ),
//         title: Text(
//           "Temperature: ${reading['temperature']}\u{00B0}C",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w400,
//             color:
//                 reading['temp_meter'] == "green" ? Colors.black54 : Colors.red,
//           ),
//         ),
//         subtitle: Text(
//           "Humidity: ${reading['humidity']}%",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//             color:
//                 reading['hum_meter'] == "green" ? Colors.black54 : Colors.red,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final ScrollController _controller = ScrollController();
//
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Text(
//                     'Sensor Data',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: SizedBox(
//                 height: double.infinity,
//                 child: FirebaseAnimatedList(
//                   controller: _controller, // attach the ScrollController
//                   reverse: true,
//                   query: dbRef,
//                   itemBuilder: (BuildContext context, DataSnapshot snapshot,
//                       Animation<double> animation, int index) {
//                     Map reading = snapshot.value as Map;
//                     reading['reading_id'] = snapshot.key;
//
//                     return listItem(reading: reading);
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color(0xfffaaca8),
//         foregroundColor: Colors.black54,
//         onPressed: () {
//           _controller.animateTo(_controller.position.maxScrollExtent,
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.easeInOut);
//         },
//         child: const Icon(Icons.arrow_upward),
//       ),
//     );
//   }
// }
