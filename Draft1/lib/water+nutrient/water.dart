import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hydroferma5/bluetooth/connected.dart';
import 'package:hydroferma5/util/sidebar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tiny_charts/tiny_charts.dart';

import '../home/notifications.dart';
import '../home/user.dart';
import '../util/waterchart.dart';
import 'nutrient.dart';

class Water extends StatefulWidget {
  const Water({Key? key}) : super(key: key);

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  int notificationCount = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Sidebar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                          child: const UserInfo(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        Material(
                          shape: const Border(
                              bottom: BorderSide(
                                  color: Color(0xff3a3737), width: 3.0)),
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Water",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff3a3737),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          child: TextButton(
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => const Nutrient());
                              Navigator.pushReplacement(context, route);
                            },
                            child: const Text(
                              "Nutrient",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff3a3737),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 50),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1.5,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xffE6F2FE),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '4.7',
                                    style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.grey[600]),
                                  ),
                                  const Text(
                                    'L/m2/day',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black45),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Current Water',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black38),
                                  ),
                                  const Text(
                                    'Consumption',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black38),
                                  )
                                ],
                              ),
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1.5,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xffE6F2FE),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '3h',
                                    style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.grey[600]),
                                  ),
                                  Text(
                                    '9m',
                                    style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Since Last',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black45),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Water Change',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black45),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "Usage of Water from Jan '21 - Nov '22",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  curve: Curves.linear,
                                  type: PageTransitionType.bottomToTop,
                                  child: const ChartPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.show_chart),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 300,
                      child: LineChart(),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        const Text(
                          'Connected Devices',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  curve: Curves.linear,
                                  type: PageTransitionType.bottomToTop,
                                  child: const ConnectedDevices(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward_ios))
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        const Text(
                          'Alerts & Notifications',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        IconButton(
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
                            icon: const Icon(Icons.arrow_forward_ios))
                      ],
                    ),
                    const Divider(thickness: 0),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, size: 30),
              )
            ],
          ),
          Column(
            children: [
              const Text(
                'Water Usage',
                style: TextStyle(fontSize: 30),
              ),
              const Text(
                "Jan '21 - Nov '22",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 400,
                child: LineChart(),
              ),
            ],
          )
        ],
      )),
    );
  }
}
