import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydroferma5/home/mobile_dashboard.dart';

class MobileNav extends StatefulWidget {
  @override
  _MobileNavState createState() => _MobileNavState();
}

class _MobileNavState extends State<MobileNav> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 75.0,
          items: <Widget>[
            Icon(Icons.home_outlined, size: 28),
            Image.asset('images/water-tap.png', height: 25, width: 25),
            Image.asset('images/energy.png', height: 25, width: 25),
            Image.asset('images/agriculture.png', height: 25, width: 25),
            Image.asset('images/lifecycle.png', height: 25, width: 25),
            Icon(Icons.bluetooth, size: 28),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Color(0xD3E6F6FF),
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
              // print(index);
            });
          },
          letIndexChange: (index) => true,
        ),
        body: _page==0? Dashboard() : null,
    );
  }
}

