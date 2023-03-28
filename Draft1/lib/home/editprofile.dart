import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../util/buttons.dart';
import '../util/colors.dart';
import '../util/text_fields.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _password1TextController = TextEditingController();
  TextEditingController _password2TextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  late String _photoUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showPassword1 = false;
  bool _showPassword2 = false;

  @override
  Widget build(BuildContext context) {
    _photoUrl = _auth.currentUser?.photoURL ?? '';
    return Scaffold(
      backgroundColor: const Color(0xff8BD9C7),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientList,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  )
                ],
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150.0),
                        border: Border.all(
                          width: 10,
                          color: const Color(0xff2C7C5A),
                        ),
                      ),
                      child: _photoUrl.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(_photoUrl),
                            )
                          : Image.asset('images/user-blue.png'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: IconButton(
                        icon: Image.asset('images/camera.png'),
                        onPressed: () {
                          //  TODO: implement edit image
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _usernameTextController,
                        obscureText: false,
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: _auth.currentUser?.displayName ?? ' Username',
                          labelStyle:
                              const TextStyle(color: Colors.black45, fontSize: 18),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(width: 0, style: BorderStyle.none),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _emailTextController,
                        obscureText: false,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: _auth.currentUser?.email ?? ' Email Address',
                          labelStyle:
                              const TextStyle(color: Colors.black45, fontSize: 18),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(width: 0, style: BorderStyle.none),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _phoneTextController,
                        obscureText: false,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: _auth.currentUser?.phoneNumber ?? ' Phone Number',
                          labelStyle:
                              const TextStyle(color: Colors.black45, fontSize: 18),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(width: 0, style: BorderStyle.none),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _password1TextController,
                        obscureText: !_showPassword1,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: ' Current Password',
                          labelStyle:
                              TextStyle(color: Colors.black45, fontSize: 18),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword1
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _showPassword1 = !_showPassword1;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _password2TextController,
                        obscureText: !_showPassword2,
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: ' New Password',
                          labelStyle:
                              TextStyle(color: Colors.black45, fontSize: 18),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword2
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _showPassword2 = !_showPassword2;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      LoginRegisterButton(context, 'Save', (){}),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
