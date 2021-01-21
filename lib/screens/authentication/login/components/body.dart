import 'package:body_coach/screens/authentication/signup/signup_screen.dart';
import 'package:body_coach/screens/home/home_screen.dart';
import 'package:body_coach/services/auth.dart';
import 'package:body_coach/shared/already_have_an_account_acheck.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:body_coach/shared/rounded_button.dart';
import 'package:body_coach/shared/rounded_input_field.dart';
import 'package:body_coach/shared/rounded_password_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email;
  String _password;
  bool _isLoading = false;

  _toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final GlobalKey<FormState> _formKey = GlobalKey();
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              kLogIn,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.3),
            Container(
              height: size.height * 0.1,
              width: size.width * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(pLogoLightPath),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.1),
            RoundedInputField(
              hintText: kYourEmail,
              onChanged: (value) {
                _email = value;
              },
              onValidate: (value) {
                if (value.isEmpty || !value.contains('@')) {
                  return 'Invalid email!';
                }
                return null;
              },
            ),
            RoundedPasswordField(
              title: kTxtPassword,
              onChanged: (value) {
                _password = value;
              },
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: kPrimaryColor,
                    ),
                  )
                : RoundedButton(
                    text: kLogIn,
                    press: () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          _toggleIsLoading();
                          await Auth().signIn(_email, _password);
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (ctx) => HomeScreen()
                          ));
                          _toggleIsLoading();
                        } catch (e) {
                          _toggleIsLoading();
                          Fluttertoast.showToast(msg: "Invalid email or password", backgroundColor: Colors.redAccent);
                          print(e);
                        }
                      }
                    },
                  ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
