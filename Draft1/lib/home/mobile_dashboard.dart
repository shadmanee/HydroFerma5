import 'package:flutter/material.dart';
import 'package:hydroferma5/util/navbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xD3E6F6FF),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('DASHBOARD',),
            ElevatedButton(
              child: Text('Go To Page of index 1'),
              onPressed: () {
              },
            )
          ],
        ),
      ),
    );
  }
}
