<<<<<<< Updated upstream
// padding: MediaQuery.of(context).size.width <= 450
// ? EdgeInsets.fromLTRB(
// 40, 150, 40, MediaQuery.of(context).size.height - 150)
//     : EdgeInsets.fromLTRB(100, 200, 100, 0),
// child: Column(
// children: <Widget>[
// Image.asset('images/logo-green.png'),
// SizedBox(
// height: 30,
// ),
// reusableTextField("Username", Icons.person_outline, false,
// _unameTextController),
// SizedBox(
// height: 20,
// ),
// reusableTextField(
// "Email Address", Icons.email, false, _emailTextController),
// SizedBox(
// height: 20,
// ),
// reusableTextField("Password", Icons.lock_person_outlined, false,
// _passwordTextController),
// Row(
// children: [
// Checkbox(
// value: this.value,
// onChanged: changeState,
// activeColor: Color(0xff48BFA3),
// side: MaterialStateBorderSide.resolveWith(
// (states) => BorderSide(width: 1.5, color: Colors.black45),
// ),
// ),
// Text('I agree to the ',
// style: TextStyle(color: Colors.black45)),
// Text('terms and conditions.',
// style: TextStyle(
// color: Colors.black45, fontWeight: FontWeight.bold)),
// ],
// ),
// LoginRegisterButton(context, 'Sign Up', () {
// signUpWithEmail(_emailTextController.text,
// _passwordTextController.text, _unameTextController.text);
// }),
// SizedBox(
// height: 30,
// ),
// LogInOption(),
=======
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PopupCarousel extends StatefulWidget {
  @override
  _PopupCarouselState createState() => _PopupCarouselState();
}

class _PopupCarouselState extends State<PopupCarousel> {
  int _currentIndex = 0;
  List<String> _imageList = [
    "https://picsum.photos/400/300?image=0",
    "https://picsum.photos/400/300?image=1",
    "https://picsum.photos/400/300?image=2",
    "https://picsum.photos/400/300?image=3",
    "https://picsum.photos/400/300?image=4",
    "https://picsum.photos/400/300?image=5",
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 400,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 1.0,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                              ),
                              items: _imageList.map((imageUrl) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: 1000.0,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _currentIndex = (_currentIndex - 1) % _imageList.length;
                                });
                              },
                              icon: Icon(Icons.arrow_back),
                            ),
                            Text(
                              '${_currentIndex + 1}/${_imageList.length}',
                              style: TextStyle(fontSize: 20),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _currentIndex = (_currentIndex + 1) % _imageList.length;
                                });
                              },
                              icon: Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              });
        },
        child: Text("Open Popup Carousel"),
      ),
    );
  }
}
>>>>>>> Stashed changes
