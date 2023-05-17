import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydroferma5/croprecommendation/search.dart';
import 'package:hydroferma5/home/mobile_dashboard.dart';
import 'package:hydroferma5/lifecycle/lifecycle_cam.dart';
import 'package:hydroferma5/home/connected_system.dart';
import 'package:page_transition/page_transition.dart';

import '../login+register/login/login.dart';
import '../water+nutrient/water.dart';

class SidebarForHome extends StatefulWidget {
  const SidebarForHome({Key? key}) : super(key: key);

  @override
  State<SidebarForHome> createState() => _SidebarForHomeState();
}

class _SidebarForHomeState extends State<SidebarForHome> {
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
                        child: Text('Dashboard',
                            style:
                            TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Route route =
                          MaterialPageRoute(builder: (context) => Dashboard());
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
                        child: Text('Lifecycle',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Route route =
                              MaterialPageRoute(builder: (context) => LifecycleCam());
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
                        child: const Text('Connected System',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.bottomToTop,
                              child: const SystemOptions(),
                            ),
                          );
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
                        child: const Text('Log Out',
                            style:
                            TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          handleLogout();
                        },
                      ),
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

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
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

    void navigateTo(BuildContext context, Widget page) {
      Navigator.of(context).popUntil((route) {
        if (route.settings.name == page.toString()) {
          return true;
        } else {
          return false;
        }
      });

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
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
                        child: Text('Dashboard',
                            style:
                            TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Route route =
                          MaterialPageRoute(builder: (context) => Dashboard());
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
                        child: Text('Water & Nutrient Supply',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.bottomToTop,
                              child: const Water(),
                            ),
                          );
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
                              MaterialPageRoute(builder: (context) => LifecycleCam());
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
                        child: Text('Connected System',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.bottomToTop,
                              child: SystemOptions(),
                            ),
                          );
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
                        // Pop all pages and push the home page
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                          (route) => false,
                        );
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
