import 'package:body_coach/screens/authentication/login/login_screen.dart';
import 'package:body_coach/screens/wrapper.dart';
import 'package:body_coach/services/auth.dart';
import 'package:body_coach/shared/already_have_an_account_acheck.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:body_coach/shared/rounded_button.dart';
import 'package:body_coach/shared/rounded_input_field.dart';
import 'package:body_coach/shared/rounded_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isLoading = false;
  String _email;
  String _password;
  String _confirmPassword;


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
          children: <Widget>[
            Text(
              kSignUp,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              pSignUpSvg,
              height: size.height * 0.35,
            ),
           // SizedBox(height: size.height * 0.03),
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
              onValidate: (val) {
                if (val.isEmpty) {
                  return 'Please Enter a correct password!!!';
                } else if (val.length < 6) {
                  return 'Password must be at least six char long!!';
                }
                return null;
              },
            ),
            RoundedPasswordField(
              title: kTxtConfirmPassword,
              onChanged: (value) {
                _confirmPassword = value;
              },
              onValidate: (val) {
                if (_confirmPassword != _password) {
                  return 'Password do not match...';
                }
                return null;
              },
            ),
            _isLoading ?
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: kPrimaryColor,
                  ),
                )
                :RoundedButton(
              text: kSignUp,
              press: () async {
                try {
                  if (_formKey.currentState.validate()) {
                    _toggleIsLoading();
                    await Auth().signUp(_email, _password);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (ctx) => Wrapper()
                    ));
                    _toggleIsLoading();
                  }
                } catch (e) {
                  print(e);
                  _toggleIsLoading();
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: size.height * 0.05),
            //OrDivider(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     SocalIcon(
            //       iconSrc: pGoogleSvg,
            //       press: () {},
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
