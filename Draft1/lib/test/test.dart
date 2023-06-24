import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

late double current;

class FiChartPage extends StatefulWidget {
  const FiChartPage({Key? key}) : super(key: key);

  @override
  _FiChartPageState createState() => _FiChartPageState();
}

class _FiChartPageState extends State<FiChartPage> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

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
        .limitToLast(50);

    dbRef.onChildAdded.listen(_onEntryAdded);
  }

  void _onEntryAdded(DatabaseEvent event) {
    setState(() {
      Map reading = event.snapshot.value as Map;
      reading['reading_id'] = event.snapshot.key;
      current = reading['reading_id'];
      readings.add(reading);
    });
    print("READING: $readings[0]\n\n\n");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: FlGridData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  show: false,
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey[800]!,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        if (flSpot.x >= 0 &&
                            flSpot.x < readings.length &&
                            flSpot.y >= 0 &&
                            flSpot.y < readings.length) {
                          final index = flSpot.x.toInt();
                          return LineTooltipItem(
                            'Reading Number: ${index + 1}\nReading: ${readings[index]['reading_id'].toStringAsFixed(2)}',
                            const TextStyle(color: Colors.white),
                          );
                        }
                        return null;
                      }).toList();
                    },
                  ),
                  touchCallback:
                      (FlTouchEvent touchEvent, LineTouchResponse? touchResponse) {},
                  handleBuiltInTouches: true,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(readings.length, (index) {
                      return FlSpot(index.toDouble(), readings[index]['reading_id']);
                    }),
                    isCurved: true,
                    gradient: const LinearGradient(colors: [
                      Colors.black12,
                      Colors.white70,
                      Colors.white,
                    ]),
                    barWidth: 5,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: gradientColors
                            .map((e) => e.withOpacity(0.3))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
