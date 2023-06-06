import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hydroferma5/croprecommendation/search.dart';
import 'package:hydroferma5/home/user.dart';
import 'package:hydroferma5/lifecycle/lifecycle_cam.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../util/sidebar.dart';
import '../water+nutrient/water.dart';
import 'notifications.dart';

Map<dynamic, dynamic> lastRead = {};
double temperature = 25.67;
double humidity = 63.7;
double water = 27.44;
double ph = 6.1;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var notificationCount = 3; // TODO: Replace with actual notification count
  final pc = PanelController();
  String selectedModule = 'Water Supply';
  bool water_pump = false;
  bool nutrient_valve = true;

  String panelContent(String module) {
    switch (module) {
      case 'Water Supply':
        return 'Information about water and nutrient supply in the system.';
      case 'Water Change':
        return 'Information about last water change as well as the significance of changing water frequently in a hydroponic system.';
      default:
        return 'Information about crop recommendation using sensor data.';
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setupSensorDataListener();
  }

  void setupSensorDataListener() async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('/sensor_data/');

    dbRef.onValue.listen((event) {
      print("DBREEF");
      DataSnapshot snapshot = event.snapshot;
      print('Snapshot value: ${snapshot.value}');

      if (snapshot.value != null) {
        List<dynamic> readings = snapshot.value as List<dynamic>;

        if (readings.isNotEmpty) {
          Map<dynamic, dynamic> lastReading =
              readings.last as Map<dynamic, dynamic>;
          lastRead = lastReading;

          if (lastRead.containsKey('temperature')) {
            temperature = lastRead['temperature'];
          }

          if (lastRead.containsKey('humidity')) {
            humidity = lastRead['humidity'];
          }

          if (lastRead.containsKey('water')) {
            water = lastRead['water'];
            water = double.parse(water.toStringAsFixed(1));
          }

          if (lastRead.containsKey('ph')) {
            ph = lastRead['ph'];
            ph = double.parse(ph.toStringAsFixed(1));
          }

          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Colors.white,
      drawer: SidebarForHome(),
      body: SafeArea(
        child: SlidingUpPanel(
          controller: pc,
          backdropTapClosesPanel: true,
          backdropEnabled: true,
          color: Colors.transparent,
          minHeight: MediaQuery.of(context).size.height / 20,
          maxHeight: MediaQuery.of(context).size.height / 1.5,
          panel: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BarIndicator(),
                Container(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 12,
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: <Widget>[
                          const Center(
                            child: Text(
                              'Module : ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 30,
                            ),
                            child: DropdownButton<String>(
                              value: selectedModule,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedModule = value!;
                                });
                              },
                              items: <String>[
                                'Water Supply',
                                'Water Change',
                                'Crop Recommendation',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Expanded(child: Text(value)),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedModule,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              panelContent(selectedModule),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 40,
                        ),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Read More',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: Image.asset('images/logo-white.png'),
                      iconSize: 45,
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                    const Spacer(),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none),
                          iconSize: 35,
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
                        ),
                        Positioned(
                          top: 10,
                          right: 8,
                          child: notificationCount == 0
                              ? Container()
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 15,
                                    minHeight: 15,
                                  ),
                                  child: Text(
                                    notificationCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.person),
                      iconSize: 35,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.linear,
                            type: PageTransitionType.bottomToTop,
                            child: UserInfo(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 50),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1.75,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xffb1e2f3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '3h',
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.w200,
                                          color: Colors.black54),
                                    ),
                                    const Text(
                                      '9m',
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.w200,
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Since Last',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black45),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Water Change',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black45),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Water Pump',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black45),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        water_pump
                                            ? const Text(
                                                'ON',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.green),
                                              )
                                            : const Text(
                                                'OFF',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.red),
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xffb1e3d8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.thermostat,
                                          size: 40,
                                          color: Colors.black54,
                                        ),
                                        Text(
                                          '$temperature\u00B0C',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w300,
                                            color: (temperature >=
                                                        20) &
                                                    (temperature <=
                                                        25)
                                                ? Colors.black54
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              child: Icon(
                                                Icons.heat_pump_outlined,
                                                size: 15,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Text(
                                              '$humidity%',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300,
                                                  color: (40 <=
                                                              humidity) &
                                                          (65 >=
                                                              humidity)
                                                      ? Colors.black54
                                                      : Colors.red),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              child: Icon(
                                                Icons.water_drop_outlined,
                                                size: 15,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Text(
                                              '$water\u00B0C',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300,
                                                color: (water >=
                                                            16) &
                                                        (water <=
                                                            20)
                                                    ? Colors.black54
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1.75,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xffb1e2f3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            'pH',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w200,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text(
                                            '$ph',
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: const [
                                          Text(
                                            'TDS',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w200,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text(
                                            '2200',
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Nutrient',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black45),
                                          ),
                                          const SizedBox(width: 5),
                                          nutrient_valve
                                              ? const Text(
                                                  'ON',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.green),
                                                )
                                              : const Text(
                                                  'OFF',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.red),
                                                ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color(0xffb1e3d8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Plants',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3),
                                          child: Icon(
                                            Icons.grass_outlined,
                                            color: Color(0xff44b230),
                                            size: 16,
                                          ),
                                        ),
                                        Text(
                                          'Lettuce',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black45),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
        ),
      ),
    );
  }
}

class BarIndicator extends StatefulWidget {
  const BarIndicator({Key? key}) : super(key: key);

  @override
  State<BarIndicator> createState() => _BarIndicatorState();
}

class _BarIndicatorState extends State<BarIndicator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 6,
            height: 3,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(15))),
          )
        ],
      ),
    );
  }
}
