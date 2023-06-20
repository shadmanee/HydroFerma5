import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: LineChart(LineChartData(
            borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.white, width: 2)),
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(color: Colors.white, strokeWidth: 1);
              },
              drawVerticalLine: true,
              getDrawingVerticalLine: (value) {
                return FlLine(color: Colors.white, strokeWidth: 1);
              },
            ),
            titlesData: FlTitlesData(
              show: true,
            ),
            maxX: 8,
            maxY: 8,
            minY: 0,
            minX: 0,
            lineBarsData: [
              LineChartBarData(
                  spots: [
                    const FlSpot(0, 0),
                    const FlSpot(5, 5),
                    const FlSpot(7, 6),
                    const FlSpot(8, 4),
                  ],
                  isCurved: true,
                  gradient: const LinearGradient(colors: [
                    Colors.black12,
                    Colors.white70,
                    Colors.white
                  ]),
                  barWidth: 5,
                  belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                          colors: gradientColors
                              .map((e) => e.withOpacity(0.3))
                              .toList())))
            ])),
      ),
    );
  }
}
