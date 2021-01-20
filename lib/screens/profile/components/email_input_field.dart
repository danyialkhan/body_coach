import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  final String email;
  final String title;
  final Function onChanged;
  final Function validator;
  final String hint;

  EmailInputField({
    this.validator,
    this.onChanged,
    this.title,
    this.email,
    this.hint,
});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width *
              0.4,
          padding: EdgeInsets.only(
            left:
            MediaQuery.of(context).size.width *
                0.1,
            top:
            MediaQuery.of(context).size.height *
                0.02,
            bottom:
            MediaQuery.of(context).size.height *
                0.02,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: whiteShad,
              fontSize: MediaQuery.of(context)
                  .size
                  .height *
                  0.025,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width *
              0.6,
          padding: EdgeInsets.only(
            right:
            MediaQuery.of(context).size.width *
                0.1,
          ),
          child: TextFormField(
            initialValue: email,
            validator: validator,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            style: TextStyle(
              color: whiteShad,
              fontSize: MediaQuery.of(context)
                  .size
                  .height *
                  0.02,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
