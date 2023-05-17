import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

late double current;

class SystemOptions extends StatefulWidget {
  const SystemOptions({Key? key}) : super(key: key);

  @override
  State<SystemOptions> createState() => _SystemOptionsState();
}

class _SystemOptionsState extends State<SystemOptions> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  BackButton(),
                  Text(
                    'Connected System Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              OptionTile(
                title: 'Sensors',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyTable()),
                  );
                },
              ),
              OptionTile(
                title: 'Water Control',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WaterControlPage()),
                  );
                },
              ),
              OptionTile(
                title: 'Nutrient Control',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NutrientControlPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const OptionTile({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onPressed,
    );
  }
}

class WaterControlPage extends StatefulWidget {
  const WaterControlPage({super.key});

  @override
  _WaterControlPageState createState() => _WaterControlPageState();
}

class _WaterControlPageState extends State<WaterControlPage> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("WATER PUMP",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700))
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isTapped = !_isTapped;
                  });
                },
                child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isTapped ? Colors.red : Colors.green,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: _isTapped
                          ? const Text("OFF", style: TextStyle(fontSize: 30))
                          : const Text("ON", style: TextStyle(fontSize: 30)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NutrientControlPage extends StatefulWidget {
  const NutrientControlPage({super.key});

  @override
  _NutrientControlPageState createState() => _NutrientControlPageState();
}

class _NutrientControlPageState extends State<NutrientControlPage> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("NUTRIENT VALVE",
                      style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.w700))
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isTapped = !_isTapped;
                  });
                },
                child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isTapped ? Colors.red : Colors.green,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: _isTapped
                          ? const Text("OFF", style: TextStyle(fontSize: 30))
                          : const Text("ON", style: TextStyle(fontSize: 30)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTable extends StatefulWidget {
  const MyTable({Key? key}) : super(key: key);

  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  late Query dbRef;
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('/sensor_data/');

  List<Map> readings = [];

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance
        .ref()
        .child('/sensor_data/')
        .orderByKey()
        .limitToLast(100);

    dbRef.onChildAdded.listen(_onEntryAdded);
    dbRef.onChildChanged.listen(_onEntryChanged);
    dbRef.onChildRemoved.listen(_onEntryRemoved);
  }

  void _onEntryAdded(DatabaseEvent event) {
    setState(() {
      Map reading = event.snapshot.value as Map;
      reading['reading_id'] = event.snapshot.key;
      current = reading['reading_id'];
      readings.add(reading);
    });
  }

  void _onEntryChanged(DatabaseEvent event) {
    setState(() {
      Map reading = event.snapshot.value as Map;
      reading['reading_id'] = event.snapshot.key;
      current = reading['reading_id'];
      int index = readings
          .indexWhere((element) => element['reading_id'] == event.snapshot.key);
      readings[index] = reading;
    });
  }

  void _onEntryRemoved(DatabaseEvent event) {
    setState(() {
      readings.removeWhere(
          (element) => element['reading_id'] == event.snapshot.key);
    });
  }

  Future<double?> getLastReading() async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('/sensor_data/');

    DataSnapshot snapshot =
        (await dbRef.orderByKey().limitToLast(1).once()) as DataSnapshot;

    Map? reading = snapshot.value as Map?;

    if (reading != null) {
      reading['reading_id'] = snapshot.key;
    }

    return reading!['reading_id'];
  }

  Widget listItem({required Map reading}) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: const LinearGradient(
          colors: [Color(0xffddd6f3), Color(0xffc6bbef)],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
      child: ListTile(
        leading: Text(
          reading['reading_id'].toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Temperature: ${reading['temperature']}\u{00B0}C",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
            Text(
              "Water Temperature: ${double.parse(reading['water'].toStringAsFixed(1))}\u{00B0}C",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
            Text(
              "Humidity: ${reading['humidity']}%",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _controller = ScrollController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Sensor Data',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: FirebaseAnimatedList(
                  controller: _controller, // attach the ScrollController
                  reverse: true,
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map reading = snapshot.value as Map;
                    reading['reading_id'] = snapshot.key;

                    return listItem(reading: reading);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xfffaaca8),
        foregroundColor: Colors.black54,
        onPressed: () {
          _controller.animateTo(_controller.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
