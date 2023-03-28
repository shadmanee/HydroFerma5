import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../home/notifications.dart';
import '../home/user.dart';
import '../util/sidebar.dart';

class Crops extends StatefulWidget {
  const Crops({Key? key}) : super(key: key);

  @override
  State<Crops> createState() => _CropsState();
}

class _CropsState extends State<Crops> {
  List<String> crops = [
    "Tomato",
    "Green Wave",
    "Butter Head",
    "Iceberg Lettuce",
    "Romaine Lettuce",
    "Malabar Spinach",
    "Red Spinach",
    "Coriander",
    "Orchid",
    "Hydrangea",
    "Tomato",
    "Green Wave",
    "Butter Head",
    "Iceberg Lettuce",
    "Romaine Lettuce",
    "Malabar Spinach",
    "Red Spinach",
    "Coriander",
    "Orchid",
    "Hydrangea"
  ];
  int notificationCount = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                            "Search",
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
                                builder: (context) => const Recommended());
                            Navigator.pushReplacement(context, route);
                          },
                          child: const Text(
                            "Suggestions",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff3a3737),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black, // Set the color you want
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 300,
                    child: ListView.builder(
                      itemCount: crops.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(crops[index]),
                          onTap: () {
                            // do something when the item is tapped
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Recommended extends StatelessWidget {
  const Recommended({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.only(
                        left: 32, right: 32, top: 30, bottom: 50),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'San Francisco',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(
                              Icons.wb_sunny,
                              size: 24,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Sunny, 22°C',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'HUMIDITY',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: const [
                                    Text(
                                      '80%',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(Icons.arrow_upward, color: Colors.red)
                                  ],
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'WIND',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: const [
                                    Text(
                                      '8 km/h',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(Icons.wind_power, color: Colors.grey)
                                  ],
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'UV INDEX',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Text(
                                      '5',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Image.asset('images/uv-index.png',
                                        width: 25,
                                        height: 25,
                                        color: const Color(0xff2d2d2d))
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Divider(thickness: 2),
                        Row(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(bottom: 20, top: 20),
                              child: const Text(
                                'Recommended: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: Color(0xff6e6c6c),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: const Text(
                                'Coriander',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: const [
                            Text(
                              'Malabar Spinach',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
