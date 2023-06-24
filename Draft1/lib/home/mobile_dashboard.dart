import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hydroferma5/croprecommendation/search.dart';
import 'package:hydroferma5/home/user.dart';
import 'package:hydroferma5/lifecycle/lifecycle_cam.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../ml_strmlt/webview.dart';
import '../util/charts.dart';
import '../util/sidebar.dart';
import '../water+nutrient/water.dart';
import 'noti.dart';
import 'notifications.dart';
import 'message_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var notificationCount = 3; // TODO: Replace with actual notification count
  final pc = PanelController();
  String selectedModule = 'Nutrient Supply';
  String nutrientValve = "nothing";
  bool waterChange = false;
  bool locChange = false;

  Widget panelContent(String module) {
    switch (module) {
      case 'Nutrient Supply':
        return Column(
          children: <Widget>[
            Text(
              'Hydroferma takes nutrient supply to the next level with its advanced hydroponic system. By precisely controlling and delivering the optimal blend of nutrients directly to the plants\' root systems, Hydroferma ensures they receive the perfect balance of essential elements for healthy growth. This innovative approach eliminates the need for soil and enables plants to thrive in a soilless environment. The nutrient supply system in Hydroferma not only maximizes plant nutrition but also minimizes waste, making it an environmentally sustainable solution for efficient and productive plant cultivation.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      case 'Water Change':
        return Text(
          'Hydroferma incorporates an intelligent water change decision-making system that enhances plant health and conserves water resources. Using advanced sensors and data analysis, the system determines the optimal timing for water changes based on factors such as moisture levels, nutrient concentrations, and plant growth stage. When a water change is required, Hydroferma sends a timely notification to the user through the mobile app, ensuring that they are aware of the need for action. This proactive approach not only minimizes water wastage but also maximizes plant productivity by maintaining the ideal hydration levels for each plant. With Hydroferma\'s water change decision and notification feature, users can effortlessly maintain an optimal growing environment for their plants while promoting sustainable water management practices.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.grey[600],
          ),
        );
      case 'Environment Change':
        return Text(
          'Hydroferma incorporates an intelligent environment change decision and notification system, ensuring the ideal growing conditions for your plants. By monitoring various parameters like temperature, humidity, and light intensity, the system analyzes the data and makes informed decisions to create an optimal environment. If any deviations are detected, Hydroferma sends real-time notifications to your mobile device, keeping you updated on any necessary adjustments. This proactive approach allows you to take prompt action, maintaining the perfect growing conditions for your plants and maximizing their potential yield. With Hydroferma, you can rest assured that your plants are always receiving the care they need for healthy and thriving growth.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.grey[600],
          ),
        );
      default:
        return Text(
          'Hydroferma employs an advanced lifecycle stage classification decision system, ensuring precise monitoring and care for your plants at every growth stage. Using machine learning algorithms and sensor data, the system accurately identifies the lifecycle stage of each plant, such as germination, vegetative growth, flowering, or fruiting. This classification enables Hydroferma to provide tailored recommendations and adjustments for each specific stage, optimizing nutrient supply, water usage, and environmental conditions. By adapting to the unique needs of each growth phase, Hydroferma ensures that your plants receive the right support at the right time, leading to enhanced growth, improved yield, and overall plant health. With Hydroferma\'s intelligent lifecycle stage classification, you can achieve remarkable results in your plant cultivation endeavors.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.grey[600],
          ),
        );
    }
  }

  NotificationServices notificationServices = NotificationServices();

