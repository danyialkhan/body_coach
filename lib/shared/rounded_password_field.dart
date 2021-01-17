import 'package:body_coach/shared/text_field_container.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String title;
  final Function onValidate;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.title,
    this.onValidate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: true,
        onChanged: onChanged,
        validator: onValidate,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: title,
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          // suffixIcon: Icon(
          //   Icons.visibility,
          //   color: kPrimaryColor,
          // ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
