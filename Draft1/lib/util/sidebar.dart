import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (e) {
        print(e);
      }
    }

    return Drawer(
      backgroundColor: const Color(0xff89B6DC),
      child: FutureBuilder(
        future: fetchUsername(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching user data'),
            );
          } else {
            return ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: const Color(0xff89B6DC),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.dstATop),
                      image: const AssetImage('images/amader-user.jpg'),
                    ),
                  ),
                  accountName: Text(_auth.currentUser!.displayName!),
                  accountEmail: Text(_auth.currentUser!.email!),
                  currentAccountPicture: Container(
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('images/amader-user.jpg'),
                    ),
                  ),
                ),
                Column(
                  children: [
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xff52799b);
                            }
                            return const Color(0xff6CA3D1);
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
                        child: const Text('Dashboard',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => const Dashboard());
                          Navigator.push(context, route);
                        },
                      ),
                    ),
                    const Divider(),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xff52799b);
                            }
                            return const Color(0xff6CA3D1);
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
                        child: const Text('Water & Nutrient Supply',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => const Water());
                          Navigator.push(context, route);
                        },
                      ),
                    ),
                    const Divider(),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xff52799b);
                            }
                            return const Color(0xff6CA3D1);
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
                        child: const Text('Lifecycle',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => const LifecycleCam());
                          Navigator.pushReplacement(context, route);
                        },
                      ),
                    ),
                    const Divider(),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xff52799b);
                            }
                            return const Color(0xff6CA3D1);
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
                    const Divider(),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xff52799b);
                            }
                            return const Color(0xff6CA3D1);
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
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (e) {
        print(e);
      }
    }

    return Drawer(
      backgroundColor: const Color(0xff89B6DC),
      child: FutureBuilder(
        future: fetchUsername(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching user data'),
            );
          } else {
            return ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: const Color(0xff89B6DC),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.dstATop),
                      image: const AssetImage('images/amader-user.jpg'),
                    ),
                  ),
                  accountName: Text(_auth.currentUser!.displayName!),
                  accountEmail: Text(_auth.currentUser!.email!),
                  currentAccountPicture: Container(
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('images/amader-user.jpg'),
                    ),
                  ),
                ),
                Column(
                  children: [
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xff52799b);
                            }
                            return const Color(0xff6CA3D1);
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
                        child: const Text('Dashboard',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => const Dashboard());
                          Navigator.push(context, route);
                        },
                      ),
                    ),
                    const Divider(),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xff52799b);
                            }
                            return const Color(0xff6CA3D1);
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
                        child: const Text('Water & Nutrient Supply',
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
                    const Divider(),
                    ConstrainedBox(
                      constraints:
                      const BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xff52799b);
                            }
                            return const Color(0xff6CA3D1);
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
                        child: const Text('Lifecycle',
                            style:
                            TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          Route route =
                          MaterialPageRoute(builder: (context) => const LifecycleCam());
                          Navigator.pushReplacement(context, route);
                        },
                      ),
                    ),
                    const Divider(),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xff52799b);
                            }
                            return const Color(0xff6CA3D1);
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
                          Navigator.pushReplacement(
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
                    const Divider(),
                    ConstrainedBox(
                      constraints:
                      const BoxConstraints.tightFor(height: 60, width: 280),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xff52799b);
                            }
                            return const Color(0xff6CA3D1);
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
                    const Divider(),
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