// Call the initLocalNotifications method with a RemoteMessage object
  void initializeNotifications(BuildContext context) async {
    // RemoteMessage message = RemoteMessage(
    //   // Populate the RemoteMessage object with the necessary information
    //   // from the received FCM message
    //   data: {
    //     'type': 'msg',
    //     'id': '123456789',
    //   },
    //   notification: RemoteNotification(
    //     title: 'Notification Title',
    //     body: 'Notification Body',
    //   ),
    // );

    // Call the initLocalNotifications method
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late DatabaseReference _sensorDataRef,
      _valveStatusRef,
      _changeWater,
      _changeLoc;
  int latestReading = 0;
  double temperature = 25.67;
  double water = 26.1;
  double humidity = 66.7;
  double ph = 5.4;

  void _startListeningToLatestReading() {
    _sensorDataRef.orderByKey().limitToLast(1).onValue.listen((event) {
      if (event.snapshot.exists) {
        final Map<dynamic, dynamic>? sensorData = event.snapshot.value as Map?;
        if (sensorData != null) {
          final latestReadingKey = sensorData.keys.first;
          final latestReadingData = sensorData[latestReadingKey];
          if (latestReadingData != null && latestReadingData is Map) {
            setState(() {
              latestReading = int.parse(latestReadingKey);
              temperature = latestReadingData['temperature'] as double;
              humidity = latestReadingData['humidity'] as double;
              water = latestReadingData['water'] as double;
              ph = latestReadingData['ph'] as double;
            });
          }
        }
      }
    });
  }

  void _startListeniingToValveStatus() {
    _valveStatusRef.orderByKey().limitToLast(1).onValue.listen((event) {
      _valveStatusRef = FirebaseDatabase.instance.ref().child('valve/valve/');
      _valveStatusRef.onValue.listen((event) {
        final valveStatus = event.snapshot.value as String?;
        setState(() {
          nutrientValve = valveStatus ?? '';
        });
      });
    });
  }

  void _startListeniingToChangeWater() {
    _changeWater.orderByKey().limitToLast(1).onValue.listen((event) {
      _changeWater =
          FirebaseDatabase.instance.ref().child('change_water/change_water/');
      _changeWater.onValue.listen((event) {
        final changeWater = event.snapshot.value as String?;
        setState(() {
          waterChange = changeWater == 'REQ' ? true : false;
        });
      });
    });
  }

  void _startListeniingToChangeLoc() {
    _changeLoc.orderByKey().limitToLast(1).onValue.listen((event) {
      _changeLoc =
          FirebaseDatabase.instance.ref().child('change_loc/change_loc/');
      _changeLoc.onValue.listen((event) {
        final changeLoc = event.snapshot.value as String?;
        setState(() {
          locChange = changeLoc == 'REQ' ? true : false;
        });
      });
    });
  }

  late MyWebView myWebView;

  @override
  void initState() {
    super.initState();
    myWebView = MyWebView("http://localhost:8501");
    _sensorDataRef = FirebaseDatabase.instance.ref().child('sensor_data');
    _startListeningToLatestReading();
    _valveStatusRef = FirebaseDatabase.instance.ref().child('valve/valve');
    _startListeniingToValveStatus();
    _changeWater =
        FirebaseDatabase.instance.ref().child('change_water/change_water');
    _startListeniingToChangeWater();
    _changeLoc = FirebaseDatabase.instance.ref().child('change_loc/change_loc');
    _startListeniingToChangeLoc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Colors.white,

      drawer: const SidebarForHome(),
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
            child: ListView(
              // mainAxisSize: MainAxisSize.min,
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
                                'Nutrient Supply',
                                'Water Change',
                                'Environment Change',
                                'Lifecycle Stage',
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
                            child: panelContent(selectedModule),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 40,
                        ),
                      ),
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
                            RemoteMessage message = const RemoteMessage(
                              data: {
                                'type': 'msg',
                                'id': '12345678',
                                'title': 'Notification Title',
                                'body': 'Notification Body',
                              },
                              notification: RemoteNotification(),
                            );
                            notificationServices.handleMessage(
                                context, message);
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
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        children: [
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1.5,
                            child: Shimmer(
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
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.thermostat,
                                            size: 32,
                                            color: Colors.black54,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${temperature.toStringAsFixed(2)}\u00B0C',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                              color: (temperature! >= 20) &
                                                      (temperature! <= 25)
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
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.heat_pump_outlined,
                                            size: 32,
                                            color: Colors.black54,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${humidity.toStringAsFixed(2)}%',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300,
                                                color: (40 <= humidity!) &
                                                        (65 >= humidity!)
                                                    ? Colors.black54
                                                    : Colors.red),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.water_drop_outlined,
                                            size: 32,
                                            color: Colors.black54,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${water.toStringAsFixed(2)}\u00B0C',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                              color: (water! >= 16) &
                                                      (water! <= 20)
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
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.multiline_chart,
                                            size: 32,
                                            color: Colors.black54,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            ph.toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 0.8,
                            child: Shimmer(
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
                                        children: const [
                                          Text(
                                            'Nutrient Supply',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black45),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          nutrientValve == "ON"
                                              ? Text(
                                                  nutrientValve,
                                                  style: const TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.green),
                                                )
                                              : Text(
                                                  nutrientValve,
                                                  style: const TextStyle(
                                                      fontSize: 24,
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
                            mainAxisCellCount: 1.5,
                            child: Shimmer(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Wrap(
                                              children: const [
                                                Text(
                                                  'Water Change',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black45),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            waterChange
                                                ? const Text(
                                                    'Required',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.red),
                                                  )
                                                : const Text(
                                                    'Not Required',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.green),
                                                  ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Location Change',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black45),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            locChange
                                                ? const Text(
                                                    'Required',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.red),
                                                  )
                                                : const Text(
                                                    'Not Required',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.green),
                                                  ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 0.8,
                            child: Shimmer(
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
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => super.widget),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    AirTemperatureChart(),
                    WaterTemperatureChart(),
                    HumidityChart(),
                    PhChart(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Legends',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Air Temperature',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Water Temperature',
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            color: Colors.green,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Humidity',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            color: CupertinoColors.systemOrange,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'pH',
                            style:
                                TextStyle(color: CupertinoColors.systemOrange),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 200),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 6,
            height: 3,
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(15))),
          )
        ],
      ),
    );
  }
}
