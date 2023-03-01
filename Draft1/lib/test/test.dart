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