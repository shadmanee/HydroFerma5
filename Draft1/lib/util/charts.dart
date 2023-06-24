import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<int> xValues = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19
  ];
  List<double> pHValues = [
    1.5,
    3.2,
    2.8,
    6.9,
    4.7,
    9.1,
    8.3,
    11.0,
    12.4,
    5.6,
    7.2,
    10.5,
    13.8,
    3.9,
    2.2,
    6.1,
    4.3,
    9.9,
    7.7,
    10.8
  ];
  List<double> tempValues = [
    26.8,
    31.2,
    27.6,
    28.9,
    30.4,
    29.7,
    34.2,
    32.6,
    33.1,
    25.9,
    26.3,
    30.8,
    33.8,
    27.3,
    28.5,
    25.5,
    29.1,
    31.6,
    34.8,
    35.0
  ];

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = List.generate(xValues.length, (index) {
      int x = xValues[index];
      double y1 = pHValues[index];
      double y2 =
          tempValues[index]; // Adding 5 to demonstrate different y values

      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: y1,
            width: 5,
            gradient:
                const LinearGradient(colors: [Colors.blue, Colors.lightBlue]),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: y2,
            width: 5,
            gradient:
                const LinearGradient(colors: [Colors.greenAccent, Colors.cyan]),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 40,
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
            ),
          ),
        ),
        const SizedBox(height: 20), // Adjust the height as needed
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Legends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 10,
                width: 10,
                color: Colors.blue,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'pH',
                style: TextStyle(color: Colors.blue),
              ),
              Expanded(child: Container()),
              Container(
                height: 10,
                width: 10,
                color: Colors.greenAccent,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'Water Temperature',
                style: TextStyle(color: Colors.greenAccent),
              )
            ],
          ),
        )
        // Add your legend widgets here
      ],
    );
  }
}

class DonutChartPage extends StatelessWidget {
  final List<double> nutrientPercentages = [25, 40, 35];
  final List<String> nutrientNames = ['Mg', 'P', 'K'];
  final List<Color> sectionColors = [
    const Color(0xff48BFA3),
    const Color(0xff6893C2),
    const Color(0x8e7C888F),
  ]; // Specific colors for each section

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5, // Adjust the aspect ratio to your preference
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(enabled: false),
          // Disable touch interactions
          startDegreeOffset: -90,
          // Adjust the starting degree offset
          centerSpaceRadius: 40,
          // Adjust the radius of the center hole
          sections: List.generate(
            nutrientPercentages.length,
            (index) {
              final isTouched =
                  index == 0; // Highlight the first section if needed

              return PieChartSectionData(
                color: sectionColors[index % sectionColors.length],
                // Assign specific color to each section
                value: nutrientPercentages[index],
                title:
                    '${nutrientNames[index]}\n${nutrientPercentages[index].toInt()}%',
                // Display the percentage as the title
                radius: 70,
                // Adjust the radius of the sections
                titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
          sectionsSpace: 0, // Adjust the spacing between sections
        ),
      ),
    );
  }
}

class AirTemperatureChart extends StatefulWidget {
  @override
  _AirTemperatureChartState createState() => _AirTemperatureChartState();
}

class _AirTemperatureChartState extends State<AirTemperatureChart> {
  late DatabaseReference _databaseRef;
  final List _readings = [];
  final List<double> _temperature = [];

  @override
  void initState() {
    super.initState();
    // Initialize the DatabaseReference
    _databaseRef = FirebaseDatabase.instance.ref().child('sensor_data');

    // Retrieve the most recent 20 sensor values
    _databaseRef.orderByKey().limitToLast(10).onValue.listen((event) {
      setState(() {
        Map<dynamic, dynamic> values = event.snapshot.value as Map;
        values.forEach((key, value) {
          _readings.add(key);
          _temperature.add(value['temperature']);
        });
      });
    });
  }

  double getMin(List<double> list) {
    List<double> copy = list;
    return copy[0];
  }

  double getMax(List<double> list) {
    List<double> copy = list;
    copy.reversed;
    return copy[0];
  }

