// import 'package:flutter/material.dart';
//
// class LandingPage extends StatefulWidget {
//   const LandingPage({Key? key}) : super(key: key);
//
//   @override
//   _LandingPageState createState() => _LandingPageState();
// }
//
// class _LandingPageState extends State<LandingPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   bool _isVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize the animation controller
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );
//
//     // Create the animation
//     _animation = Tween<double>(begin: 1.0, end: 0.5).animate(_controller)
//       ..addListener(() {
//         setState(() {});
//       });
//
//     // Start the animation after a delay
//     Future.delayed(Duration(milliseconds: 500), () {
//       _controller.forward();
//     });
//
//     // Show the buttons after another delay
//     Future.delayed(Duration(milliseconds: 1000), () {
//       setState(() {
//         _isVisible = true;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             // Make the logo smaller and move it up
//             Transform.scale(
//               scale: _animation.value,
//               child: Transform.translate(
//                 offset: Offset(0, -50 * (1 - _animation.value)),
//                 child: Image.asset(
//                   'images/logo-green.png',
//                 ),
//               ),
//             ),
//             // Show the buttons from the bottom
//             if (_isVisible)
//               Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: Text('Button 1'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: Text('Button 2'),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
