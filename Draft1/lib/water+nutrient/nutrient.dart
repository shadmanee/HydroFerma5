import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hydroferma5/util/charts.dart';
import 'package:hydroferma5/test/test2.dart';
import 'package:hydroferma5/water+nutrient/water.dart';
import 'package:page_transition/page_transition.dart';

import '../home/message_screen.dart';
import '../home/notifications.dart';
import '../home/user.dart';
import '../util/sidebar.dart';

class Nutrient extends StatefulWidget {
  const Nutrient({Key? key}) : super(key: key);

  @override
  State<Nutrient> createState() => _NutrientState();
}

class _NutrientState extends State<Nutrient> {
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        Material(
                          child: TextButton(
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => const Water());
                              Navigator.pushReplacement(context, route);
                            },
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
                          shape: const Border(
                              bottom: BorderSide(
                                  color: Color(0xff3a3737), width: 3.0)),
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Nutrient",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff3a3737),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: StaggeredGrid.count(
                        crossAxisCount: 1,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 0.5,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Text(
                                          'Plant Name: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black38),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Text(
                                          'Coriander',
                                          style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.w100,
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: const [
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Text(
                                          'Nutrient List: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black38),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Text(
                                          'Phosphate, Potash',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w100,
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 0.5,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Text(
                                          'Plant Name: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black38),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Text(
                                          'Lettuce',
                                          style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.w100,
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: const [
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Text(
                                          'Nutrient List: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black38),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Text(
                                          'Phosphate, Potash',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w100,
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    DonutChartPage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