  List<double> rangeIn(List<double> list) {
    List<double> result = [];
    result = list.getRange(0, 20).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: true),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            // bottomTitles: AxisTitles(
            //   axisNameWidget: const Text(
            //     'time (s)',
            //     style: TextStyle(fontSize: 10),
            //   ),
            //   sideTitles: SideTitles(
            //     showTitles: true,
            //     // getTitles: (value) => timeLabels[value.toInt()],
            //     getTitlesWidget: (value, title) => SideTitleWidget(
            //         axisSide: AxisSide.bottom,
            //         child: Text(
            //           '${_readings[value.toInt()]}',
            //           style: const TextStyle(fontSize: 3),
            //         )),
            //   ),
            // ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              )
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: _readings.length.toDouble() - 1,
          minY: 25,
          maxY: 25.05,
          lineBarsData: [
            createLineChartBarData(_temperature, Colors.red),
          ],
        ),
      ),
    );
  }

  LineChartBarData createLineChartBarData(List<double> values, Color c) {
    return LineChartBarData(
      spots: List.generate(
          values.length, (index) => FlSpot(index.toDouble(), values[index])),
      isCurved: true,
      color: c,
      barWidth: 2,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}

class WaterTemperatureChart extends StatefulWidget {
  @override
  _WaterTemperatureChartState createState() => _WaterTemperatureChartState();
}

class _WaterTemperatureChartState extends State<WaterTemperatureChart> {
  late DatabaseReference _databaseRef;
  final List _readings = [];
  final List<double> _water = [];

  @override
  void initState() {
    super.initState();
    // Initialize the DatabaseReference
    _databaseRef = FirebaseDatabase.instance.ref().child('sensor_data');

    // Retrieve the most recent 20 sensor values
    _databaseRef.orderByKey().limitToLast(10).onValue.listen((event) {
      setState(() {
        Map<dynamic, dynamic> values = event.snapshot.value as Map;
        values.forEach((key, value) {
          _readings.add(key);
          _water.add(value['water']);
        });
      });
    });
  }

  double getMin(List<double> list) {
    List<double> copy = list;
    return copy[0];
  }

  double getMax(List<double> list) {
    List<double> copy = list;
    copy.reversed;
    return copy[0];
  }

  List<double> rangeIn(List<double> list) {
    List<double> result = [];
    result = list.getRange(0, 20).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: true),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                )
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: _readings.length.toDouble() - 1,
          minY: 15,
          maxY: 15.05,
          lineBarsData: [
            createLineChartBarData(_water, Colors.deepPurple),
          ],
        ),
      ),
    );
  }

  LineChartBarData createLineChartBarData(List<double> values, Color c) {
    return LineChartBarData(
      spots: List.generate(
          values.length, (index) => FlSpot(index.toDouble(), values[index])),
      isCurved: true,
      color: c,
      barWidth: 2,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}

class HumidityChart extends StatefulWidget {
  @override
  _HumidityChartState createState() => _HumidityChartState();
}

class _HumidityChartState extends State<HumidityChart> {
  late DatabaseReference _databaseRef;
  final List _readings = [];
  final List<double> _humidity = [];

  @override
  void initState() {
    super.initState();
    // Initialize the DatabaseReference
    _databaseRef = FirebaseDatabase.instance.ref().child('sensor_data');

    // Retrieve the most recent 20 sensor values
    _databaseRef.orderByKey().limitToLast(10).onValue.listen((event) {
      setState(() {
        Map<dynamic, dynamic> values = event.snapshot.value as Map;
        values.forEach((key, value) {
          _readings.add(key);
          _humidity.add(value['humidity']);
        });
      });
    });
  }

  double getMin(List<double> list) {
    List<double> copy = list;
    return copy[0];
  }

  double getMax(List<double> list) {
    List<double> copy = list;
    copy.reversed;
    return copy[0];
  }

  List<double> rangeIn(List<double> list) {
    List<double> result = [];
    result = list.getRange(0, 20).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: true),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            // bottomTitles: AxisTitles(
            //   axisNameWidget: const Text(
            //     'time (s)',
            //     style: TextStyle(fontSize: 10),
            //   ),
            //   sideTitles: SideTitles(
            //     showTitles: true,
            //     // getTitles: (value) => timeLabels[value.toInt()],
            //     getTitlesWidget: (value, title) => SideTitleWidget(
            //         axisSide: AxisSide.bottom,
            //         child: Text(
            //           '${_readings[value.toInt()]}',
            //           style: const TextStyle(fontSize: 3),
            //         )),
            //   ),
            // ),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                )
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: _readings.length.toDouble() - 1,
          minY: 60,
          maxY: 60.06,
          lineBarsData: [
            createLineChartBarData(_humidity, Colors.green),
          ],
        ),
      ),
    );
  }

  LineChartBarData createLineChartBarData(List<double> values, Color c) {
    return LineChartBarData(
      spots: List.generate(
          values.length, (index) => FlSpot(index.toDouble(), values[index])),
      isCurved: true,
      color: c,
      barWidth: 2,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}

class PhChart extends StatefulWidget {
  @override
  _PhChartState createState() => _PhChartState();
}

class _PhChartState extends State<PhChart> {
  late DatabaseReference _databaseRef;
  final List _readings = [];
  final List<double> _ph = [];

  @override
  void initState() {
    super.initState();
    // Initialize the DatabaseReference
    _databaseRef = FirebaseDatabase.instance.ref().child('sensor_data');

    // Retrieve the most recent 20 sensor values
    _databaseRef.orderByKey().limitToLast(10).onValue.listen((event) {
      setState(() {
        Map<dynamic, dynamic> values = event.snapshot.value as Map;
        values.forEach((key, value) {
          _readings.add(key);
          _ph.add(value['ph']);
        });
      });
    });
  }

  double getMin(List<double> list) {
    List<double> copy = list;
    return copy[0];
  }

  double getMax(List<double> list) {
    List<double> copy = list;
    copy.reversed;
    return copy[0];
  }

  List<double> rangeIn(List<double> list) {
    List<double> result = [];
    result = list.getRange(0, 20).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: true),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameWidget: const Text(
                'time (s)',
                style: TextStyle(fontSize: 10),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                // getTitles: (value) => timeLabels[value.toInt()],
                getTitlesWidget: (value, title) => SideTitleWidget(
                    axisSide: AxisSide.bottom,
                    child: Text(
                      '${_readings[value.toInt()]}',
                      style: const TextStyle(fontSize: 3),
                    )),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: _readings.length.toDouble() - 1,
          minY: 5,
          maxY: 5.7,
          lineBarsData: [
            createLineChartBarData(_ph, CupertinoColors.systemOrange),
          ],
        ),
      ),
    );
  }

  LineChartBarData createLineChartBarData(List<double> values, Color c) {
    return LineChartBarData(
      spots: List.generate(
          values.length, (index) => FlSpot(index.toDouble(), values[index])),
      isCurved: true,
      color: c,
      barWidth: 2,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}

class ProgressBarChart extends StatelessWidget {
  final double progressPercentage;

  ProgressBarChart({required this.progressPercentage});

  @override
  Widget build(BuildContext context) {
    double progress = progressPercentage / 100;

    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${progressPercentage.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 0),
                          FlSpot(progress, 0),
                          const FlSpot(1, 0),
                        ],
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 8,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
