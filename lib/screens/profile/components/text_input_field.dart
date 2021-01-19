import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String name;
  final String label;
  final String hintText;
  final Function onChanged;
  final Function validator;
  TextInputField({
    this.name,
    this.hintText,
    this.label,
    this.onChanged,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1,
            top: MediaQuery.of(context).size.height * 0.02,
            bottom: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.1,
          ),
          child: TextFormField(
            initialValue: name,
            validator: validator,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
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
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.height * 0.02,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
