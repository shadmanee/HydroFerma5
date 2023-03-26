import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydroferma5/bluetooth/bluetooth.dart';
import 'package:hydroferma5/home/mobile_dashboard.dart';

import '../login+register/login/login.dart';
import '../water+nutrient/water.dart';

class Sidebar extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> fetchUsername() async {
    return "John Doe"; // Replace with actual username
  }

  @override
  Widget build(BuildContext context) {
    void handleLogout() async {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        print(e);
      }
    }

    bool isRouteAlreadyInStack(BuildContext context, String routeName) {
      bool isAlreadyInStack = false;
      Navigator.of(context).popUntil((route) {
        if (route.settings.name == routeName) {
          isAlreadyInStack = true;
          return true;
        } else {
          return false;
        }
      });
      return isAlreadyInStack;
    }

    return Drawer(
      backgroundColor: Color(0xff89B6DC),
      child: FutureBuilder(
        future: fetchUsername(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching user data'),
            );
          } else {
            return ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xff89B6DC),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.dstATop),
                      image: AssetImage('images/amader-user.jpg'),
                    ),
                  ),
                  accountName: Text(_auth.currentUser!.displayName!),
                  accountEmail: Text(_auth.currentUser!.email!),
                  currentAccountPicture: Container(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('images/amader-user.jpg'),
                    ),
                  ),
                ),
                Column(
                  children: [
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xff52799b);
                            }
                            return Color(0xff6CA3D1);
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                (6.0),
                              ),
                            ),
                          ),
                        ),
                        child: Text('Water & Nutrient Supply',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Route route =
                              MaterialPageRoute(builder: (context) => Water());
                          Navigator.push(context, route);
                        },
                      ),
                    ),
                    Divider(),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xff52799b);
                            }
                            return Color(0xff6CA3D1);
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                (6.0),
                              ),
                            ),
                          ),
                        ),
                        child: Text('Power Usage',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Route route =
                              MaterialPageRoute(builder: (context) => Water());
                          Navigator.push(context, route);
                        },
                      ),
                    ),
                    Divider(),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xff52799b);
                            }
                            return Color(0xff6CA3D1);
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                (6.0),
                              ),
                            ),
                          ),
                        ),
                        child: Text('Crop Recommendation',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Route route =
                              MaterialPageRoute(builder: (context) => Water());
                          Navigator.push(context, route);
                        },
                      ),
                    ),
                    Divider(),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xff52799b);
                            }
                            return Color(0xff6CA3D1);
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                (6.0),
                              ),
                            ),
                          ),
                        ),
                        child: Text('Lifecycle',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Route route =
                              MaterialPageRoute(builder: (context) => Water());
                          Navigator.push(context, route);
                        },
                      ),
                    ),
                    Divider(),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xff52799b);
                            }
                            return Color(0xff6CA3D1);
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                (6.0),
                              ),
                            ),
                          ),
                        ),
                        child: Text('Connect System',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConnectBluetooth()));
                        },
                      ),
                    ),
                    Divider(),
                    ListTile(
                      trailing: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Home",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        // TODO: Handle home button tap
                      },
                    ),
                    ListTile(
                      trailing: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Settings",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        // TODO: Handle settings button tap
                      },
                    ),
                    ListTile(
                      trailing: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Logout",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        handleLogout();
                      },
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
