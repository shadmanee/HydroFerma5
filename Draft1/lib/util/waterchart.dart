import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../water+nutrient/water.dart';

class LineChart extends StatelessWidget {
  List<WaterUsage> data = [
    WaterUsage('Jan 21', 5),
    WaterUsage('Feb 21', 6),
    WaterUsage('Mar 21', 7),
    WaterUsage('Apr 21', 6),
    WaterUsage('May 21', 6),
    WaterUsage('Jun 21', 7),
    WaterUsage('Jul 21', 6),
    WaterUsage('Aug 21', 5),
    WaterUsage('Sep 21', 5),
    WaterUsage('Oct 21', 5),
    WaterUsage('Nov 21', 5),
    WaterUsage('Dec 21', 4),
    WaterUsage('Jan 22', 5),
    WaterUsage('Feb 22', 5),
    WaterUsage('Mar 22', 6),
    WaterUsage('Apr 22', 6),
    WaterUsage('May 22', 6),
    WaterUsage('Jun 22', 4),
    WaterUsage('Jul 22', 4),
    WaterUsage('Aug 22', 4),
    WaterUsage('Sep 22', 4),
    WaterUsage('Oct 22', 5),
    WaterUsage('Nov 22', 5),
    WaterUsage('Dec 22', 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(labelRotation: -90),
          primaryYAxis: CategoryAxis(title: AxisTitle(text: 'L/month')),
          legend: Legend(
            isVisible: true,
          ),
          onDataLabelTapped: (onTapArgs) => Navigator.push(
            context,
            PageTransition(
              curve: Curves.linear,
              type: PageTransitionType.bottomToTop,
              child: const ChartPage(),
            ),
          ),
          onAxisLabelTapped: (AxisLabelTapArgs args) {
            Navigator.push(
              context,
              PageTransition(
                curve: Curves.linear,
                type: PageTransitionType.bottomToTop,
                child: const ChartPage(),
              ),
            );
          },
          tooltipBehavior: TooltipBehavior(enable: false),
          series: <ChartSeries<WaterUsage, String>>[
            LineSeries<WaterUsage, String>(
              dataSource: data,
              xValueMapper: (WaterUsage Litres, _) => Litres.month,
              yValueMapper: (WaterUsage Litres, _) => Litres.Litres,
              name: 'Litres',
              // dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}

class WaterUsage {
  final String month;
  final double Litres;

  WaterUsage(this.month, this.Litres);
}
