import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydroferma5/login+register/login/login.dart';
import 'package:hydroferma5/util/buttons.dart';
import 'package:hydroferma5/util/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Future<void> signInWithEmail(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     User? user = userCredential.user;
  //     if (user != null) {
  //       String? displayName = user.displayName;
  //       print('Signed in user: $displayName');
  //       username = displayName!;
  //     }
  //   } catch (e) {
  //     print('Sign-in error: $e');
  //   }
  // }

  String username = '';
  int notifications = 5;

  void getCurrentUserDisplayName() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      username = user.displayName!;
      print('Current user display name: $username');
    }
  }

  bool flag = false;

  bool checkUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        flag = false;
      } else {
        getCurrentUserDisplayName();
        flag = true;
      }
    });
    return flag;
  }

  Widget _hasNotification() {
    return notifications != 0
        ? Positioned(
            top: 8,
            left: 10,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Text(
                '$notifications',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : Container();
  }

  final List<String> items = ["Item 1", "Item 2", "Item 3", "Item 4"];
  final List<IconData> icons = [
    Icons.person,
    Icons.person,
    Icons.person,
    Icons.person
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xD3E6F6FF),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 55, left: 10, right: 10),
            height: 120,
            color: Color(0xD3E6F6FF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: IconButton(
                    icon: Image.asset(
                      'images/logo-white.png',
                    ),
                    iconSize: 50,
                    onPressed: () {},
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.person_rounded),
                    iconSize: 40,
                    onPressed: () {},
                  ),
                ),
                Container(
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications),
                        iconSize: 40,
                        onPressed: () {},
                      ),
                      _hasNotification(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 618,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildCard(icons[index], index.toString(), Colors.white24),
              staggeredTileBuilder: (int index) => index % 2 == 0
                  ? const StaggeredTile.count(2, 3.5)
                  : const StaggeredTile.count(2, 3),
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              padding: EdgeInsets.only(top: 5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String label, Color color) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: -1,
            offset: Offset(2, 2), // Shadow position
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              double _sliderValue = 0.5; // initial value of the slider
              return Container(
                height: MediaQuery.of(context).size.height * 0.3, // adjust height as needed
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Adjust the slider',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Slider(
                      value: _sliderValue,
                      onChanged: (double newValue) {
                        setState(() {
                          _sliderValue = newValue;
                        });
                      },
                      min: 0,
                      max: 1,
                      divisions: 10,
                      label: _sliderValue.toStringAsFixed(1),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                gradient: LinearGradient(
                  colors: CardColor(label),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                  size: 48,
                ),
                SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<Color> CardColor(String input) {
  if (input == "0" || input == "2") {
    return card2Colors;
  } else {
    return card1Colors;
  }
}
